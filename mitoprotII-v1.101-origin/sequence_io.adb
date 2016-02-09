--------------------------------------------------------------------
-- MITOPROT                   Copyright ENS Ulm Paris France 1995-96
-- Pierre VINCENS                    V 01.000               04/12/95
--------------------------------------------------------------------

with Text_Io,Strlib;
use  Text_Io,Strlib;

package body Sequence_Io is

  package Int_Io is new Text_Io.Integer_Io(Integer);
  use Int_Io;

  Max_Sequence_Length : constant Integer := 100000;
  Max_Line_Length     : constant Integer := 100000;

  function Find(Texte : in String; Value : in String) return Boolean is
    Position : Integer;
  begin
    Position := Search(Texte,Value);
    return True;
  exception
    when STRING_NOT_FOUND => return False;
  end Find;

  function Root_Name(Src: in String) return String is
    Pos,Debut,Fin : Integer;
  begin
    if Src'Length = 0 then
      return "";
    end if;
    Debut := Src'First;
    Pos := Src'Last;
    Fin := Pos;
    while Pos >= Src'First loop
      case Src(Pos) is
        when '/' => Debut := Pos + 1; exit;
        when '.' => Fin := Pos - 1;
        when others => null;
      end case;
      Pos := Pos - 1;
    end loop;
    return Src(Debut..Fin);
  end Root_Name;

  procedure Read_Sequence_Ascii(Name     : in String;
                                Sequence : in out Sequence_Type) is
    -- on s'attend a trouver une sequence brute sans commentaire
    -- les lignes debutant par # ou > sont ignores
    Line      : String(1..Max_Line_Length);
    Length    : Natural;
    Seq       : String_Access;
    Lseq      : Natural := 0;        -- longueur de la sequence a lire
    Aseq      : Natural := 0;        -- longueur de la sequence lue
    File      : Text_Io.File_Type;
  begin
    -- Ouvrir le fichier contenant la sequence
    -- dans le format swissprot
    Open(File, In_File, Name);
    Sequence.Eukaryote := True;
    Sequence.Organelle := Unknown;
    Sequence.Fragment := False;
    -- le nom de la sequence est le nom du fichier que l'on a passe
    Sequence.Name := To_Varstring(Root_Name(Name));
    -- determiner la longueur de la sequence
    while not End_Of_File(File) loop
      Get_Line(File,Line,Length);
      for I in Line'first..Length loop
        exit when Line(I) = '#' or Line(I) = '>';
        if Is_Amino_Acid(Line(I)) then
          Lseq := Lseq + 1;
        end if;
      end loop;
    end loop;
    -- initialiser la sequence
    Seq := new String(1..Lseq);
    -- Boucle de lecture de la sequence
    Reset(File);
    while not End_Of_File(File) loop
      Get_Line(File,Line,Length);
      for I in Line'first..Length loop
        exit when Line(I) = '#' or Line(I) = '>';
        if Is_Amino_Acid(Line(I)) then
          Aseq := Aseq + 1;
          Seq(Aseq) := Line(I);
          exit when Aseq = Lseq;
        end if;
      end loop;
    end loop;
    Sequence.Composition := To_Varstring(Seq.all);
    Sequence.Mitochondrial := 0;
    Sequence.Chloroplastique := 0;
    Free(Seq);
  exception
    when END_ERROR =>
      -- La fin du fichier a ete atteinte anormalement
      Free(Seq);
      raise END_OF_SEQUENCE;
  end Read_Sequence_Ascii;

  procedure Read_Sequence_SW(Name : in String;
                             Sequence: in out Sequence_Type) is
    Line      : String(1..Max_Line_Length);
    Length    : Natural;
    Seq       : String_Access;
    Lseq      : Natural;             -- longueur de la sequence a lire
    Aseq      : Natural := 0;        -- longueur de la sequence lue
    Last      : Positive;
    M_Poids_1,M_Poids_2   : Integer := 0;
    C_Poids_1,C_Poids_2   : Integer := 0;
    File      : Text_Io.File_Type;
  begin
    -- Ouvrir le fichier contenant la sequence
    -- dans le format swissprot
    Open(File, In_File, Name);
    Sequence.Eukaryote := False;
    Sequence.Organelle := Unknown;
    Sequence.Fragment := False;
    -- Boucle de traitement de chaque ligne
    Traite_Ligne: loop
      -- lecture de ligne
      Get_Line(File,Line,Length);
      -- analyse de la ligne lue
      if Length < 2 then
        -- ligne vide, que l'on ignore
        null;
      elsif Line(1..2) = "ID" then
        -- on lit le nom de la sequence
        last := 6;
        while Line(last) /= ' ' and Line(last) /= ';' loop
          last := last + 1;
        end loop;
        Sequence.Name := To_Varstring(Line(6..last-1));
        -- on lit ...
        -- on lit le nombre d'acides amines et on initialise la chaine
        -- qui contiendra la sequence
        Get(Line(40..46),Lseq,Last);
        Seq := new String(1..Lseq);
      elsif Line(1..2) = "OC" then
        -- il faut regarder si il s'agit d'un eukaryote
        if Length >= 15 and then Line(6..15) = "EUKARYOTA;" then
          Sequence.Eukaryote := True;
        end if;
      elsif Line(1..2) = "OG" then
        -- il faut regarder si il s'agit d'un eukaryote
        if Length >= 18 and then Line(6..18) = "MITOCHONDRION" then
          Sequence.Organelle := Mitochondrie;
        elsif Length >= 16 and then Line(6..16) = "CHLOROPLAST" then
          Sequence.Organelle := Chloroplaste;
       end if;
      elsif Line(1..2) = "DE" then
        -- il faut regarder si il y a MITOCHON dans la ligne
        if Find(Line(4..Length),"MITOCHON") then
          M_Poids_1 := 1;
        end if;-- il faut regarder si il y a CHLOROPLAST dans la ligne
        if Find(Line(4..Length),"CHLOROPLAST") then
          C_Poids_1 := 1;
        end if;
        if Find(Line(4..Length),"FRAGMENT") then
          Sequence.Fragment := True;
        end if;
      elsif Line(1..2) = "CC" then
        -- il faut regarder si il y a LOCATION dans la ligne
        if  Find(Line(5..Length),"LOCATION") then
          -- regarder s'il y a MITOCHON dans la ligne
          if Find(Line(5..Length),"MITOCHON") then
            M_Poids_2 := 2;
          elsif Find(Line(5..Length),"CHLOROPLAST") then
            C_Poids_2 := 2;
          end if;
        end if;
      elsif Line(1..2) = "FT" then
        -- il faut regarder si il y a un transit
        if Length >= 47 and then Line(6..12) = "TRANSIT" and then
          Line(35..47) = "MITOCHONDRION" then
          M_Poids_2 := 2;
        elsif Length >= 45 and then Line(6..12) = "TRANSIT" and then
          Line(35..45) = "CHLOROPLAST" then
          C_Poids_2 := 2;
        end if;
      elsif Line(1..2) = "  " then
        -- on lit la sequence
        for I in 3..Length loop
          if Is_Amino_Acid(Line(I)) then
            Aseq := Aseq + 1;
            Seq(Aseq) := Line(I);
          end if;
        end loop;
        -- voir si la sequence a ete completement lue
        exit Traite_Ligne when Aseq = Lseq;
      elsif Line(1..2) = "//" then
        -- fin de la sequence
        exit Traite_Ligne;
      else
        -- on ignore les autres lignes
        null;
      end if;
    end loop Traite_Ligne;
    Sequence.Composition := To_Varstring(Seq.all);
    Sequence.Mitochondrial := M_Poids_1 + M_Poids_2;
    Sequence.Chloroplastique := C_Poids_1 + C_Poids_2;
    Free(Seq);
  exception
    when END_ERROR =>
      -- La fin du fichier a ete atteinte
      Free(Seq);
      raise END_OF_SEQUENCE;
  end Read_Sequence_SW;

  procedure Read_Sequence_PIR(Name : in String;
                              Sequence: in out Sequence_Type) is
    Line      : String(1..Max_Line_Length);
    Length    : Natural;
    Seq       : String_Access;
    Lseq      : Natural;             -- longueur de la sequence a lire
    Aseq      : Natural := 0;        -- longueur de la sequence lue
    Last      : Positive;
    M_Poids_1,M_Poids_2   : Integer := 0;
    C_Poids_1,C_Poids_2   : Integer := 0;
    File      : Text_Io.File_Type;
    In_Sequence : Boolean := False;
  begin
    -- Ouvrir le fichier contenant la sequence
    -- dans le format PIR
    Open(File, In_File, Name);
    -- ATTENTION ce type d'information n'est pas traite
    Sequence.Eukaryote := true;
    Sequence.Organelle := Unknown;
    Sequence.Fragment := False;
    -- Boucle de traitement de chaque ligne
    Traite_Ligne: loop
      -- lecture de ligne
      Get_Line(File,Line,Length);
      -- analyse de la ligne lue
      if Length < 3 then
        if Length = 0 then
        -- ligne vide, que l'on ignore sauf si c'est la premiere fois
        -- ou on doit recuperer la longueur de la sequence
           if not In_Sequence then
            -- on est peut etre sur la ligne de description de la sequence
            Get_Line(File,Line,Length);
            if Length >= 2+Sequence.Name.Value.all'length --and then
             -- Line(3..2+Sequence.Name.Value.all'length) =
              --Sequence.Name.Value.all
            then
              -- on lit la longueur de la sequence
              last := Sequence.Name.Value.all'length + 3;
              while Line(last) /= ':' and Last < length loop
                last := last + 1;
              end loop;
              Last := Last + 1;
              -- on lit le nombre d'acides amines et on initialise la chaine
              -- qui contiendra la sequence
              if Last < Length then
                Get(Line(Last..length),Lseq,Last);
                Seq := new String(1..Lseq);
                In_Sequence := True;
              end if;
            end if;
          end if;
        end if;
      elsif Line(1..3) = "P1;" then
        -- on lit le nom de la sequence
        last := 4;
        while Line(last) /= ' ' and Line(last) /= ';' loop
          last := last + 1;
        end loop;
        Sequence.Name := To_Varstring(Line(4..last-1));
      elsif Line(1..2) = "  " then
        -- on verifie si l'on a commence a lire la sequence
        if In_Sequence then
          -- on est en train de lire la sequence
          if Length > 11 then
            for I in 11..Length loop
              if Is_Amino_Acid(Line(I)) then
                Aseq := Aseq + 1;
                Seq(Aseq) := Line(I);
              end if;
            end loop;
          end if;
          -- voir si la sequence a ete completement lue
          exit Traite_Ligne when Aseq = Lseq;
        end if;
      elsif Line(1..2) = "//" then
        -- fin de la sequence
        exit Traite_Ligne;
      else
        -- on ignore les autres lignes
        null;
      end if;
    end loop Traite_Ligne;
    Sequence.Composition := To_Varstring(Seq.all);
    Sequence.Mitochondrial := M_Poids_1 + M_Poids_2;
    Sequence.Chloroplastique := C_Poids_1 + C_Poids_2;
    Free(Seq);
  exception
    when END_ERROR =>
      -- La fin du fichier a ete atteinte
      Put_Line("Sequence lu: " & Integer'Image(Aseq) & Integer'Image(Lseq));
      Free(Seq);
      raise END_OF_SEQUENCE;
  end Read_Sequence_PIR;

  procedure Read_Sequence_GCG(Name : in String;
                              Sequence: in out Sequence_Type) is
    Line      : String(1..Max_Line_Length);
    Length    : Natural;
    Seq       : String_Access;
    Lseq      : Natural;             -- longueur de la sequence a lire
    Aseq      : Natural := 0;        -- longueur de la sequence lue
    Position  : Integer := 1;
    Mot       : Varstring;
    File      : Text_Io.File_Type;
    In_Sequence : Boolean := False;
  begin
    -- Ouvrir le fichier contenant la sequence
    -- dans le format PIR
    Open(File, In_File, Name);
    -- ATTENTION ce type d'information n'est pas traite
    Sequence.Eukaryote := true;
    Sequence.Organelle := Unknown;
    Sequence.Fragment := False;
    -- Boucle de traitement de chaque ligne
    En_Tete: loop
      -- lecture de ligne
      Get_Line(File,Line,Length);
      -- analyse de la ligne lue
      if Length > 10 and then Line(Length-1..Length) = ".." then
        -- on a atteind la ligne de definition de la sequence
        -- le premier mot est le nom de la sequence
	Position := 1;
        Next_Word(Line(Position..Length),Sequence.Name,Position," ");
        Next_Word(Line(Position..Length),Mot,Position);
        if Mot.Value.all = "Length" then
          -- on a bien ce qui est attendu
          Position := Position+1;
          Get(Line(Position..Length),Lseq,Position);
          exit En_Tete;
        end if;
      end if;
    end loop En_Tete;
    -- initialisation de la variable sequence
    Seq := new String(1..Lseq);
    -- lecture de la sequence
    while not End_Of_File(File) loop
      Get_Line(File,Line,Length);
      if Length > 0 then
        for I in 11..Length loop
          if Is_Amino_Acid(Line(I)) then
            Aseq := Aseq + 1;
            Seq(Aseq) := Line(I);
          end if;
        end loop;
      end if;
    end loop;
    Close(File);
    Sequence.Composition.Value := Seq;
    Sequence.Mitochondrial := 0;
    Sequence.Chloroplastique := 0;
  exception
    when END_ERROR =>
      -- La fin du fichier a ete atteinte
      Put_Line("Sequence lu: " & Integer'Image(Aseq) & Integer'Image(Lseq));
      Free(Seq);
      raise END_OF_SEQUENCE;
  end Read_Sequence_GCG;

  procedure Check_Sequence(Name     : in String;
                           Sequence : in out Sequence_Type) is
    Line      : String(1..Max_Line_Length);
    Length    : Natural;
    File      : Text_Io.File_Type;
  begin
    -- Ouvrir le fichier contenant la sequence
    Open(File, In_File, Name);
    -- lire la premiere ligne
    Get_Line(File,Line,Length);
    if Length >= 2 and then Line(1..2) = "ID" then
      -- sequence swissprot
      Close(File);
      Read_Sequence_SW(Name, Sequence);
    elsif Length >= 3 and then Line(1..3) = "P1;" then
      -- sequence swissprot
      Close(File);
      Read_Sequence_PIR(Name, Sequence);
    else
      -- type de fichier inconnu, supposons que c'est de l'ascii
      Close(File);
      Read_Sequence_Ascii(Name, Sequence);
      --raise SEQUENCE_FORMAT_ERROR;
    end if;
  end Check_Sequence;

  procedure Read_Sequence(Name     : in String;
                          Sequence : in out Sequence_Type;
                          format   : in sequence_format := Unknown) is
  begin
    case Format is
      when Ascii =>
        Read_Sequence_Ascii(Name, Sequence);
      when GCG =>
        Read_Sequence_GCG(Name, Sequence);
      when PIR =>
        Read_Sequence_PIR(Name, Sequence);
      when Swissprot =>
        Read_Sequence_SW(Name, Sequence);
      when others =>
        Check_Sequence(Name, Sequence);
    end case;
  end Read_Sequence;

end Sequence_Io;
