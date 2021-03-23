--Registri Pipeline
library ieee;
use ieee.std_logic_1164.all; 

entity regPipeline is

    generic (n: integer := 32);  --32bit valore di dafault

	port
	(
		clk: in std_logic;

        zeroIn :  in std_logic;
        zeroOut: out std_logic;

        controlIn :  in std_logic_vector (12 downto 0);
        controlOut: out std_logic_vector (12 downto 0);

		in1: in std_logic_vector (n-1 downto 0);
		in2: in std_logic_vector (n-1 downto 0); 
		in3: in std_logic_vector (n-1 downto 0); 
		in4: in std_logic_vector (n-1 downto 0); 
		in5: in std_logic_vector (n-1 downto 0); 
        
		out1: out std_logic_vector (n-1 downto 0);
		out2: out std_logic_vector (n-1 downto 0);
		out3: out std_logic_vector (n-1 downto 0);
		out4: out std_logic_vector (n-1 downto 0);
		out5: out std_logic_vector (n-1 downto 0);
        
		in5_1: in std_logic_vector (4 downto 0);
		in5_2: in std_logic_vector (4 downto 0);

		out5_1: out std_logic_vector (4 downto 0);
        out5_2: out std_logic_vector (4 downto 0)
        
    );
    
end regPipeline;


architecture arc of regPipeline is
	
	constant zeros: std_logic_vector(n-1 downto 0):= (others => '0');
	
begin
		
	process(clk)

		variable reg5_1: std_logic_vector (4 downto 0):= (others => '0');
		variable reg5_2: std_logic_vector (4 downto 0):= (others => '0');

		variable reg32_1: std_logic_vector (n-1 downto 0):= (others => '0');
		variable reg32_2: std_logic_vector (n-1 downto 0):= (others => '0');
		variable reg32_3: std_logic_vector (n-1 downto 0):= (others => '0');
		variable reg32_4: std_logic_vector (n-1 downto 0):= (others => '0');
		variable reg32_5: std_logic_vector (n-1 downto 0):= (others => '0');

        variable control: std_logic_vector (12 downto 0):= (others => '0');
        
		variable zero : std_logic:= '0';
	
	begin
            if(falling_edge(clk)) then
                
				controlOut <= control;
                zeroOut <= zero;
				out1 <= reg32_1;
				out2 <= reg32_2;
				out3 <= reg32_3;
				out4 <= reg32_4;
				out5 <= reg32_5;
				out5_1 <= reg5_1;
				out5_2 <= reg5_2;

			elsif (rising_edge(clk)) then

				control := controlIn;
				zero := zeroIn;
				reg32_1 := in1;
				reg32_2 := in2;
				reg32_3 := in3;
				reg32_4 := in4;
				reg32_5 := in5;
				reg5_1 := in5_1;
				reg5_2 := in5_2;
                
            end if;
            
	end process;
	
end arc;