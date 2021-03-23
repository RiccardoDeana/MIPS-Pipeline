--And
library ieee;
use ieee.std_logic_1164.all;

entity andGate is

    port 
    (
		in1 : in  std_logic;
		in2 : in  std_logic;
		outp: out std_logic
	);
end andGate;

architecture arc of andGate is
begin

	outp <= in1 and in2;

end arc;