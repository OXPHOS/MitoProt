--------------------------------------------------------------------------
-- Systeme                      V 00.000   Copyrigth ENS ULM 1989-1995  --
-- Pierre VINCENS                    V 00.000               01/02/1995  --
-- Philippe ANDREY, Emmanuel CHIVA   V 00.001               03/03/1995  --
--------------------------------------------------------------------------

with Text_Io,Unchecked_Deallocation;
use  Text_Io;

package body Strlib is

--===========================================================================
-- Paquetage de gestion des chaines de caracteres dynamiques
--===========================================================================

--===========================================================================
-- Quelques fonctions utilitaires
--===========================================================================
  function End_Of_String(Str : in String) return Natural is
    -- Cette fonction retourne la derniere position de la
    -- chaine qui n'est pas le caractere. On conserve toujours
    -- le premier caractere de la chaine
    Count : Natural := Str'Last;
  begin
    while Count > Str'First and then Str(Count) = ' ' loop
      Count := Count - 1;
    end loop;
    return Count;
  end End_Of_String;


--===========================================================================
-- Fonctionnalites de conversion depuis et vers le type string
--===========================================================================
  function To_Varstring(Str : in String) return Varstring is
    Varstr : Varstring;
  begin
    if Str /=  "" then
      -- chaine non vide
      Varstr.Value := new String(1..Str'Length);
      Varstr.Value.all := Str;
    end if;
    return Varstr;
  end To_Varstring;

  function To_String(Varstr : in Varstring) return String is
  begin
    if Varstr.Value = null then
      return "";
    end if;
    return Varstr.Value.all;
  end To_String;

--===========================================================================
-- Liberation de la place associee a une chaine
--===========================================================================
  procedure Clear(Varstr : in out Varstring) is
  begin
    Free(Varstr.Value);
  end Clear;

--===========================================================================
-- Affectation d'une chaine
--===========================================================================
  procedure Copy(Src : in String; Dst : in out Varstring) is
  begin
    Free(Dst.Value);
    if Src'Length = 0 then
      return;
    end if;
    Dst.Value := new String(1..Src'Length);
    Dst.Value.all := Src;
  end Copy;

  procedure Copy(Src : in Varstring; Dst : in out Varstring) is
  begin
    Free(Dst.Value);
    if Src.Value = null then
      return;
    end if;
    Dst.Value := new String(1..Src.Value'Length);
    Dst.Value.all := Src.Value.all;
  end Copy;

--===========================================================================
-- L'operateur de concatenation
--===========================================================================
  function "&"(Str1,Str2 : in Varstring) return Varstring is
    Result : Varstring;
  begin
    if Str1.Value = null then
      if Str2.Value /= null then
        Result.Value := new String(1..Str2.Value'Length);
        Result.Value.all := Str2.Value.all;
      end if;
    elsif Str2.Value = null then
      -- str1 /= null
      Result.Value := new String(1..Str1.Value'Length);
      Result.Value.all := Str1.Value.all;
    else
      -- str1 /= null et str2 /= null
      Result.Value := new String(1..Str1.Value'Length + Str2.Value'Length);
      Result.Value.all := Str1.Value.all & Str2.Value.all;
    end if;
    return Result;
  end "&";

  function "&"(Str1 : in String; Str2 : in Varstring) return Varstring is
    Result : Varstring;
  begin
    if Str2.Value = null then
      Result.Value := new String(1..Str1'Length);
      Result.Value.all := Str1;
    else
      Result.Value := new String(1..Str1'Length + Str2.Value'Length);
      Result.Value.all := Str1 & Str2.Value.all;
    end if;
    return Result;
  end "&";

  function "&"(Str1 : in Varstring; Str2 : in String) return Varstring is
    Result : Varstring;
  begin
    if Str1.Value = null then
      Result.Value := new String(1..Str2'Length);
      Result.Value.all := Str2;
    else
      Result.Value := new String(1..Str1.Value'Length + Str2'Length);
      Result.Value.all := Str1.Value.all & Str2;
    end if;
    return Result;
  end "&";

--===========================================================================
-- L'extraction d'une chaine de caracteres
--===========================================================================
  function Substring(Varstr     : in Varstring;
                     First,Last : in Positive) return Varstring is
    Result : Varstring;
  begin
    if Varstr.Value = null then
      if First <= Last then
        -- la chaine demande est vide
        return Result;
      end if;
      raise INDEX_ERROR;
    end if;
    if Last < First or
       Last > Varstr.Value'Last or First < Varstr.Value'First then
      raise INDEX_ERROR;
    end if;
    Result.Value := new String(1..Last - First + 1);
    Result.Value.all := Varstr.Value(First..Last);
    return Result;
  end Substring;

--===========================================================================
-- La recherche d'une chaine de caracteres
--===========================================================================
  function Search(Str   : in String;
                  Value : in String) return Integer is
    Found : Boolean;
  begin
    for I in Str'range loop
      Found := True;
      for J in Value'range loop
        if Str(I+J-Value'First) /= Value(J) then
          Found := False;
          exit;
        end if;
      end loop;
      if Found then
        -- La chaine a ete trouve en position I
        return I;
      end if;
    end loop;
    raise STRING_NOT_FOUND;
  end Search;

  function Search(Varstr  : in Varstring;
                  Value   : in String) return Integer is
  begin
    if Varstr.Value = null then
      raise NULL_STRING;
    end if;
    return Search(Varstr.Value.all,Value);
  end Search;

  function Search(Varstr  : in Varstring;
                  Value   : in Varstring) return Integer is
  begin
    if Varstr.Value = null or Value.Value = null then
      raise NULL_STRING;
    end if;
    return Search(Varstr.Value.all,Value.Value.all);
  end Search;

  function Search(Str     : in String;
                  Value   : in Varstring) return Integer is
  begin
    if Value.Value = null then
      raise NULL_STRING;
    end if;
    return Search(Str,Value.Value.all);
  end Search;

  function RK_Search_Forward(Str     : in String;
                             Pattern : in String) return Integer is
    -- recherche d'une chaine de caractere par la methode de Rabin et Karp
    -- d'apres Sedgewick p 290
    Q : constant Integer := 33554393;
    D : constant Integer := 32;
    M : constant Integer := Pattern'Length;
    H1,H2,Dm : Integer;
  begin
    if M > Str'Length then
      -- le pattern est plus long que la chaine de recherche
      raise STRING_NOT_FOUND;
    end if;
    Dm := 1;
    for I in 1..M-1 loop
      Dm := (D*Dm) mod Q;
    end loop;
    H1 := 0;
    H2 := 0;
    for I in Pattern'range loop
      H1 := (H1 * D + Character'Pos(Pattern(I))) mod Q;
    end loop;
    for I in Str'First..Str'First+M-2 loop
      H2 := (H2 * D + Character'Pos(Str(I))) mod Q;
    end loop;
    for I in Str'First..Str'Last-M+1 loop
      H2 := (H2 * D   + Character'Pos(Str(I+M-1))) mod Q;
      if H1 = H2 then
        -- valider le pattern trouve
        if Str(I..I+M-1) = Pattern then
          return I;
        end if;
      end if;
      H2 := (H2 + D*Q - Character'Pos(Str(I))*Dm) mod Q;
    end loop;
    raise STRING_NOT_FOUND;
  end RK_Search_Forward;

  function RK_Search_Forward(Varstr  : in Varstring;
                             Pattern : in String) return Integer is
  begin
    if Varstr.Value = null then
      raise NULL_STRING;
    end if;
    return RK_Search_Forward(Varstr.Value.all,Pattern);
  end RK_Search_Forward;

  function RK_Search_Forward(Varstr  : in Varstring;
                             Pattern : in Varstring) return Integer is
  begin
    if Varstr.Value = null or Pattern.Value = null then
      raise NULL_STRING;
    end if;
    return RK_Search_Forward(Varstr.Value.all,Pattern.Value.all);
  end RK_Search_Forward;

  function RK_Search_Forward(Str     : in String;
                             Pattern : in Varstring) return Integer is
  begin
    if Pattern.Value = null then
      raise NULL_STRING;
    end if;
    return RK_Search_Forward(Str,Pattern.Value.all);
  end RK_Search_Forward;

  function RK_Search_Backward(Str     : in String;
                              Pattern : in String) return Integer is
    -- recherche d'une chaine de caractere par la methode de Rabin et Karp
    -- la recherche se fait depuis la fin de Str vers le debut
    -- Attention: toutes les boucles doivent etre reverse
    -- Sedgewick p 290
    Q : constant Integer := 33554393;
    D : constant Integer := 32;
    M : constant Integer := Pattern'Length;
    H1,H2,Dm : Integer;
  begin
    if M > Str'Length then
      -- le pattern est plus long que la chaine de recherche
      raise STRING_NOT_FOUND;
    end if;
    Dm := 1;
    for I in 1..M-1 loop
      Dm := (D*Dm) mod Q;
    end loop;
    H1 := 0;
    H2 := 0;
    for I in reverse Pattern'range loop
      H1 := (H1 * D + Character'Pos(Pattern(I))) mod Q;
    end loop;
    for I in reverse Str'Last-M+2..Str'Last loop
      H2 := (H2 * D + Character'Pos(Str(I))) mod Q;
    end loop;
    for I in reverse Str'First+M-1..Str'Last loop
      H2 := (H2 * D + Character'Pos(Str(I-M+1))) mod Q;
      if H1 = H2 then
        -- valider le pattern trouve
        if Str(I-M+1..I) = Pattern then
          return I-M+1;
        end if;
      end if;
      H2 := (H2 + D*Q - Character'Pos(Str(I))*Dm) mod Q;
    end loop;
    raise STRING_NOT_FOUND;
  end RK_Search_Backward;

  function RK_Search_Backward(Varstr  : in Varstring;
                              Pattern : in String) return Integer is
  begin
    if Varstr.Value = null then
      raise NULL_STRING;
    end if;
    return RK_Search_Backward(Varstr.Value.all,Pattern);
  end RK_Search_Backward;

  function RK_Search_Backward(Varstr  : in Varstring;
                              Pattern : in Varstring) return Integer is
  begin
    if Varstr.Value = null or Pattern.Value = null then
      raise NULL_STRING;
    end if;
    return RK_Search_Backward(Varstr.Value.all,Pattern.Value.all);
  end RK_Search_Backward;

  function RK_Search_Backward(Str     : in String;
                              Pattern : in Varstring) return Integer is
  begin
    if Pattern.Value = null then
      raise NULL_STRING;
    end if;
    return RK_Search_Backward(Str,Pattern.Value.all);
  end RK_Search_Backward;

  function Pattern_Is_In_String(Str     : in String;
                                Pattern : in String) return Boolean is
    Pos : Integer;
  begin
    Pos := RK_Search_Forward(Str,Pattern);
    return True;
  exception
    when STRING_NOT_FOUND => return False;
  end Pattern_Is_In_String;

  function Pattern_Is_In_String(Str     : in Varstring;
                                Pattern : in String) return Boolean is
    Pos : Integer;
  begin
    Pos := RK_Search_Forward(Str,Pattern);
    return True;
  exception
    when STRING_NOT_FOUND => return False;
  end Pattern_Is_In_String;

  function Pattern_Is_In_String(Str     : in Varstring;
                                Pattern : in Varstring) return Boolean is
    Pos : Integer;
  begin
    Pos := RK_Search_Forward(Str,Pattern);
    return True;
  exception
    when STRING_NOT_FOUND => return False;
  end Pattern_Is_In_String;

  function Pattern_Is_In_String(Str     : in String;
                                Pattern : in Varstring) return Boolean is
    Pos : Integer;
  begin
    Pos := RK_Search_Forward(Str,Pattern);
    return True;
  exception
    when STRING_NOT_FOUND => return False;
  end Pattern_Is_In_String;

--===========================================================================
-- La verification de la presence d'un caractere dans une chaine
--===========================================================================
  function Is_In(Value : in Character;
                 Str   : in String) return Boolean is
  begin
    for I in Str'Range loop
      if Value = Str(I) then
        return True;
      end if;
    end loop;
    return False;
  end Is_In;

  function Is_In(Value  : in Character;
                 Varstr : in Varstring) return Boolean is
  begin
    if Varstr.Value = null then
      return False;
    end if;
    return Is_In(Value,Varstr.Value.all);
  end Is_In;

--===========================================================================
-- La verification de la presence d'une chaine de caracteres
--===========================================================================
  function Exist(Str   : in String;
                 Value : in String) return Boolean is
    Found : Boolean;
  begin
    for I in Str'range loop
      Found := True;
      for J in Value'range loop
        if Str(I+J-Value'First) /= Value(J) then
          Found := False;
          exit;
        end if;
      end loop;
      if Found then
        -- La chaine a ete trouve en position I
        return True;
      end if;
    end loop;
    return False;
  end Exist;

  function Exist(Varstr  : in Varstring;
                 Value   : in String) return Boolean is
  begin
    if Varstr.Value = null then
      return False;
    end if;
    return Exist(Varstr.Value.all,Value);
  end Exist;

  function Exist(Varstr  : in Varstring;
                 Value   : in Varstring) return Boolean is
  begin
    if Varstr.Value = null or Value.Value = null then
      return False;
    end if;
    return Exist(Varstr.Value.all,Value.Value.all);
  end Exist;

  function Exist(Str     : in String;
                 Value   : in Varstring) return Boolean is
  begin
    if Value.Value = null then
      return False;
    end if;
    return Exist(Str,Value.Value.all);
  end Exist;

--===========================================================================
-- La lecture par mot
--===========================================================================
  procedure Next_Word(Str      : in String;
                      Word     : out Varstring;
                      Position : in out Integer;
                      Pattern  : in String := " :.,?!") is
    Start : Integer := Position;
    Stop : Integer;
    Found : Boolean := True;
  begin
    if Start < Str'First or Start > Str'Last then
      raise INDEX_ERROR;
    end if;
    -- liberer la place de word
    Free(Word.Value);
    -- chercher le debut du mot
    while Found and then Start <= Str'Last loop
      Found := False;
      for I in Pattern'range loop
        if Str(Start) = Pattern(I) then
          Found := True;
          Start := Start + 1;
          exit;
        end if;
      end loop;
    end loop;
    if Start > Str'Last then
      Word.Value := new String(1..0);
      Position := Start;
      return;
    end if;

    -- chercher la fin du mot
    Stop := Start;
    Stop_Loop: while Stop < Str'Last loop
      Stop := Stop + 1;
      for I in Pattern'range loop
        if Str(Stop) = Pattern(I) then
          Stop := Stop - 1;
          exit Stop_Loop;
        end if;
      end loop;
    end loop Stop_Loop;
    -- rendre le resultat
    Word.Value := new String(1..Stop-Start+1);
    Word.Value.all := Str(Start..Stop);
    Position := Stop + 1;
  end Next_Word;

  procedure Next_Word(Str      : in Varstring;
                      Word     : out Varstring;
                      Position : in out Integer;
                      Pattern  : in String := " :.,?!") is
  begin
    if Str.Value = null then
      Free(Word.Value);
      return;
    end if;
    Next_Word(Str.Value.all,Word,Position,Pattern);
  end Next_Word;

  procedure Previous_Word(Str      : in String;
                          Word     : out Varstring;
                          Position : in out Integer;
                          Pattern  : in String := " :.,?!") is
    Stop : Integer := Position;
    Start : Integer;
    Found : Boolean := True;
  begin
    if Stop < Str'First or Stop > Str'Last then
      raise INDEX_ERROR;
    end if;
    -- liberer la place de word
    Free(Word.Value);
    -- chercher la fin du mot
    while Found and then Stop >= Str'First loop
      Found := False;
      for I in Pattern'range loop
        if Str(Stop) = Pattern(I) then
          Found := True;
          Stop := Stop - 1;
          exit;
        end if;
      end loop;
    end loop;
    if Stop < Str'First then
      Word.Value := new String(1..0);
      Position := Stop;
      return;
    end if;

    -- chercher le debut du mot
    Start := Stop;
    Start_Loop: while Start > Str'First loop
      Start := Start - 1;
      for I in Pattern'range loop
        if Str(Start) = Pattern(I) then
          Start := Start + 1;
          exit Start_Loop;
        end if;
      end loop;
    end loop Start_Loop;
    -- rendre le resultat
    Word.Value := new String(1..Stop-Start+1);
    Word.Value.all := Str(Start..Stop);
    Position := Start - 1;
  end Previous_Word;

  procedure Previous_Word(Str      : in Varstring;
                          Word     : out Varstring;
                          Position : in out Integer;
                          Pattern  : in String := " :.,?!") is
  begin
    if Str.Value = null then
      Free(Word.Value);
      return;
    end if;
    Previous_Word(Str.Value.all,Word,Position,Pattern);
  end Previous_Word;

--===========================================================================
-- L'insertion d'une chaine de caracteres
--===========================================================================
  function Insert(Varstr     : in Varstring;
                  Str        : in String;
                  Position   : in Positive) return Varstring is
    Result : Varstring;
  begin
    if Varstr.Value = null then
      Result.Value := new String(1..Str'Length);
      Result.Value.all := Str;
    elsif Position < Varstr.Value'First or Position > Varstr.Value'Last then
      raise INDEX_ERROR;
    else
      Result.Value := new String(1..Varstr.Value'Length+Str'Length);
      Result.Value.all := Varstr.Value(Varstr.Value'First..Position-1) &
                          Str & Varstr.Value(Position..Varstr.Value'Last);
    end if;
    return Result;
  end Insert;

  function Insert(Varstr     : in Varstring;
                  Str        : in Varstring;
                  Position   : in Positive) return Varstring is
  begin
    if Str.Value = null then
      return Insert(Varstr,"",Position);
    else
      return Insert(Varstr,Str.Value.all,Position);
    end if;
  end Insert;

  function Append(Varstr     : in Varstring;
                  Str        : in String;
                  Position   : in Positive) return Varstring is
    Result : Varstring;
  begin
    if Varstr.Value = null then
      Result.Value := new String(1..Str'Length);
      Result.Value.all := Str;
    elsif Position < Varstr.Value'First or Position > Varstr.Value'Last then
      raise INDEX_ERROR;
    else
      Result.Value := new String(1..Varstr.Value'Length+Str'Length);
      Result.Value.all := Varstr.Value(Varstr.Value'First..Position) &
                          Str & Varstr.Value(Position+1..Varstr.Value'Last);
    end if;
    return Result;
  end Append;

  function Append(Varstr     : in Varstring;
                  Str        : in Varstring;
                  Position   : in Positive) return Varstring is
  begin
    if Str.Value = null then
      return Append(Varstr,"",Position);
    else
      return Append(Varstr,Str.Value.all,Position);
    end if;
  end Append;

--===========================================================================
-- Deletion d'une portion de chaine de caracteres
--===========================================================================
  function Delete(Varstr : in Varstring;
                  First  : in Positive;
                  Last   : in Positive) return Varstring is
    Result : Varstring;
  begin
    if ((Varstr.Value = null) or else
        (Last < First or
         First < Varstr.Value'First or
         Last > Varstr.Value'Last)) then
      raise INDEX_ERROR;
    end if;
    Result.Value := new String(1..Varstr.Value'Length-(Last-First+1));
    Result.Value.all := Varstr.Value(Varstr.Value'First..First-1) &
                        Varstr.Value(Last+1..Varstr.Value'Length);
    return Result;
  end Delete;

--===========================================================================
-- comparaison de 2 chaines de caracteres
--===========================================================================
  function Equal(Str1,Str2 : in Varstring) return Boolean is
  begin
    if Str1.Value = null or Str2.Value = null then
      return Str1.Value = Str2.Value;
    end if;
    return Str1.Value.all = Str2.Value.all;
  end Equal;

  function Diff(Str1,Str2 : in Varstring) return Boolean is
  begin
    if Str1.Value = null or Str2.Value = null then
      return Str1.Value /= Str2.Value;
    end if;
    return Str1.Value.all /= Str2.Value.all;
  end Diff;

--===========================================================================
-- Renverser une chaine de caracteres
--===========================================================================
  function Invert(Varstr     : in Varstring) return Varstring is
    Result : Varstring;
    --k : natural renames varstr.value'last;
    K : constant Natural := Varstr.Value'Last;
  begin
    if Varstr.Value = null then
      return Result;
    end if;
    Result.Value := new String(1..Varstr.Value'Length);
    for I in Varstr.Value'range loop
      Result.Value(I) := Varstr.Value(K-I+1);
    end loop;
    return Result;
  end Invert;

  procedure Invert(Varstr : in out Varstring) is
    --k : natural renames varstr.value'last;
    K : constant Natural := Varstr.Value'Last;

    procedure Swap(A : in out Character;B : in out Character) is
      Tmp : Character := A;
    begin
      A := B;
      B := Tmp;
    end Swap;

  begin
    if Varstr.Value = null then
      return;
    end if;
    for I in Varstr.Value'First..(Varstr.Value'Last-Varstr.Value'First+1)/2 loop
      Swap(Varstr.Value(I),Varstr.Value(K-I+1));
    end loop;
  end Invert;


--===========================================================================
-- Fonctionnalites d'entree-sortie (utilise text_io)
--===========================================================================
  procedure Put(Varstr : in Varstring) is
  begin
    if Varstr.Value /= null then
      Put(Varstr.Value.all);
    end if;
  end Put;

  procedure Put(File : in File_Type; Varstr : in Varstring) is
  begin
    if Varstr.Value /= null then
      Put(File,Varstr.Value.all);
    end if;
  end Put;

  procedure Put_Line(Varstr : in Varstring) is
  begin
    if Varstr.Value /= null then
      Put_Line(Varstr.Value.all);
    end if;
  end Put_Line;

  procedure Put_Line(File : in File_Type; Varstr : in Varstring) is
  begin
    if Varstr.Value /= null then
      Put_Line(File,Varstr.Value.all);
    end if;
  end Put_Line;

  procedure Get(Varstr : in out Varstring;
                Length : in Positive;
                Mode   : in End_Mode := Normal) is
    Str : String(1..Length);
    Last : Natural;
  begin
    if Varstr.Value /= null then Free(Varstr.Value); end if;
    Get(Str);
    if Mode = Removing then
      -- eliminer les blancs de fin de chaine
      Last := End_Of_String(Str);
    else
      Last := Str'Last;
    end if;
    Varstr.Value := new String(1..Last);
    Varstr.Value.all := Str(1..Last);
  end Get;

  procedure Get(File   : in File_Type;
                Varstr : in out Varstring;
                Length : in Positive;
                Mode   : in End_Mode := Normal) is
    Str : String(1..Length);
    Last : Natural;
  begin
    if Varstr.Value /= null then Free(Varstr.Value); end if;
    Get(File,Str);
    if Mode = Removing then
      -- eliminer les blancs de fin de chaine
      Last := End_Of_String(Str);
    else
      Last := Str'Last;
    end if;
    Varstr.Value := new String(1..Last);
    Varstr.Value.all := Str(1..Last);
  end Get;

  procedure Get_Line(Varstr     : in out Varstring;
                     Max_Length : in Positive := 256;
                     Mode       : in End_Mode := Normal) is
    Str : String(1..Max_Length);
    Last : Natural;
  begin
    if Varstr.Value /= null then Free(Varstr.Value); end if;
    Get_Line(Str,Last);
    if Mode = Removing then
      -- eliminer les blancs de fin de chaine
      Last := End_Of_String(Str(1..Last));
    end if;
    Varstr.Value := new String(1..Last);
    Varstr.Value.all := Str(1..Last);
  end Get_Line;

  procedure Get_Line(File       : in File_Type;
                     Varstr     : in out Varstring;
                     Max_Length : in Positive := 256;
                     Mode       : in End_Mode := Normal) is
    Str : String(1..Max_Length);
    Last : Natural;
  begin
    if Varstr.Value /= null then Free(Varstr.Value); end if;
    Get_Line(File,Str,Last);
    if Mode = Removing then
      -- eliminer les blancs de fin de chaine
      Last := End_Of_String(Str(1..Last));
    end if;
    Varstr.Value := new String(1..Last);
    Varstr.Value.all := Str(1..Last);
  end Get_Line;

--===========================================================================
-- La lecture en ignorant les caracteres souhaites
--===========================================================================
  procedure Selective_Get(Str    : in out String;
                          Ignore : in String := " ") is
    Last  : Natural := Str'First;
  begin
    while Last <= Str'Last loop
      Get(Str(Last));
      if not Is_In(Str(Last),Ignore) then
        Last := Last + 1;
      end if;
    end loop;
  end Selective_Get;

  procedure Selective_Get(File   : in File_Type;
                          Str    : in out String;
                          Ignore : in String := " ") is
    Last  : Natural := Str'First;
  begin
    while Last <= Str'Last loop
      Get(File,Str(Last));
      if not Is_In(Str(Last),Ignore) then
        Last := Last + 1;
      end if;
    end loop;
  end Selective_Get;


--===========================================================================
-- Quelques fonctionnalites de service
--===========================================================================
  function Length(Varstr     : in Varstring) return Natural is
  begin
    if Varstr.Value = null then
      return 0;
    else
      return Natural(Varstr.Value'Length);
    end if;
  end Length;

end Strlib;
