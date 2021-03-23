--Memoria Dati
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dMemory is

    generic (n: integer := 32);  --32bit valore di dafault

	port
	(
		addr :  in std_logic_vector (n-1 downto 0);
        dataW:  in std_logic_vector (n-1 downto 0); 
        dataR: out std_logic_vector (n-1 downto 0);
		memW :  in std_logic; 
		memR :  in std_logic
    );
    
end dMemory;

architecture arc of dMemory is
	
	type memoryArray is array (0 to 31) of std_logic_vector (n-1 downto 0);

	signal data: memoryArray :=(X"0000009D", X"000003C7", X"0000014B", X"000002C5", --157, 967, 331, 709
                                X"00000000", X"00000000", X"00000000", X"00000000", 
                                X"00000000", X"00000000", X"00000000", X"00000000",
                                X"00000000", X"00000000", X"00000000", X"00000000", 
                                X"00000000", X"00000000", X"00000000", X"00000000", 
                                X"00000000", X"00000000", X"00000000", X"00000000",
                                X"00000000", X"00000000", X"00000000", X"00000000", 
                                X"00000000", X"00000000", X"00000000", X"00000000");
		
begin

	dataR <= data(to_integer(unsigned(addr))) when (memR = '1') else (others => 'Z');
	data(to_integer(unsigned(addr))) <= dataW when (memW = '1') else unaffected;
	
end arc;