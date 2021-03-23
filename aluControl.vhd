--ALU Control
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
--
-- Instruction arithmetic codes
--   000001  SUM
--   000010  SUB
--   000011  AND
--   000100  OR
--   000101  NOR
--   000110  NAND
--   000111  SHFTL
--   001000  SHFTR

entity aluControl is
	port
	(
		instr : in  std_logic_vector (5 downto 0);
		aluOp : in  std_logic_vector (3 downto 0); 
		aluFun: out std_logic_vector (3 downto 0) 
	);
end aluControl;

architecture arc of aluControl is
begin

	process (instr, aluOp) 
	begin
		if (aluOp = "1111") then
			if(instr = "000001") then
				aluFun <= "0001";
			elsif(instr = "000010") then
				aluFun <= "0010";
			elsif(instr = "000011") then
				aluFun <= "0011";
			elsif(instr = "000100") then
				aluFun <= "0100";
			elsif(instr = "000101") then
				aluFun <= "0101";
			elsif(instr = "000110") then
				aluFun <= "0110";
			elsif(instr = "000111") then
				aluFun <= "0111";
			elsif(instr = "001000") then
				aluFun <= "1000";
			else 
				aluFun <= "0000";
		    end if;
		else
			aluFun <= aluOp;
		end if;
	end process;
	
end arc;