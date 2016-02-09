--------------------------------------------------------------------
-- MITOPROT                   Copyright ENS Ulm Paris France 1995-96
-- Pierre VINCENS                    V 01.000               04/12/95
--------------------------------------------------------------------

with Text_io;
use  Text_io;
with Ada.Numerics.Generic_Elementary_Functions;

package body Sequence_Package is

  package Real_Io is new Text_Io.Float_Io(Real);
  use Real_Io;
  package Real_Lib is new Ada.Numerics.Generic_Elementary_Functions(Real);
  use Real_Lib;

  Min_Length_For_Msh: constant Integer := 60;
  Max_Length_For_Msh: constant Integer := 80;

  function GES(Value: in Character) return Real is
  begin
    case Value is
      when 'A' | 'a' => return   1.60;
      when 'B' | 'b' => return  -7.00;
      when 'C' | 'c' => return   2.00;
      when 'D' | 'd' => return  -9.20;
      when 'E' | 'e' => return  -8.20;
      when 'F' | 'f' => return   3.70;
      when 'G' | 'g' => return   1.00;
      when 'H' | 'h' => return  -3.00;
      when 'I' | 'i' => return   3.10;
      when 'K' | 'k' => return  -8.80;
      when 'L' | 'l' => return   2.80;
      when 'M' | 'm' => return   3.40;
      when 'N' | 'n' => return  -4.80;
      when 'P' | 'p' => return  -0.20;
      when 'Q' | 'q' => return  -4.10;
      when 'R' | 'r' => return -12.30;
      when 'S' | 's' => return   0.60;
      when 'T' | 't' => return   1.20;
      when 'V' | 'v' => return   2.60;
      when 'W' | 'w' => return   1.90;
      when 'X' | 'x' => return   0.00;
      when 'Y' | 'y' => return  -0.70;
      when 'Z' | 'z' => return  -6.15;
      when '*'       => return   0.00;
      when others => raise UNKNOWN_AA;
    end case;
  end GES;

  function EKD(Value: in Character) return Real is
  begin
    case Value is
      when 'A' | 'a' => return   1.80;
      when 'B' | 'b' => return  -3.50;
      when 'C' | 'c' => return   2.50;
      when 'D' | 'd' => return  -3.50;
      when 'E' | 'e' => return  -3.50;
      when 'F' | 'f' => return   2.80;
      when 'G' | 'g' => return  -0.40;
      when 'H' | 'h' => return  -3.20;
      when 'I' | 'i' => return   4.50;
      when 'K' | 'k' => return  -3.90;
      when 'L' | 'l' => return   3.80;
      when 'M' | 'm' => return   1.90;
      when 'N' | 'n' => return  -3.50;
      when 'P' | 'p' => return  -1.60;
      when 'Q' | 'q' => return  -3.50;
      when 'R' | 'r' => return  -4.50;
      when 'S' | 's' => return  -0.80;
      when 'T' | 't' => return  -0.70;
      when 'V' | 'v' => return   4.20;
      when 'W' | 'w' => return  -0.90;
      when 'X' | 'x' => return  -0.49;
      when 'Y' | 'y' => return  -1.30;
      when 'Z' | 'z' => return  -3.50;
      when '*'       => return  -0.49;
      when others => raise UNKNOWN_AA;
    end case;
  end EKD;

  function GVH(Value: in Character) return Real is
  begin
    case Value is
      when 'A' | 'a' => return   0.267;
      when 'B' | 'b' => return  -2.145;
      when 'C' | 'c' => return   1.806;
      when 'D' | 'd' => return  -2.303;
      when 'E' | 'e' => return  -2.442;
      when 'F' | 'f' => return   0.427;
      when 'G' | 'g' => return   0.160;
      when 'H' | 'h' => return  -2.189;
      when 'I' | 'i' => return   0.971;
      when 'K' | 'k' => return  -2.996;
      when 'L' | 'l' => return   0.623;
      when 'M' | 'm' => return   0.136;
      when 'N' | 'n' => return  -1.988;
      when 'P' | 'p' => return  -0.451;
      when 'Q' | 'q' => return  -1.814;
      when 'R' | 'r' => return  -2.749;
      when 'S' | 's' => return  -0.119;
      when 'T' | 't' => return  -0.083;
      when 'V' | 'v' => return   0.721;
      when 'W' | 'w' => return  -0.875;
      when 'X' | 'x' => return  -0.664;
      when 'Y' | 'y' => return  -0.386;
      when 'Z' | 'z' => return  -2.128;
      when '*'       => return  -0.49;
      when others => raise UNKNOWN_AA;
    end case;
  end GVH;

  function AAH(Value: in Character) return Real is
  -- Calcul de la Aa_Hydrophobicite
  begin
    case Value is
      when 'A' | 'a' => return   0.620;
      when 'B' | 'b' => return  -0.840;
      when 'C' | 'c' => return   0.290;
      when 'D' | 'd' => return  -0.900;
      when 'E' | 'e' => return  -0.740;
      when 'F' | 'f' => return   1.200;
      when 'G' | 'g' => return   0.480;
      when 'H' | 'h' => return  -0.400;
      when 'I' | 'i' => return   1.400;
      when 'K' | 'k' => return  -1.500;
      when 'L' | 'l' => return   1.100;
      when 'M' | 'm' => return   0.640;
      when 'N' | 'n' => return  -0.780;
      when 'P' | 'p' => return   0.120;
      when 'Q' | 'q' => return  -0.850;
      when 'R' | 'r' => return  -2.500;
      when 'S' | 's' => return  -0.180;
      when 'T' | 't' => return  -0.050;
      when 'V' | 'v' => return   1.100;
      when 'W' | 'w' => return   0.810;
      when 'X' | 'x' => return   0.000;
      when 'Y' | 'y' => return   0.260;
      when 'Z' | 'z' => return  -0.795;
      when '*'       => return   0.000;
      when others => raise UNKNOWN_AA;
    end case;
  end AAH;

  function Is_Amino_Acid(Value: in Character) return Boolean is
  begin
    return
      Value = 'A' or Value = 'a' or
      Value = 'B' or Value = 'b' or
      Value = 'C' or Value = 'c' or
      Value = 'D' or Value = 'd' or
      Value = 'E' or Value = 'e' or
      Value = 'F' or Value = 'f' or
      Value = 'G' or Value = 'g' or
      Value = 'H' or Value = 'h' or
      Value = 'I' or Value = 'i' or
      Value = 'K' or Value = 'k' or
      Value = 'L' or Value = 'l' or
      Value = 'M' or Value = 'm' or
      Value = 'N' or Value = 'n' or
      Value = 'P' or Value = 'p' or
      Value = 'Q' or Value = 'q' or
      Value = 'R' or Value = 'r' or
      Value = 'S' or Value = 's' or
      Value = 'T' or Value = 't' or
      Value = 'V' or Value = 'v' or
      Value = 'W' or Value = 'w' or
      Value = 'X' or Value = 'x' or
      Value = 'Y' or Value = 'y' or
      Value = 'Z' or Value = 'z' or
      Value = '*';
  end Is_Amino_Acid;

  function Is_Amino_Acid(Value : in Character;
                         List  : in String) return Boolean is
  begin
    for I in List'range loop
      if Value = List(I) then
        return True;
      end if;
    end loop;
    return False;
  end Is_Amino_Acid;

  function Hydrophobicite_Moyenne(Sequence : in String;
                                  Echelle  : in Echelle_Hydrophobicite := Eges)
                                  return Real is
    Somme : Real := 0.0;
  begin
    for I in Sequence'range loop
      case Echelle is
        when Eges => Somme := Somme + GES(Sequence(I));
        when Eekd => Somme := Somme + EKD(Sequence(I));
        when Egvh => Somme := Somme + GVH(Sequence(I));
        when Eaah => Somme := Somme + AAH(Sequence(I));
      end case;
    end loop;
    return Somme / Real(Sequence'Length);
  end Hydrophobicite_Moyenne;

  function Hydrophobicite_Maximale(
     Sequence : in Sequence_Type;
     Length   : in Positive := 17;
     Echelle  : in Echelle_Hydrophobicite := Eges)
                                   return Real is
    Seq   : String renames Sequence.Composition.Value.all;
    Hm    : Real;
    Hmmax : Real := -10000.0;
  begin
    if Seq'Length < Length then
      raise TOO_SHORT_SEQUENCE;
    end if;
    for Debut in Seq'First..Seq'Last-Length+1 loop
      Hm := Hydrophobicite_Moyenne(Seq(Debut..Debut+Length-1),echelle);
      if Hmmax < Hm then Hmmax := Hm; end if;
    end loop;
    return Hmmax;
  end Hydrophobicite_Maximale;

  function Mesohydrophobicite(Sequence   : in Sequence_Type;
                              Min_Length : in Positive := 60;
                              Max_Length : in Positive := 80;
                              Echelle    : in Echelle_Hydrophobicite := Eges)
                              return Real is
    Seq   : String renames Sequence.Composition.Value.all;
    Debut : Integer := Seq'First;
    Somme_Msh : Real := 0.0;
    Aux_H,L_Aux_H : Real := 0.0;
    Uaa   : Integer := Debut+Min_Length-2;
    Meso_H : Real;
    Acum_Meso_H : Real := 0.0;
    Small_Wdw : Integer := Min_Length;
    Steps : Integer := 0;
  begin
    if Length(Sequence.Composition) =  0 then
      raise EMPTY_SEQUENCE;
    elsif Length(Sequence.Composition) < Min_Length then
      -- Determination de l'hydrophobicite moyenne
      return Hydrophobicite_Moyenne(Sequence.Composition.Value.all);
    end if;
    for I in Debut..Uaa loop
      case Echelle is
        when Eges => Aux_H := Aux_H + GES(Seq(I));
        when Eekd => Aux_H := Aux_H + EKD(Seq(I));
        when Egvh => Aux_H := Aux_H + GVH(Seq(I));
        when Eaah => Aux_H := Aux_H + AAH(Seq(I));
      end case;
    end loop;
    loop
      case Echelle is
        when Eges => Aux_H := Aux_H + GES(Seq(Small_Wdw));
        when Eekd => Aux_H := Aux_H + EKD(Seq(Small_Wdw));
        when Egvh => Aux_H := Aux_H + GVH(Seq(Small_Wdw));
        when Eaah => Aux_H := Aux_H + AAH(Seq(Small_Wdw));
      end case;
      Meso_H := -1000.0;
      L_Aux_H := Aux_H;
      Uaa := Small_Wdw + 1;
      while Uaa <= Seq'Last loop
        case Echelle is
          when Eges =>
            L_Aux_H := L_Aux_H - GES(Seq(Uaa-Small_Wdw)) + GES(Seq(Uaa));
          when Eekd  =>
            L_Aux_H := L_Aux_H - EKD(Seq(Uaa-Small_Wdw)) + EKD(Seq(Uaa));
          when Egvh =>
            L_Aux_H := L_Aux_H - GVH(Seq(Uaa-Small_Wdw)) + GVH(Seq(Uaa));
          when Eaah =>
            L_Aux_H := L_Aux_H - AAH(Seq(Uaa-Small_Wdw)) + AAH(Seq(Uaa));
        end case;
        if Meso_H < L_Aux_H then
          Meso_H := L_Aux_H;
        end if;
        Uaa := Uaa + 1;
      end loop;
      Acum_Meso_H := Acum_Meso_H + (Meso_H / Real(Small_Wdw));
      Small_Wdw := Small_Wdw + 1;
      Steps := Steps + 1;
      exit when Small_Wdw > Max_Length or Small_Wdw > Seq'Last;
    end loop;
    return Acum_Meso_H / Real(Steps);
  end Mesohydrophobicite;

  function Mesohydrophobicite_1(Sequence   : in Sequence_Type;
                                Min_Length : in Positive := 60;
                                Max_Length : in Positive := 80) return Real is
    Somme_Msh : Real := 0.0;
  begin
    if Length(Sequence.Composition) =  0 then
      raise EMPTY_SEQUENCE;
    elsif Length(Sequence.Composition) < Min_Length then
      -- Determination de l'hydrophobicite moyenne
      return Hydrophobicite_Moyenne(Sequence.Composition.Value.all);
    else
      -- Cas general
      -- Pour chaque taille de fenetre
      for Length in Min_Length..Max_Length loop
        -- Determiner si le calcul est possible pour cette fenetre
        if Length > Strlib.Length(Sequence.Composition) then
          -- calculer la MSH sur les valeurs disponibles
          return Somme_Msh / Real(Length-Min_Length_For_Msh+1);
        end if;
        -- Calculer l'hydrophobicite moyenne maximale pour la fenetre
        Somme_Msh := Somme_Msh + Hydrophobicite_Maximale(Sequence,Length);
      end loop;
      return Somme_Msh / Real(Max_Length_For_Msh-Min_Length_For_Msh+1);
    end if;
  end Mesohydrophobicite_1;

  function Frequence(Sequence   : in Sequence_Type;
                     Nucleotide : in Character;
                     From,To    : in Integer := -1) return Real is
    Seq    : String renames Sequence.Composition.Value.all;
    Nb     : Natural := 0;
    Start  : Integer := Seq'First;
    Stop   : Integer := Seq'Last;
  begin
    -- ajuster le debut et la fin de la recherche
    if From > Seq'First then
      Start := From;
    end if;
    if To > 0 and To < Seq'Last then
      Stop := To;
    end if;
    -- determiner la composition en aa
    begin
      for I in Start..Stop loop
        if Seq(I) = Nucleotide then
          Nb := Nb + 1;
        end if;
      end loop;
    exception
      when CONSTRAINT_ERROR => null; -- on ignore
    end;
    return Real(Nb) / Real(Stop-Start+1);
  end Frequence;

  function Coef_20(Sequence: in Sequence_Type) return Real is
    Seq   : String renames Sequence.Composition.Value.all;
    Nb_R, Nb_D, Nb_P, Nb_E, Nb_G, Nb_Q, Nb_K, Nb_H, Nb_N, Nb_Y: Natural := 0;
    From : constant Integer :=  1;
    To   : constant Integer := 20;
  begin
    -- determiner la composition en aa
    begin
      for I in From..To loop
        case Seq(Seq'First+I-From) is
          when 'R' | 'r' => Nb_R := Nb_R + 1;
          when 'D' | 'd' => Nb_D := Nb_D + 1;
          when 'P' | 'p' => Nb_P := Nb_P + 1;
          when 'E' | 'e' => Nb_E := Nb_E + 1;
          when 'G' | 'g' => Nb_G := Nb_G + 1;
          when 'Q' | 'q' => Nb_Q := Nb_Q + 1;
          when 'K' | 'k' => Nb_K := Nb_K + 1;
          when 'H' | 'h' => Nb_H := Nb_H + 1;
          when 'N' | 'n' => Nb_N := Nb_N + 1;
          when 'Y' | 'y' => Nb_Y := Nb_Y + 1;
          when others => null;
        end case;
      end loop;
    exception
      when CONSTRAINT_ERROR => null; -- on ignore
    end;
    return Real(Nb_R) * 0.116 - Real(Nb_D) * 0.238 - Real(Nb_P) * 0.253 -
           Real(Nb_E) * 0.233 - Real(Nb_G) * 0.250 - Real(Nb_Q) * 0.155 -
           Real(Nb_K) * 0.113 - Real(Nb_H) * 0.239 - Real(Nb_N) * 0.134 -
           Real(Nb_Y) * 0.157 + 5.227;
  end Coef_20;

  function Coef_Total(Sequence : in Sequence_Type;
                      From,To  : in Positive) return Real is
    Seq   : String renames Sequence.Composition.Value.all;
    Nb_R, Nb_A, Nb_S, Nb_L, Nb_D, Nb_P, Nb_E, Nb_G,
    Nb_Q, Nb_K, Nb_H, Nb_N, Nb_Y: Natural := 0;
  begin
    -- determiner la composition en aa
    begin
      for I in From..To loop
        case Seq(Seq'First+I-1) is
          when 'R' | 'r' => Nb_R := Nb_R + 1;
          when 'A' | 'a' => Nb_A := Nb_A + 1;
          when 'S' | 's' => Nb_S := Nb_S + 1;
          when 'L' | 'l' => Nb_L := Nb_L + 1;
          when 'D' | 'd' => Nb_D := Nb_D + 1;
          when 'P' | 'p' => Nb_P := Nb_P + 1;
          when 'E' | 'e' => Nb_E := Nb_E + 1;
          when 'G' | 'g' => Nb_G := Nb_G + 1;
          when 'Q' | 'q' => Nb_Q := Nb_Q + 1;
          when 'K' | 'k' => Nb_K := Nb_K + 1;
          when 'H' | 'h' => Nb_H := Nb_H + 1;
          when 'N' | 'n' => Nb_N := Nb_N + 1;
          when 'Y' | 'y' => Nb_Y := Nb_Y + 1;
          when others => null;
        end case;
      end loop;
    exception
      when CONSTRAINT_ERROR => null; -- on ignore
    end;
    return Real(Nb_R) * 0.135 + Real(Nb_A) * 0.141 + Real(Nb_S) * 0.112 +
           Real(Nb_L) * 0.122 - Real(Nb_D) * 0.238 - Real(Nb_P) * 0.253 -
           Real(Nb_E) * 0.233 - Real(Nb_G) * 0.250 - Real(Nb_Q) * 0.155 -
           Real(Nb_K) * 0.113 - Real(Nb_H) * 0.239 - Real(Nb_N) * 0.134 -
           Real(Nb_Y) * 0.157;
  end Coef_Total;

  function Charge_Diff(Sequence : in Sequence_Type) return Integer is
    Seq   : String renames Sequence.Composition.Value.all;
    Nb_K, Nb_R, Nb_D, Nb_E: Natural := 0;
  begin
    -- determiner la composition en aa
    for I in Seq'range loop
      case Seq(I) is
        when 'R' | 'r' => Nb_R := Nb_R + 1;
        when 'D' | 'd' => Nb_D := Nb_D + 1;
        when 'E' | 'e' => Nb_E := Nb_E + 1;
        when 'K' | 'k' => Nb_K := Nb_K + 1;
        when others => null;
      end case;
    end loop;
    return Nb_K + Nb_R - Nb_D - Nb_E;
  end Charge_Diff;

  function Number_Of(Sequence : in Sequence_Type;
                     From,To  : in Positive;
                     List     : in Set_Of_Amino_Acid) return Natural is
    Seq : String renames Sequence.Composition.Value.all;
    Cpt : Natural := 0;
  begin
    -- determiner la composition en aa
    begin
      for I in From..To loop
        for J in List'range loop
          if Seq(Seq'First+I-1) = List(J) then
            Cpt := Cpt + 1;
            exit; -- une seule egalite possible
          end if;
        end loop;
      end loop;
    exception
      when CONSTRAINT_ERROR => null; -- on ignore
    end;
    return Cpt;
  end Number_Of;

  function Define_Zone_Adressage(Sequence : in Sequence_Type)
    return Zone_Adressage is
    Seq : String renames Sequence.Composition.Value.all;
    Zone : Zone_Adressage;
  begin
    for I in Seq'First..Seq'Last-14 loop
      -- on cherche un D ou un E
      if Is_Amino_Acid(Seq(I),"dDeE") then
        -- verifier qu'il n'y en a pas entre i+1 et i+13 un
        -- autre D ou E
        for J in 1..13 loop
          if Is_Amino_Acid(Seq(I+J),"dDeE") then
            Zone.From := 1;
            Zone.To   := I-1;
            return Zone;
          end if;
        end loop;
      end if;
    end loop;
    Zone.From := 1;
    Zone.To := Seq'Last-3;
    return Zone;
  end Define_Zone_Adressage;

  function Cleavage(Sequence : in Sequence_Type;
                    From,To  : in Positive)
    return Natural is
    Seq : String renames Sequence.Composition.Value.all;
    Site : Natural := 0;
  begin
    for I in From..To loop
      if Seq(I) = 'R' or Seq(I)= 'r' then
        case Seq(I+2) is
          when 'Y' | 'y' =>
            if (I+3 <= Seq'Last and then Is_Amino_Acid(Seq(I+3),"aAsS")) 
	       and Site < I+3 then
              Site := I+3;
            end if;
          when 'F' | 'f' | 'I' | 'i' | 'L' | 'l' =>
            if ((I+3 <= Seq'last and then (Seq(I+3) = 'S' or Seq(I+3) = 's')) or
                (I+5 <= Seq'last and then (Seq(I+5) = 'S' or Seq(I+5) = 's'))) 
	      and Site < I+10 then
              Site := I+10;
            elsif (I+3 <= Seq'last and then 
	           Is_Amino_Acid(Seq(I+3),"aAgGpPtTvV")) 
              and Site < I+10 then
              Site := I+10;
            end if;
          when others =>
            if (I+3 <= Seq'last and then 
	        Is_Amino_Acid(Seq(I+3),"aAgGpPtTsSvV")) 
	      and Site < I+2 then
              Site := I+2;
            end if;
        end case;
      end if;
    end loop;
    if Site < 11 then
      -- il doit y avoir un bout de sequences avant
      Site := 0;
    end if;
    return Site;
  end Cleavage;

  function moment_hydrophobicite_maximum(
    sequence : in sequence_type;
    first    : in integer;
    last     : in integer;
    angle    : in integer := 95;
    Echelle  : in Echelle_Hydrophobicite := Eges;
    longwin  : in integer := 18)
    return MHM_type is

    Seq : String renames Sequence.Composition.Value.all;
    Pw,Qw,Xa,Ya,Uh : Real;
    Mhm : Mhm_Type := (0.0,0);
    Xi,Yi : Real := 0.0;
    Angrad : constant Real :=
      Real(Angle) * 3.1415926 /180.0; -- valeur en radian
  begin
    if Seq'Last < First+Longwin-1 then
      -- La sequence est trop courte pour faire le calcul
      return Mhm;
    end if;
    for I in First..First+Longwin-1 loop
      case Echelle is
        when Eges => Pw := GES(Seq(I));
        when Eekd => Pw := EKD(Seq(I));
        when Egvh => Pw := GVH(Seq(I));
        when Eaah => Pw := AAH(Seq(I));
      end case;
      Xa := Real(I)*Angrad;
      Xi := Xi + Pw * Cos(Xa);
      Yi := Yi + Pw * Sin(Xa);
    end loop;
    Mhm.Muh := Sqrt(Xi*Xi+Yi*Yi);
    Mhm.Pos := First;
    for I in First+1..Last-Longwin+1 loop
      if (I+Longwin-1) > Seq'Last then
        -- on a atteind la fin de la sequence
        return Mhm;
      else
        case Echelle is
          when Eges =>
            Pw := GES(Seq(I-1));
            Qw := GES(Seq(I+Longwin-1));
          when Eekd =>
            Pw := EKD(Seq(I-1));
            Qw := EKD(Seq(I+Longwin-1));
          when Egvh =>
            Pw := GVH(Seq(I-1));
            Qw := GVH(Seq(I+Longwin-1));
          when Eaah =>
            Pw := AAH(Seq(I-1));
            Qw := AAH(Seq(I+Longwin-1));
        end case;
        Xa := Real(I-1)*Angrad;
        Ya := Real(I+Longwin-1)*Angrad;
        Xi := Xi - Pw * Cos(Xa) + Qw * Cos(Ya);
        Yi := Yi - Pw * Sin(Xa) + Qw * Sin(Ya);
        Uh := Sqrt(Xi*Xi+Yi*Yi);
        if Mhm.Muh < Uh then
          Mhm.Muh := Uh;
          Mhm.Pos := I;
        end if;
      end if;
    end loop;
    return Mhm;
  end Moment_Hydrophobicite_Maximum;

  function Max(A,B : in Real) return Real is
  begin
    if A >= B then
      return A;
    else
      return B;
    end if;
  end Max;

  function Hmx(sequence : in sequence_type;
               first    : in Integer;
               Weight   : in Weight_Type := Weight_75;
               Echelle  : in Echelle_Hydrophobicite := Eges;
               longwin  : in integer := 18)
               return real is

    Seq : String renames Sequence.Composition.Value.all;
    Mh : Real := 0.0;
    Hmax, Aux_Mh : Real;
    Posit : Integer := First;
    Counter : Integer := 0;
    Ary_Aa_Turn : Integer_Array(1..36) := (others => 0);
    Maxwin : Integer := First + Longwin - 1;
    Aux,Acycle,J,K : Integer;
    Num_Of_Resid : Integer;
  begin
    if First = 0 then
      -- la sequence a ete trouvee trop courte
      -- pour le calcul du Moment_Hydrophobicite_Maximum.
      return 0.0;
    end if;
    if Maxwin > Length(Sequence.Composition) then
      Maxwin := Length(Sequence.Composition);
    end if;
    Ary_Aa_Turn(1..Weight.Complete_Turn) := Weight.Values;
    for I in 1..Weight.Aa_To_Hmax loop
      Aux := Ary_Aa_Turn(I) + Posit;
      if Aux <= Maxwin then -- Aux >= First
        begin
          case Echelle is
            when Eges => Mh := Mh + GES(Seq(Aux));
            when Eekd => Mh := Mh + EKD(Seq(Aux));
            when Egvh => Mh := Mh + GVH(Seq(Aux));
            when Eaah => Mh := Mh + AAH(Seq(Aux));
          end case;
          Counter := Counter + 1;
        exception
          when UNKNOWN_AA =>
            Put_Line("Erreur d'acide amine");
            Put_Line("Aux = " & Integer'Image(Aux) &
                     " Maxwin = " & Integer'Image(Maxwin) &
                     " Posit = " & Integer'Image(Posit));
            Put_Line("First = " & Integer'Image(First) &
                     " I = " & Integer'Image(I) &
                     " Ary = " & Integer'Image(Ary_Aa_Turn(I)));
            Put_Line("AA: " & Seq(Aux));
            Put("Nom de la sequence: ");
            Put_Line(Sequence.Name);
            Put_line("Longueur: " &
                      Integer'Image(Length(Sequence.Composition)));
            Put_line("Sequence: ");
            Put_Line(Sequence.Composition);
            Put_Line("----------");
            raise;
        end;
      end if;
    end loop;
    Hmax := 7.0 * Mh / Real(Counter);
    Acycle := Weight.Complete_Turn;
    Num_Of_Resid := 1;
    loop
      J := 1;
      K := 1 + Weight.Aa_To_Hmax;
      loop
        exit when Num_Of_Resid > Longwin;
        Aux := Ary_Aa_Turn(J) + Posit;
        if Aux <= Maxwin then -- Aux >= First
          case Echelle is
            when Eges => Mh := Mh - GES(Seq(Aux));
            when Eekd => Mh := Mh - EKD(Seq(Aux));
            when Egvh => Mh := Mh - GVH(Seq(Aux));
            when Eaah => Mh := Mh - AAH(Seq(Aux));
          end case;
          Counter := Counter - 1;
        end if;
        J := J + 1;
        if K > Weight.Complete_Turn then
          K := 1;
        end if;
        Aux := Ary_Aa_Turn(K) + Posit;
        if Aux <= Maxwin  then -- Aux >= First
          case Echelle is
            when Eges => Mh := Mh + GES(Seq(Aux));
            when Eekd => Mh := Mh + EKD(Seq(Aux));
            when Egvh => Mh := Mh + GVH(Seq(Aux));
            when Eaah => Mh := Mh + AAH(Seq(Aux));
          end case;
          Counter := Counter + 1;
        end if;
        K := K + 1;
        Aux_Mh := 7.0 * Mh / Real(Counter);
        if Aux_Mh > Hmax then
          Hmax := Aux_Mh;
        end if;
        Num_Of_Resid := Num_Of_Resid + 1;
        exit when J > Acycle;
      end loop;
      if Acycle < Longwin then
        Acycle := Acycle + Weight.Complete_Turn;
        Posit := Posit + Weight.Complete_Turn;
      end if;
      exit when Num_Of_Resid > Longwin;
    end loop;
    return Hmax;
  end Hmx;

begin
  Weight_75.Aa_To_Hmax := 9;
  Weight_75.Values(1..24) :=
    (0,5,10,15,20,1,6,11,16,21,2,7,12,17,22,3,8,13,18,23,4,9,14,19);
  Weight_95.Aa_To_Hmax := 8;
  Weight_95.Values(1..19) :=
    (0,4,8,12,16,1,5,9,13,17,2,6,10,14,18,3,7,11,15);
  Weight_100.Aa_To_Hmax := 7;
  Weight_100.Values(1..18) :=
    (0,11,4,15,8,1,12,5,16,9,2,13,6,17,10,3,14,7);
  Weight_105.Aa_To_Hmax := 9;
  Weight_105.Values(1..24) :=
    (0,7,14,21,4,11,18,1,8,15,22,5,12,19,2,9,16,23,6,13,20,3,10,17);
end Sequence_Package;

