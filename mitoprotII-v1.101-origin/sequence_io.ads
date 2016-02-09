--------------------------------------------------------------------
-- MITOPROT                   Copyright ENS Ulm Paris France 1995-96
-- Pierre VINCENS                    V 01.000               04/12/95
--------------------------------------------------------------------

with Sequence_Package;
use  Sequence_Package;

package Sequence_Io is

  type Sequence_Format is (Ascii,GCG,Pir,Swissprot,Unknown);

  End_Of_Sequence : exception;
  SEQUENCE_FORMAT_ERROR: exception;

  function Root_Name(Src: in String) return String;

  procedure Read_Sequence(Name     : in String;
                          Sequence : in out Sequence_Type;
                          format   : in sequence_format := Unknown);

end Sequence_Io;
