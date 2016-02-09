--------------------------------------------------------------------
-- MITOPROT                   Copyright ENS Ulm Paris France 1995-96
-- Pierre VINCENS                    V 01.000               04/12/95
--------------------------------------------------------------------
 
with system;

package type_specifications is
 
  -- Le type octet
  type byte is range 0..255;
  
  -- Les types entiers
  type integer_8  is range -2**07..2**07-1;
  type integer_16 is range -2**15..2**15-1;
  type integer_32 is range -2**31..2**31-1;
  
  subtype short_integer is integer_8;
  subtype long_integer  is integer_32;
  
  -- Les types reels
  type real is digits 15;
  
private

  for byte'size use 1 * SYSTEM.STORAGE_UNIT;
  
  for integer_8'size  use 1 * SYSTEM.STORAGE_UNIT;
  for integer_16'size use 2 * SYSTEM.STORAGE_UNIT;
  for integer_32'size use 4 * SYSTEM.STORAGE_UNIT;
  
  for real'size use 8 * SYSTEM.STORAGE_UNIT;
  
end type_specifications;
