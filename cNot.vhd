--Controlled Not
library ieee;
use ieee.std_logic_1164.all;

entity cNot is
    port 
    (
		inp     : in  std_logic;
		control : in  std_logic;
		outp    : out std_logic
	);
end cNot;

architecture arc of cNot is
begin
	
	outp <= not inp when (control = '1') else inp;

end arc;