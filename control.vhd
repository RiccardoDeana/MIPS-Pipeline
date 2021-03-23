--Control
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Instructions
--   000000	NOP
--   000001 ALUOp
--   000010 JMP
--   000011 BEQ
--   000100 BNE
--   000101 LDW
--   000110 STW
--
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


entity control is
	port
	(
		instr   : in  std_logic_vector (5 downto 0);
		regDst  : out std_logic; 
		jump    : out std_logic;
		branch  : out std_logic; 
		notEq   : out std_logic;
		memRead : out std_logic;
		memToReg: out std_logic;
		aluOp   : out std_logic_vector (3 downto 0);
		memWrite: out std_logic;
		aluSrc  : out std_logic;
		regWrite: out std_logic
	);
end control;

architecture arc of control is
begin
	process(instr)
	begin
			
		if(instr = "000001") then --ALU Operation
			regDst   <= '1'; 
			jump     <= '0';
			branch   <= '0'; 
			notEq    <= '0';
			memRead  <= '0'; 
			memtoReg <= '0'; 
			aluOp    <= "1111"; 				
			memWrite <= '0'; 
			aluSrc   <= '0'; 
			regWrite <= '1'; 
                
		elsif(instr = "000010") then --Jump
			regDst   <= '0'; 
			jump     <= '1';
			branch   <= '0'; 
			notEq    <= '0';
			memRead  <= '0'; 
			memtoReg <= '0'; 
			aluOp    <= "0001"; 				
			memWrite <= '0'; 
			aluSrc   <= '0'; 
			regWrite <= '0'; 
                
		elsif(instr = "000011") then  --Branch on equal
			regDst   <= '0'; 
			jump     <= '0';
			branch   <= '1'; 
			notEq    <= '0';
			memRead  <= '0'; 
			memtoReg <= '0'; 
			aluOp    <= "0010"; 				
			memWrite <= '0'; 
			aluSrc   <= '0'; 
			regWrite <= '0'; 

		elsif(instr = "000100") then  --Branch on not equal
			regDst   <= '0'; 
			jump     <= '0';
			branch   <= '1'; 
			notEq    <= '1';
			memRead  <= '0'; 
			memtoReg <= '0'; 
			aluOp    <= "0010"; 				
			memWrite <= '0'; 
			aluSrc   <= '0'; 
			regWrite <= '0'; 
                
		elsif(instr = "000101") then --Load word
            regDst   <= '0'; 
            jump     <= '0';
			branch   <= '0'; 
			notEq    <= '0';
            memRead  <= '1'; 
            memtoReg <= '1'; 
            aluOp    <= "0001"; 				
            memWrite <= '0'; 
            aluSrc   <= '1'; 
            regWrite <= '1'; 

        elsif(instr = "000110") then --Store word
            regDst   <= '0'; 
            jump     <= '0';
			branch   <= '0'; 
			notEq    <= '0';
            memRead  <= '0'; 
            memtoReg <= '0'; 
            aluOp    <= "0001"; 				
            memWrite <= '1'; 
            aluSrc   <= '1'; 
            regWrite <= '0'; 

        else --No operation or error
			regDst   <= '0'; 
			jump     <= '0';
			branch   <= '0'; 
			notEq    <= '0';
			memRead  <= '0'; 
			memtoReg <= '0'; 
			aluOp    <= "0000"; 				
			memWrite <= '0'; 
			aluSrc   <= '0'; 
			regWrite <= '0'; 
                
		end if;
	end process;	
end arc;