--Memoria Istruzioni
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iMemory is

    generic (n: integer := 32);  --32bit valore di dafault

    port
    (
        address    :  in std_logic_vector (n-1 downto 0);
        instruction: out std_logic_vector (n-1 downto 0)
    );

end iMemory;

architecture arc of iMemory is
	
	type memoryArray is array (0 to 31) of std_logic_vector (n-1 downto 0);

	signal data: memoryArray :=(X"14080000", X"14090001", X"140A0002", X"140B0003", --(LW $s8,0)          (LW $s9,1)  (LW $s10,2)  (LW $s11,3)
                                X"05096001", X"00000000", X"00000000", X"05887801", --(ADD $s12,$s8,$s9)  ()          ()           (ADD $s15,$s12,$s8) 
                                X"180C0004", X"00000000", X"00000000", X"140D0004", --(SW $s12,4)         ()          ()           (LW $s13,4)
                                X"00000000", X"00000000", X"00000000", X"00000000", 
                                X"1188FFF1", X"00000000", X"00000000", X"00000000", --(BNE $s12 $s8 -15 (salta alla 3' istruzione))
                                X"00000000", X"00000000", X"00000000", X"00000000", 
                                X"00000000", X"00000000", X"00000000", X"00000000", 
                                X"00000000", X"00000000", X"00000000", X"00000000");

begin

	process (address)
	begin						
        instruction <= data(to_integer(unsigned(address))/4);
	end process;
	
end arc;