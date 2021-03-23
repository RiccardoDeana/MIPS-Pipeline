--Aggiunge 4
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add4 is

	generic (n: integer := 32);  --32bit valore di dafault

    port 
    (
		inp : in  std_logic_vector(n-1 downto 0);
		outp: out std_logic_vector(n-1 downto 0)
    );
    
end add4;

architecture arc of add4 is
	begin
	
		outp <=  std_logic_vector (unsigned(inp) + 4);
		
end arc;