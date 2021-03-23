--Registri
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity registers is

    generic
    (
        n   : integer := 32;
        addr: integer := 5
    );

	port
	(
		readRegister1: in  std_logic_vector (addr-1 downto 0);
		readRegister2: in  std_logic_vector (addr-1 downto 0);
		writeRegister: in  std_logic_vector (addr-1 downto 0);
		writeData    : in  std_logic_vector (n-1 downto 0);
		toWrite      : in  std_logic; 
		readData1    : out std_logic_vector (n-1 downto 0);
		readData2    : out std_logic_vector (n-1 downto 0)
    );
    
end registers ;

architecture arc  of registers is
	
	constant nRegs: integer := 2**addr;
	type registersArray is array (0 to nRegs-1) of std_logic_vector (n-1 downto 0);

	signal regi : registersArray := (others => (others => '0'));
	
begin

	readData1 <= regi (to_integer(unsigned(readRegister1)));
	readData2 <= regi (to_integer(unsigned(readRegister2)));
	regi (to_integer(unsigned(writeRegister))) <= writeData when (toWrite = '1');
	
end arc;