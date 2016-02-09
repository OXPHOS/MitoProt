--------------------------------------------------------------------
-- MITOPROT                   Copyright ENS Ulm Paris France 1995-96
-- Pierre VINCENS                    V 01.000               04/12/95
--------------------------------------------------------------------

with Type_Specifications,Strlib;
use  Type_Specifications,Strlib;

package sequence_package is

  pragma Elaborate_Body;

  UNKNOWN_AA : exception;
    -- levee si un amino-acide n'existe pas.

  EMPTY_SEQUENCE: exception;
    -- levee si l'on tente de faire un calcul sur une sequence vide.

  TOO_SHORT_SEQUENCE: exception;
    -- levee si la sequence est de longueur insuffisante pour faire le calcul.

  ZONE_NOT_FOUND: exception;
    -- levee si la zone d'adressage n'a pas ete trouvee

  type Echelle_Hydrophobicite is (Eges,Eekd,Egvh,Eaah);

  type Organelle_Type is (Unknown,Mitochondrie,Chloroplaste);
  type sequence_type is record
    name          : varstring;
    composition   : varstring;
    Eukaryote     : Boolean := False;
    Fragment      : Boolean := False;
    Organelle     : Organelle_Type := Unknown;
      -- indique s'il s'agit d'une sequence eukaryote
    mitochondrial : integer := 0;
      -- si > 0, peut etre une proteine mito
      -- il faut que la sequence soit une sequence d'eukaryote
      -- poids +1 si ligne DE contient MITOCHON
      -- poids +2 si ligne CC contient MITOCHON et LOCATION
       --      ou si ligne FT contient TRANSIT et MITOCHONDRION
    chloroplastique : integer := 0;
      -- si > 0, peut etre une proteine mito
      -- il faut que la sequence soit une sequence d'eukaryote
      -- poids +1 si ligne DE contient CHLOROPLAST
      -- poids +2 si ligne CC contient CHLOROPLAST et LOCATION
      --       ou si ligne FT contient TRANSIT et CHLOROPLAST
  end record;

  type zone_adressage is record
    from : natural;
    to   : natural;
  end record;

  type Mhm_Type is record
    Muh : Real;
    Pos : Integer;
  end record;

  type Integer_Array is array(Integer range <>) of Integer;
  type Weight_Type(Complete_Turn : Integer) is record
    Aa_To_Hmax : Integer;
    Values     : Integer_Array(1..Complete_Turn);
  end record;
  Weight_75  : Weight_Type(24);
  Weight_95  : Weight_Type(19);
  Weight_100 : Weight_Type(18);
  Weight_105 : Weight_Type(24);

  type set_of_amino_acid is array(integer range <>) of character;

  function is_amino_acid(value: in character) return boolean;

  function hydrophobicite_maximale(
      sequence : in sequence_type;
      length   : in positive := 17;
      Echelle  : in Echelle_Hydrophobicite := Eges)
                                   return real;

  function mesohydrophobicite(
      sequence   : in sequence_type;
      min_length : in positive := 60;
      max_length : in positive := 80;
      Echelle    : in Echelle_Hydrophobicite := Eges)
                              return real;

  function Frequence(Sequence   : in Sequence_Type;
                     Nucleotide : in Character;
                     From,To    : in Integer := -1) return Real;

  function coef_20(sequence: in sequence_type) return real;

  function coef_total(sequence : in sequence_type;
                      from,to  : in positive) return real;

  function charge_diff(sequence : in sequence_type) return integer;

  function number_of(sequence : in sequence_type;
                     from,to  : in positive;
                     list     : in set_of_amino_acid) return natural;

  function define_zone_adressage(sequence : in sequence_type)
    return zone_adressage;

  function cleavage(sequence : in sequence_type;
                    from,to  : in positive)
    return natural;

  function moment_hydrophobicite_maximum(
    sequence : in sequence_type;
    first    : in integer;
    last     : in integer;
    angle    : in integer := 95;
    Echelle  : in Echelle_Hydrophobicite := Eges;
    longwin  : in integer := 18)
    return MHM_Type;

  function Hmx(sequence : in sequence_type;
               first    : in integer;
               Weight   : in Weight_Type := Weight_75;
               Echelle  : in Echelle_Hydrophobicite := Eges;
               longwin  : in integer := 18)
               return Real;


end sequence_package;
