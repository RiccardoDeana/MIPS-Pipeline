--ALU
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ALUOp codes
--   0000   NOOP
--   0001   ADD
--   0010   SUB
--   0011   AND
--   0100   OR
--   0101   NOR
--   0110   NAND
--   0111   SHFTL
--   1000   SHFTR
--   1111   REQUEST

entity alu is

	generic (n: integer := 32);  --32bit valore di dafault

	port (
		in1   : in  std_logic_vector(n-1 downto 0);
		in2   : in  std_logic_vector(n-1 downto 0);
		op    : in  std_logic_vector  (3 downto 0);
		result: out std_logic_vector(n-1 downto 0);
		zero  : out std_logic
    );
    
end alu;

architecture arc of alu is

    signal res    : std_logic_vector(n-1 downto 0);
    constant zeros: std_logic_vector(n-1 downto 0):= (others => '0');

begin

	process
    begin
     
		if(op = "0001") then
            res <= std_logic_vector (signed(in1) + signed(in2));       
		elsif(op = "0010") then
            res <= std_logic_vector (signed(in1) - signed(in2));      
		elsif(op = "0011") then
            res <= in1 and in2;
        elsif(op = "0100") then
            res <= in1 or in2;
		elsif(op = "0101") then
			res <= in1 nor in2;        
		elsif(op = "0110") then
			res <= in1 nand in2; 
		elsif(op = "0111") then
			res <= std_logic_vector(shift_left((unsigned(in1)), to_integer(unsigned(in2)))); 
		elsif(op = "1000") then
			res <= std_logic_vector(shift_right((unsigned(in1)), to_integer(unsigned(in2))));
		end if;

		if(res = zeros) then
			zero <= '1';
		else
			zero <= '0';
		end if;

		result <= res;

		wait for 5 ns;

	end process;

end arc;