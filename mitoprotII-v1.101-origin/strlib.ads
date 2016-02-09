--------------------------------------------------------------------------
-- Systeme                      V 00.000   Copyrigth ENS ULM 1989-1995  --
-- Pierre VINCENS                    V 00.000               01/02/1995  --
-- Philippe ANDREY, Emmanuel CHIVA   V 00.001               03/03/1995  --
--------------------------------------------------------------------------

with Text_Io,Unchecked_Deallocation;
use  Text_Io;

package Strlib is

--===========================================================================
-- Paquetage de gestion des chaines de caracteres dynamiques
--===========================================================================

--===========================================================================
-- Listes des erreurs potentielles
--===========================================================================
  INDEX_ERROR : exception;
    -- levee dans substring si les indices demandes sont incompatibles
    -- levee dans next_word et previous_word si la position de debut
    -- de recherche est en dehors de la chaine.

  STRING_NOT_FOUND : exception;
    -- levee dans search si la chaine n'est pas trouvee

  NULL_STRING : exception;
    -- levee si lón essaye d'acceder a une chaine non initialisee

--===========================================================================
-- Definition des types de base
--===========================================================================
  type String_Access is access String;
  procedure Free is new Unchecked_Deallocation(String,String_Access);

  type Varstring is record
    Value  : String_Access;
  end record;

  type End_Mode is (Normal, Removing);
    -- Ce type est utilise pour preciser si on conserve la chaine
    -- telle qu'elle ou si l'on supprime les blancs en fin de chaine

--===========================================================================
-- Fonctionnalites de conversion depuis et vers le type string
--===========================================================================
  function To_Varstring(Str : in String) return Varstring;
  function To_String(Varstr : in Varstring) return String;

--===========================================================================
-- Liberation de la place associee a une chaine
--===========================================================================
  procedure Clear(Varstr : in out Varstring);

--===========================================================================
-- Affectation d'une chaine
--===========================================================================
  procedure Copy(Src : in String; Dst : in out Varstring);
  procedure Copy(Src : in Varstring; Dst : in out Varstring);

--===========================================================================
-- L'operateur de concatenation
--===========================================================================
  function "&"(Str1,Str2 : in Varstring) return Varstring;
  function "&"(Str1 : in String; Str2 : in Varstring) return Varstring;
  function "&"(Str1 : in Varstring; Str2 : in String) return Varstring;

--===========================================================================
-- L'extraction d'une chaine de caracteres
--===========================================================================
  function Substring(Varstr     : in Varstring;
                     First,Last : in Positive) return Varstring;

--===========================================================================
-- La recherche d'une chaine de caracteres
--===========================================================================
  function Search(Str   : in String;
                  Value : in String) return Integer;
  function Search(Varstr  : in Varstring;
                  Value   : in String) return Integer;
  function Search(Varstr  : in Varstring;
                  Value   : in Varstring) return Integer;
  function Search(Str     : in String;
                  Value   : in Varstring) return Integer;
  -- Recherche d'une chaine de caracteres value dans une autre chaine
  -- Si la chaine n'est pas trouve, alors l'exception STRING_NOT_FOUND
  -- est levee. La valeur retournee est l'indice de position du debut
  -- de la chaine.

  function RK_Search_Forward(Str     : in String;
                             Pattern : in String) return Integer;
  function RK_Search_Forward(Varstr  : in Varstring;
                             Pattern : in String) return Integer;
  function RK_Search_Forward(Varstr  : in Varstring;
                             Pattern : in Varstring) return Integer;
  function RK_Search_Forward(Str     : in String;
                             Pattern : in Varstring) return Integer;
  -- Recherche d'une chaine de caractere par la methode de Rabin et Karp
  -- la recherche se fait depuis le debut vers la fin
  -- Reference: Sedgewick p 290
  -- Si la chaine n'est pas trouve, alors l'exception STRING_NOT_FOUND
  -- est levee. La valeur retournee est l'indice de position du debut
  -- de la chaine.

  function RK_Search_Backward(Str     : in String;
                              Pattern : in String) return Integer;
  function RK_Search_Backward(Varstr  : in Varstring;
                              Pattern : in String) return Integer;
  function RK_Search_Backward(Varstr  : in Varstring;
                              Pattern : in Varstring) return Integer;
  function RK_Search_Backward(Str     : in String;
                              Pattern : in Varstring) return Integer;
  -- Recherche d'une chaine de caractere par la methode de Rabin et Karp
  -- la recherche se fait depuis la fin de src vers le debut
  -- Reference: Sedgewick p 290
  -- Si la chaine n'est pas trouve, alors l'exception STRING_NOT_FOUND
  -- est levee. La valeur retournee est l'indice de position du debut
  -- de la chaine.

  function Pattern_Is_In_String(Str     : in String;
                                Pattern : in String) return Boolean;
  function Pattern_Is_In_String(Str     : in Varstring;
                                Pattern : in String) return Boolean;
  function Pattern_Is_In_String(Str     : in Varstring;
                                Pattern : in Varstring) return Boolean;
  function Pattern_Is_In_String(Str     : in String;
                                Pattern : in Varstring) return Boolean;
  -- Cette fonction verifie si ule pattern est present dans la chaine
  -- de caracteres passee en argument. Elle fait appel a RK_Search_Backward.

--===========================================================================
-- La verification de la presence d'un caractere dans une chaine
--===========================================================================
  function Is_In(Value : in Character;
                 Str   : in String) return Boolean;

  function Is_In(Value  : in Character;
                 Varstr : in Varstring) return Boolean;

--===========================================================================
-- La verification de la presence d'une chaine de caracteres
--===========================================================================
  function Exist(Str   : in String;
                 Value : in String) return Boolean;
  function Exist(Varstr  : in Varstring;
                 Value   : in String) return Boolean;
  function Exist(Varstr  : in Varstring;
                 Value   : in Varstring) return Boolean;
  function Exist(Str     : in String;
                 Value   : in Varstring) return Boolean;

--===========================================================================
-- La lecture par mot
--===========================================================================
  procedure Next_Word(Str      : in String;
                      Word     : out Varstring;
                      Position : in out Integer;
                      Pattern  : in String := " :.,?!");
  procedure Next_Word(Str      : in Varstring;
                      Word     : out Varstring;
                      Position : in out Integer;
                      Pattern  : in String := " :.,?!");
  -- Cette procedure recherche le prochain mot dans la chaine de caractere
  -- str. Position donne la position de départ de recherche dans la chaine
  -- la valeur retournée est la position de fin du mot incremente de 1.
  -- Pattern est une chaine de caractères ou sont précisés les caractères
  -- séparateur de mots.
  -- L´exception INDEX_ERROR est levee si position est en dehors des
  -- bornes de la chaine.

  procedure Previous_Word(Str      : in String;
                          Word     : out Varstring;
                          Position : in out Integer;
                          Pattern  : in String := " :.,?!");
  procedure Previous_Word(Str      : in Varstring;
                          Word     : out Varstring;
                          Position : in out Integer;
                          Pattern  : in String := " :.,?!");
  -- Calque sur la precedente, cette procedure recherche le mot
  -- precedent la position position dans la chaine str.

--===========================================================================
-- L'insertion d'une chaine de caracteres
--===========================================================================
  function Insert(Varstr     : in Varstring;
                  Str        : in String;
                  Position   : in Positive) return Varstring;
  function Insert(Varstr     : in Varstring;
                  Str        : in Varstring;
                  Position   : in Positive) return Varstring;
  function Append(Varstr     : in Varstring;
                  Str        : in String;
                  Position   : in Positive) return Varstring;
  function Append(Varstr     : in Varstring;
                  Str        : in Varstring;
                  Position   : in Positive) return Varstring;


--===========================================================================
-- Deletion d'une portion de chaine de caracteres
--===========================================================================
  function Delete(Varstr : in Varstring;
                  First  : in Positive;
                  Last   : in Positive) return Varstring;

--===========================================================================
-- comparaison de 2 chaines de caracteres
--===========================================================================
  function Equal(Str1, Str2 : in Varstring) return Boolean;
  function Diff(Str1, Str2 : in Varstring) return Boolean;

--===========================================================================
-- Renverser une chaine de caracteres
--===========================================================================
  function Invert(Varstr     : in Varstring) return Varstring;
  procedure Invert(Varstr : in out Varstring);

--===========================================================================
-- Fonctionnalites d'entree-sortie (utilise text_io)
--===========================================================================
  procedure Put(Varstr : in Varstring);
  procedure Put(File : in File_Type; Varstr : in Varstring);

  procedure Put_Line(Varstr : in Varstring);
  procedure Put_Line(File : in File_Type; Varstr : in Varstring);

  procedure Get(Varstr : in out Varstring;
                Length : in Positive;
                Mode   : in End_Mode := Normal);
  procedure Get(File   : in File_Type;
                Varstr : in out Varstring;
                Length : in Positive;
                Mode   : in End_Mode := Normal);

  procedure Get_Line(Varstr     : in out Varstring;
                     Max_Length : in Positive := 256;
                     Mode       : in End_Mode := Normal);
  procedure Get_Line(File       : in File_Type;
                     Varstr     : in out Varstring;
                     Max_Length : in Positive := 256;
                     Mode       : in End_Mode := Normal);

--===========================================================================
-- La lecture en ignorant les caracteres souhaites
--===========================================================================
  procedure Selective_Get(Str    : in out String;
                          Ignore : in String := " ");
  procedure Selective_Get(File   : in File_Type;
                          Str    : in out String;
                          Ignore : in String := " ");
  -- ces deux procedures lisent exactement le nombre de caracteres
  -- necessaires pour remplir str, tout en ignorant les caracteres
  -- presents dans Ignore.

--===========================================================================
-- Quelques fonctionnalites de service
--===========================================================================
  function Length(Varstr     : in Varstring) return Natural;

end Strlib;
