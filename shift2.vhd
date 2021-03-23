--Shift a sinistra di 2 bit
library ieee;
use ieee.std_logic_1164.all;

entity shift2 is

	generic (n: integer := 32);  --32bit valore di dafault

  port 
  (
	  inp : in  std_logic_vector(n-1 downto 0);
		outp: out std_logic_vector(n-1 downto 0)
  );
    
end shift2;

architecture arc of shift2 is
begin

    outp <= inp (n-3 downto 0) & "00";
    
end arc;