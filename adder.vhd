--Sommatore
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is

    generic (n: integer := 32);  --32bit valore di dafault

    port 
    (
        in1 : in  std_logic_vector(n-1 downto 0);
        in2 : in  std_logic_vector(n-1 downto 0);
		outp: out std_logic_vector(n-1 downto 0)
    );
    
end adder;

architecture arc of adder is
begin
    
    outp <=  std_logic_vector (unsigned(in1) + unsigned(in2));
        
end arc;