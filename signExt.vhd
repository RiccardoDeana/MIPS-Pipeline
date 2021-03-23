--Estensione Segno
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signExt is
    generic 
    (   
        nIn : integer := 16; 
		nOut: integer := 32 
	); 

    port 
    (
		inp : in  std_logic_vector(nIn-1  downto 0);
		outp: out std_logic_vector(nOut-1 downto 0)
	);
end signExt;



architecture arc of signExt is
begin

    outp <= (nOut-1 downto nIn => inp(nIn-1)) & inp;

end arc;