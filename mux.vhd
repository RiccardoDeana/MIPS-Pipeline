--Multiplexer
library ieee;
use ieee.std_logic_1164.all;

entity mux is
	generic (n: integer := 32);  --32bit valore di dafault
	
    port 
    (
		in1     : in std_logic_vector(n-1 downto 0);
		in2     : in std_logic_vector(n-1 downto 0);
		sel     : in std_logic;
		outp    : out std_logic_vector(n-1 downto 0)
	);
end mux;

architecture arc of mux is
begin

	outp <= in2 when (sel = '1') else in1;

end arc;