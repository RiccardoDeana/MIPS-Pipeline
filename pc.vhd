--Program Counter
library ieee;
use ieee.std_logic_1164.all; 

entity pc is

    generic (n: integer := 32);  --32bit valore di dafault
    
	port
	(
        inp  : in  std_logic_vector (n-1 downto 0);
        outp : out std_logic_vector (n-1 downto 0);
        clk  : in  std_logic;
        reset: in  std_logic
		
    );
    
end pc;

architecture arc of pc is

	begin
		process (clk, reset) 
        begin
            if(reset = '1') then
                outp <= (others => '0');
			elsif(rising_edge(clk)) then
				outp <= inp;
			end if;
		end process;
	
end arc;