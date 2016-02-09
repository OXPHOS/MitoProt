--------------------------------------------------------------------
-- MITOPROT                   Copyright ENS Ulm Paris France 1995-99
-- Pierre VINCENS                    V 01.000               04/12/95
-- Pierre VINCENS                    V 01.001               20/05/98
-- Pierre VINCENS                    V 01.002               01/12/99
-- Pierre VINCENS                    V 01.003               15/12/99
-- Pierre VINCENS                    V 01.004               16/12/99
--------------------------------------------------------------------
-- v1.001
--   Support du format de fichier GCG
--   Creation du fichier summary si l'option -o est activee et que
--   ce fichier n'existe pas
-- v1.002
--   Correction du calcul de f(arg) qui est determine maintenant par
--   rapport a ZoneTo
-- v1.003
--   Correction d'un bug sur les indices de sequences dans coef_20 
-- v1.004
--   Correction d'un bug sur les indices de sequences dans cleavage
-- v1.100
--   Cumul des corrections faites sur la validation des indices de
--   sequences. Une partie des tests est desormais fait explicitement
-- v1.101
--   Ajout d'un pragma elaborate_body dans sequence_package.ads
--------------------------------------------------------------------

with Type_Specifications; use  Type_Specifications;
with Strlib; use Strlib;

with Sequence_Package; use Sequence_Package;
with Sequence_Io; use Sequence_Io;
 
with Mito_Parameters; use Mito_Parameters;

with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Io_Exceptions; use Ada.Io_Exceptions;
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Command_Line; use Ada.Command_Line;

procedure Mitoprot is

  version : constant string := "1.101";

  Argument_Error : exception;

  package Int_Io is new Ada.Text_Io.Integer_Io(integer);
  use Int_Io;

  package Real_Io is new Ada.Text_Io.Float_Io(Real);
  use Real_Io;
  package Real_Lib is new Ada.Numerics.Generic_Elementary_Functions(Real);
  use Real_Lib;

  type Options_Type is record
    Name    : Varstring;
    Summary : Boolean := false;
    S_Name  : Varstring;
    Format  : Character;
  end record;

  type Frequency is array(Integer range <>,Integer range <>) of Integer;

  type Choice_Param_Type is (Param_2,Param_6);

  type IDE_Type is record
    Hydromax      : Real;
    Mesohydro     : Real;
    Mhm_75        : MHM_Type;
    Mhm_95        : MHM_Type;
    Mhm_100       : MHM_Type;
    Mhm_105       : MHM_Type;
    Hmx_75        : Real;
    Hmx_95        : Real;
    Hmx_100       : Real;
    Hmx_105       : Real;
  end record;
  type IDE_Array is array(Echelle_Hydrophobicite range <>) of IDE_Type;

  type Info_Sequence is record
    -- nom et longueur
    Name          : String(1..15);
    Length        : Natural;
    Organelle     : Character;
    Mito          : Integer;
    Chloro        : Integer;
    -- zone d'adressage
    Zone          : Zone_Adressage;
    -- parametres independant de la zone d'adressage
    Coef_20       : Real;
    Charge_Diff   : Integer;
    -- parametres dependant de la zone d'adressage
    KR            : Natural;
    DE            : Natural;
    Coef_Tot      : Real;
    Site_Cleavage : Natural;
    -- parametres indexes sur une echelle d'hydrophobicite
    Ide           : Ide_Array(Eges..Eaah);
  end record;

  type Vector_Type is array(Integer range <>) of Real;
  type Vector_Access is access Vector_Type;

  Nc :  Integer := 2;

  Input    : Ada.Text_Io.File_Type;
  In_param : Ada.Text_Io.File_Type;
  Output   : Ada.Text_Io.File_Type;
  S_Output : Ada.Text_Io.File_Type;
  Sequence : Sequence_Type;
  Info     : Info_Sequence;
  Zone     : Zone_Adressage renames info.zone;
  Param    : Matrix_Access := Mito_Parameters.Param_2;
  Ev       : Vector_Access;
  K        : Integer;
  Sum      : Real;
  Count    : Integer := 0;
  Options  : Options_Type;

  Choice_Param  : Choice_Param_Type := Param_2;
  Choice_Format : Sequence_Format := Unknown;

  procedure Get_Options(Options : in out Options_Type) is
    Count : Positive := 1;
    function Opt_Int(Adr : in Integer) return Integer is
      Str : constant String := Argument(Adr);
      Last,Value : Integer;
    begin
      Get(Str,Value,Last);
      return Value;
    end Opt_Int;
    function Opt_Char(Adr : in Integer) return Character is
      Str : constant String := Argument(Adr);
    begin
      return Str(Str'First);
    end Opt_Char;
  begin
    while Count < Argument_Count loop
      if Argument(Count) = "-f" then
        -- lire le modele de sequence d'entree
        Count := Count + 1;
        Options.Format := Opt_Char(Count);
        -- valider l'option
        case Options.Format is
          when 'a'      =>
            Choice_Format := Sequence_Io.Ascii;
          when 'g'      =>
            Choice_Format := gcg;
          when 's'      =>
            Choice_Format := swissprot;
          when 'p'      =>
            Choice_Format := pir;
          when others =>
            raise ARGUMENT_ERROR;
        end case;
      elsif Argument(Count) = "-o" then
        Count := Count + 1;
        Copy(Argument(Count),Options.S_Name);
        Options.Summary := True;
      else
        raise ARGUMENT_ERROR;
      end if;
      Count := Count + 1;
    end loop;
    -- il reste a lire le nom du fichier contenant la sequence
    if Count /= Argument_Count then
      -- il devrait laisser un argument a lire
      raise ARGUMENT_ERROR;
    end if;
    Copy(Argument(count),Options.Name);
  end Get_Options;

begin
  -- Traiter les arguments
  begin
    Get_Options(Options);
  exception
    when ARGUMENT_ERROR =>
      Put_Line("Mitoprot: argument error");
      Put_Line("  syntax is: mitoprot  [-f a|g|p|s] [-o <name>] sequence_file");
      New_Line;
      Put_Line("  f = format: a = ascii, g = gcg, p = pir, s = swissprot");
      Put_Line("  o = summary file");
      New_Line;
      Ada.Text_Io.Put_Line("Your command was:");
      Ada.Text_Io.Put_Line(" -> " & Command_Name);
      return;
  end;

  -- lire le fichier contenant la sequence
  Read_sequence(Options.Name.Value.all,Sequence,Choice_Format);

  -- ouvrir le fichier de resultats sommaire
  if Options.Summary then
    begin
      Open(S_Output,Append_File,To_String(Options.S_Name));
    exception
      when Ada.Io_Exceptions.Name_Error =>
	-- On cree le fichier qui n'existe pas
	Create(S_Output,Out_File,To_String(Options.S_Name));
    end;
  end if;

  -- Rejeter si la sequence ne verifie pas quelques proprietes
  if not Sequence.Eukaryote or
    Sequence.Fragment or
    Length(Sequence.Composition) <= 17 or
    Sequence.Composition.Value(1) /= 'M' then
    Put_Line("The sequence " & Sequence.Name &
             " has not required properties");
    if Options.Summary then
      Put(S_Output,Sequence.Name);
      Set_col(S_Output,20);
      Put(S_Output,Length(Sequence.Composition),10);
      Put(S_Output,0.0,5,4,0);
      Put(S_Output,0.0,5,4,0);
      Put(S_Output,0.0,5,4,0);
      Put(S_Output,0.0,5,4,0);
      New_Line(S_Output);
      Close(S_Output);
    end if;
    return;
  end if;

  -- informer l'utilisateur de la localisation des resultats
  Put_Line("Complet results are writed in " &
           Root_Name(To_String(Options.Name)) & ".mitoprot");

  -- Ouvrir le fichier pour stocker les resultats
  Create(Output,Out_File,Root_Name(To_String(Options.Name))&".mitoprot");
  New_Line(Output);

  -- Ecrire le preambule
  Put_Line(Output,"                         MitoProt II - v" & version);
  New_Line(Output);
  Put_Line(Output,"File            : " & Options.Name.Value.all);
  Put_Line(Output,"Sequence name   : " & Sequence.Name);
  Put(Output,"Sequence length : ");
  Put(Output,Length(Sequence.Composition),0);

  if (Sequence.Organelle = Mitochondrie or
      Sequence.Organelle = Chloroplaste) then
    --or  Info.Mito = 1 then
    New_Line(Output);
    Put_Line(Output," WARNING: This sequence is not nuclear!");
    New_Line(Output);
  end if;

  -- Determiner la zone d'adressage
  -- Calculer les parametres de la sequence
  -- independant de la sequence d'adressage
  Info.Coef_20 := Coef_20(Sequence);
  Info.Charge_Diff := Charge_Diff(Sequence);
  -- ceux dependant de la sequence d'adressage
  Zone := define_zone_adressage(sequence);
  info.KR := number_of(sequence,zone.from,zone.to,('k','K','r','R'));
  info.DE := number_of(sequence,zone.from,zone.to,('d','D','e','E'));
  info.coef_tot := coef_total(sequence,zone.from,zone.to);
  info.site_cleavage := cleavage(sequence,zone.from,zone.to);
  -- et ceux variant avec l'echelle
  for I in Info.Ide'Range loop
    Info.Ide(I).hydromax := Hydrophobicite_Maximale(Sequence,17,I);
    Info.Ide(I).Mesohydro := Mesohydrophobicite(Sequence,60,80,I);
    Info.Ide(I).Mhm_75 := moment_hydrophobicite_maximum(Sequence,
                                                   Zone.From,Zone.To,75,I);
    Info.Ide(I).Mhm_95 := moment_hydrophobicite_maximum(Sequence,
                                                   Zone.From,Zone.To,95,I);
    Info.Ide(I).Mhm_100 := moment_hydrophobicite_maximum(Sequence,
                                                    Zone.From,Zone.To,100,I);
    Info.Ide(I).Mhm_105 := moment_hydrophobicite_maximum(Sequence,
                                                    Zone.From,Zone.To,105,I);
    Info.Ide(I).Hmx_75  := Hmx(Sequence,Info.Ide(I).Mhm_75.Pos,Weight_75,I);
    Info.Ide(I).Hmx_95  := Hmx(Sequence,Info.Ide(I).Mhm_95.Pos,Weight_95,I);
    Info.Ide(I).Hmx_100 := Hmx(Sequence,Info.Ide(I).Mhm_100.Pos,Weight_100,I);
    Info.Ide(I).Hmx_105 := Hmx(Sequence,Info.Ide(I).Mhm_105.Pos,Weight_105,I);
  end loop;

  -- Imprimer la valeur des parametres calcules
  New_Line(Output,2);
  Put_Line(Output,"                 VALUES OF COMPUTED PARAMETERS");
  New_Line(Output,2);
  Put(Output,"Coef20      : ");
  Put(Output,Info.Coef_20,6,3,0);
  New_Line(Output);
  Put(Output,"CoefTot     : ");
  Put(Output,Info.Coef_Tot,6,3,0);
  New_Line(Output);
  Put(Output,"ChDiff      : ");
  Put(Output,Info.Charge_Diff,6);
  New_Line(Output);
  Put(Output,"ZoneTo      : ");
  Put(Output,Info.zone.to,6);
  New_Line(Output);
  Put(Output,"KR          : ");
  Put(Output,Info.KR,6);
  New_Line(Output);
  Put(Output,"DE          : ");
  Put(Output,Info.DE,6);
  New_Line(Output);
  Put(Output,"CleavSite   : ");
  Put(Output,Info.Site_Cleavage,6);
  New_Line(Output,2);
  Put_Line(Output,"                         HYDROPHOBIC SCALE USED");
  Put_Line(Output,"                    GES       KD       GVH1       ECS");
  -- for I in Info.Ide'Range loop
  --     Put(Output,"  " & Echelle_Hydrophobicite'Image(I) & "    ");
  --   end loop;
  New_Line(Output);
  Put(Output,"H17         : ");
  for I in Info.Ide'Range loop
    Put(Output,Info.Ide(I).hydromax,6,3,0);
  end loop;
  New_Line(Output);
  Put(Output,"MesoH       : ");
  for I in Info.Ide'Range loop
    Put(Output,Info.Ide(I).mesohydro,6,3,0);
  end loop;
  New_Line(Output);
  Put(Output,"MuHd_075    : ");
  for I in Info.Ide'Range loop
    Put(Output,Real(Info.Ide(I).Mhm_75.Muh),6,3,0);
  end loop;
  New_Line(Output);
  Put(Output,"MuHd_095    : ");
  for I in Info.Ide'Range loop
   Put(Output,Real(Info.Ide(I).Mhm_95.Muh),6,3,0);
  end loop;
  New_Line(Output);
  Put(Output,"MuHd_100    : ");
  for I in Info.Ide'Range loop
    Put(Output,Real(Info.Ide(I).Mhm_100.Muh),6,3,0);
  end loop;
  New_Line(Output);
  Put(Output,"MuHd_105    : ");
  for I in Info.Ide'Range loop
    Put(Output,Real(Info.Ide(I).Mhm_105.Muh),6,3,0);
  end loop;
  New_Line(Output);
  Put(Output,"Hmax_075    : ");
  for I in Info.Ide'Range loop
    Put(Output,Real(Info.Ide(I).Hmx_75),6,3,0);
  end loop;
  New_Line(Output);
  Put(Output,"Hmax_095    : ");
  for I in Info.Ide'Range loop
    Put(Output,Real(Info.Ide(I).Hmx_95),6,3,0);
  end loop;
  New_Line(Output);
  Put(Output,"Hmax_100    : ");
  for I in Info.Ide'Range loop
    Put(Output,Real(Info.Ide(I).Hmx_100),6,3,0);
  end loop;
  New_Line(Output);
  Put(Output,"Hmax_105    : ");
  for I in Info.Ide'Range loop
    Put(Output,Real(Info.Ide(I).Hmx_105),6,3,0);
  end loop;
  New_Line(Output,3);

  -- Creer le tableau pour stocker le resultat des classes
  Ev := new Vector_Type(1..Nc);

  -- preparer l'affichage pour le fichier resume si necessaire
  if Options.Summary then
    Put(S_Output,Sequence.Name);
    Set_col(S_Output,20);
    Put(S_Output,Length(Sequence.Composition),10);
  end if;

    -- Calculer les probabilites pour les deux jeux de parametres
  Put_Line(Output,"CLASS                 NOT-MITO    MITO(/CHLORO)");
  for choice in Choice_Param_Type'range loop
    case Choice is
      when Param_2 =>
        Param := Mito_Parameters.Param_2;
      when Param_6 =>
        Param := Mito_Parameters.Param_6;
    end case;

    -- calculer la valeur des coefficients
    K := Ev'First;
    for I in Param'Range(1) loop
      Count := Param'First(2);
      Ev(K) := Param(I,Count) +
        param(I,Count + 1) * Info.Coef_20 +
        param(I,Count + 2) * Real(Info.Charge_Diff) +
        param(I,Count + 3) * Real(Info.zone.to) +
        param(I,Count + 4) * Real(Info.KR) +
        param(I,Count + 5) * Real(Info.DE) +
        param(I,Count + 6) * Info.Coef_Tot +
        param(I,Count + 7) * Real(Info.Site_Cleavage);
      Count := Count + 8;
      for J in Info.Ide'Range loop
        Ev(K) := Ev(K) +
          param(I,Count ) * Info.Ide(J).Hydromax +
          param(I,Count+1) * Info.Ide(J).Mesohydro +
          param(I,Count+2) * Real(Info.Ide(J).Mhm_75.Muh) +
          param(I,Count+3) * Real(Info.Ide(J).Mhm_95.Muh) +
          param(I,Count+4) * Real(Info.Ide(J).Mhm_100.Muh) +
          param(I,Count+5) * Real(Info.Ide(J).Mhm_105.Muh) +
          param(I,Count+6) * Real(Info.Ide(J).Hmx_75) +
          param(I,Count+7) * Real(Info.Ide(J).Hmx_95) +
          param(I,Count+8) * Real(Info.Ide(J).Hmx_100) +
          param(I,Count+9) * Real(Info.Ide(J).Hmx_105);
        Count := Count + 10;
      end loop;
      K := K + 1;
    end loop;
    -- Calcul des probabilites associees
    Sum := 0.0;
    for I in Ev'Range loop
      Ev(I) := Exp(Ev(I));
      Sum := Sum + Ev(I);
    end loop;
    case Choice is
      when Param_2 => Put(Output,"DFM         :  ");
      when Param_6 => Put(Output,"DFMC        :  ");
    end case;
    for I in Ev'Range loop
      Ev(I) := Ev(I)/Sum;
      Put(Output,Ev(I),9,4,0);
      if Options.Summary then
        Put(S_Output,Ev(I),5,4,0);
      end if;
    end loop;
    New_Line(Output);
  end loop;
  if Ev(Ev'First) < 0.5 then
    -- calculer les frequences de S et R dans la zone d'adressage
    -- et la sequence complete
    declare
      F_S : constant Real := Frequence(Sequence,'S',Zone.From,Zone.To);
      F_R : constant Real := Frequence(Sequence,'R',Zone.From,Zone.To);
      Cmi : Real := F_S / (0.07 + 1.4 * F_R);
    begin
      New_Line(Output);
      if F_S < 0.07 + 1.4 * F_R then
        Put_Line(Output,"This protein is probably imported in mitochondria.");
      else
        Put_Line(Output,"This protein is probably imported in chloroplast.");
      end if;
      Put(Output,"   f(Ser) = "); Put(Output,F_S,2,4,0);
      Put(Output,"   f(Arg) = "); Put(Output,F_R,2,4,0);
      Put(Output,"   CMi = "); Put(Output,Cmi,8,5,0);
      New_Line(Output);
      Put_Line(Output,"   CMi is the Chloroplast/Mitochondria Index");
      Put_Line(Output,"   It has been proposed by Von Heijne et al ");
      Put_Line(Output,"   (Eur J Biochem,1989, 180: 535-545)");
      New_Line(Output);
    end;
  end if;
  -- Fermer les fichiers de resultats
  Close(Output);
  if Options.Summary then
    New_Line(S_Output);
    Close(S_Output);
  end if;
exception
  when ADA.IO_EXCEPTIONS.NAME_ERROR =>
    Put(Options.Name);
    Put_Line(" not found. Please check");
end Mitoprot;
