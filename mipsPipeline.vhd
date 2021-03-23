-- MISP Pipeline
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity mipsPipeline is 
end mipsPipeline;

architecture arc of mipsPipeline is

	component andGate
		port 
		(
			in1 : in  std_logic;
			in2 : in  std_logic;
			outp: out std_logic
		);
	end component;

	component control
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
	end component;

	component cNot
		port 
    	(
			inp     : in  std_logic;
			control : in  std_logic;
			outp    : out std_logic
		);
	end component;

	component aluControl  
		port
		(
			instr : in  std_logic_vector (5 downto 0);
			aluOp : in  std_logic_vector (3 downto 0); 
			aluFun: out std_logic_vector (3 downto 0) 
		);
	end component;

	component registers 
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
	end component;

	component pc
		generic (n: integer := 32);  --32bit valore di dafault
		
		port
		(
			inp  : in  std_logic_vector (n-1 downto 0);
			outp : out std_logic_vector (n-1 downto 0);
			clk  : in  std_logic;
			reset: in  std_logic
			
		);
	end component;

	component iMemory
		generic (n: integer := 32);  --32bit valore di dafault

		port
		(
			address     :  in std_logic_vector (n-1 downto 0);
			instruction : out std_logic_vector (n-1 downto 0)
		);
	end component;


	component mux 
		generic (n: integer := 32);  --32bit valore di dafault
		
		port 
		(
			in1  : in std_logic_vector(n-1 downto 0);
			in2  : in std_logic_vector(n-1 downto 0);
			sel  : in std_logic;
			outp : out std_logic_vector(n-1 downto 0)
		);
	end component;

	component shift2 
		generic (n: integer := 32);  --32bit valore di dafault

		port 
		(
			inp : in  std_logic_vector(n-1 downto 0);
			outp: out std_logic_vector(n-1 downto 0)
		);
	end component;

	component dMemory
		generic (n: integer := 32);  --32bit valore di dafault

		port
		(
			addr :  in std_logic_vector (n-1 downto 0);
			dataW:  in std_logic_vector (n-1 downto 0); 
			dataR: out std_logic_vector (n-1 downto 0);
			memW :  in std_logic; 
			memR :  in std_logic
		);
	end component;

	component regPipeline 
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
	end component;

	component add4
		generic (n: integer := 32);  --32bit valore di dafault

		port 
		(
			inp : in  std_logic_vector(n-1 downto 0);
			outp: out std_logic_vector(n-1 downto 0)
		);
	end component;

	component signExt
		generic 
		(   
			nIn : integer := 16; 
			nOut: integer := 32 
		); 

		port 
		(
			inp : in  std_logic_vector(nIn-1  downto 0);
			outp: out std_logic_vector(nOut-1 downto 0)
		);
	end component;

	component adder
		generic (n: integer := 32);  --32bit valore di dafault

		port 
		(
			in1 : in  std_logic_vector(n-1 downto 0);
			in2 : in  std_logic_vector(n-1 downto 0);
			outp: out std_logic_vector(n-1 downto 0)
		);
	end component;

	component alu
		generic (n: integer := 32);  --32bit valore di dafault

		port (
			in1   : in  std_logic_vector(n-1 downto 0);
			in2   : in  std_logic_vector(n-1 downto 0);
			op    : in  std_logic_vector  (3 downto 0);
			result: out std_logic_vector(n-1 downto 0);
			zero  : out std_logic
		);
	end component;
	
	constant nBit  : integer := 32;

	signal rst                : std_logic := '1';
	signal clock              : std_logic := '0';
	signal add4_muxBranchIF   : std_logic_vector(nBit-1 downto 0);
	signal regEX_muxBranchIF  : std_logic_vector(nBit-1 downto 0);
	signal muxBranch_muxJump  : std_logic_vector(nBit-1 downto 0) := (others => '0');
	signal and_muxBranchIF    : std_logic := '0';
	signal muxJump_pc         : std_logic_vector(nBit-1 downto 0);
	signal pc_iMemory         : std_logic_vector(nBit-1 downto 0);
	signal iMemory_regIF      : std_logic_vector(nBit-1 downto 0) := (others => '0');
	signal regIF_regDE        : std_logic_vector(nBit-1 downto 0);
	signal regIF_control      : std_logic_vector(nBit-1 downto 0) := (others => '0');
	signal controlSignal      : std_logic_vector (12 downto 0) := (others => '0');
	signal regME_registersDE  : std_logic_vector(4 downto 0);
	signal muxWB_registersDE  : std_logic_vector(nBit-1 downto 0);
	signal regMEControl_muxWB : std_logic_vector (12 downto 0) := (others => '0');
	signal data1_regDE        : std_logic_vector(nBit-1 downto 0);
	signal data2_regDE        : std_logic_vector(nBit-1 downto 0);
	signal signExtBranch_regDE: std_logic_vector(nBit-1 downto 0);
	signal signExtJump_regDE  : std_logic_vector(nBit-1 downto 0);
	signal regDE_aluOp        : std_logic_vector (12 downto 0) := (others => '0');
	signal regDE_adder        : std_logic_vector(nBit-1 downto 0);
	signal data1_alu          : std_logic_vector(nBit-1 downto 0);
	signal data2_muxEX1       : std_logic_vector(nBit-1 downto 0);
	signal regDE_muxEX3_1     : std_logic_vector(nBit-1 downto 0);
	signal regDE_muxEX3_2     : std_logic_vector(nBit-1 downto 0);
	signal muxEX3_aluControl  : std_logic_vector(nBit-1 downto 0);
	signal regDE_muxEX2_1     : std_logic_vector(4 downto 0);
	signal regDE_muxEX2_2     : std_logic_vector(4 downto 0);
	signal shift2_adder       : std_logic_vector(nBit-1 downto 0);
	signal muxEX1_alu         : std_logic_vector(nBit-1 downto 0);
	signal muxEX2_regEX       : std_logic_vector(4 downto 0);
	signal adder_regEX        : std_logic_vector(nBit-1 downto 0);
	signal aluControl_alu     : std_logic_vector(3 downto 0);
	signal aluResult_regEX    : std_logic_vector(nBit-1 downto 0);
	signal aluZero_regEX      : std_logic;
	signal regEXControl_dMem  : std_logic_vector (12 downto 0) := (others => '0');
	signal regEXZero_cNot     : std_logic;
	signal cNot_and           : std_logic;
	signal regEX_dMemData     : std_logic_vector(nBit-1 downto 0);
	signal regEX_dMemAddress  : std_logic_vector(nBit-1 downto 0);
	signal regEX_regME        : std_logic_vector(4 downto 0);
	signal dMem_regME         : std_logic_vector(nBit-1 downto 0);
	signal regMEMemory_muxWB  : std_logic_vector(nBit-1 downto 0);
	signal regMEAlu_muxWB     : std_logic_vector(nBit-1 downto 0);

	

begin

--INSTRUCTION FETCH
	muxBranchIF : 	mux 
		 			generic map (nBit) 
		 			port map(in1 => add4_muxBranchIF, 
							in2  => regEX_muxBranchIF, 
							sel  => and_muxBranchIF, 
							outp => muxBranch_muxJump);

	muxJumpIF: 	mux 
				generic map (nBit) 
				port map(in1 => muxBranch_muxJump , 
						in2  => regEX_muxBranchIF, 
						sel  => regEXControl_dMem(1), 
						outp => muxJump_pc);

	pcIF :	PC 
		  	generic map (nBit)
		  	port map (inp => muxJump_pc, 
			        outp  => pc_iMemory, 
				    clk   => clock, 
					reset => rst);

	iMemoryIF : iMemory 
			   	generic map (nBit) 
			   	port map(address    => pc_iMemory, 
			   			instruction => iMemory_regIF); 

	add4IF: add4 
			generic map(nBit) 
			port map(inp  => pc_iMemory, 
					 outp => add4_muxBranchIF);


	regPipelineIF : regPipeline 
	              	generic map(nBit) 
					 port map(clk     => clock,
							zeroIn    => '0',
							controlIn => (others => '0'),
							in1       => add4_muxBranchIF,
							in2       => iMemory_regIF,
							in3       => (others => '0'),
							in4       => (others => '0'),
							in5       => (others => '0'),
							in5_1     => (others => '0'),
							in5_2     => (others => '0'),
							out1      => regIF_regDE,
							out2      => regIF_control);


--DECODE
	controlDE : control 
				port map (instr    => regIF_control(31 downto 26),
						  regDst   => controlSignal(0),
						  jump     => controlSignal(1),
						  branch   => controlSignal(2),
						  notEq    => ControlSignal(12),
						  memRead  => controlSignal(3),
						  memToReg => controlSignal(4),
						  aluOp    => controlSignal(8 downto 5),
						  memWrite => controlSignal(9),
						  aluSrc   => controlSignal(10),
						  regWrite => controlSignal(11));

	registersDE : 	registers 
				 	generic map (n    => nBit,
				 				addr => 5)
				 	port map(readRegister1 => regIF_control(25 downto 21),
						  	readRegister2  => regIF_control(20 downto 16), 
						  	writeRegister  => regME_registersDE, 
						  	writeData      => muxWB_registersDE, 
						  	toWrite        => regMEControl_muxWB(11),
						  	readData1      => data1_regDE,
						  	readData2      => data2_regDE);

	signExtBranch : signExt
			  		generic map(nIn  => 16, 
					       		nOut => nBit) 
			   		port map(inp  => regIF_control (15 downto 0), 
						 	outp  => signExtBranch_regDE); 
				
	signExtJump :  	signExt
					generic map(nIn  => 26, 
								nOut => nBit) 
					port map(inp  => regIF_control (25 downto 0), 
							 outp => signExtJump_regDE); 

	regPipelineDE : regPipeline 
					generic map(nBit) 
					port map(clk       => clock,
							zeroIn     => '0',
							controlIn  => controlSignal,
							controlOut => regDE_aluOp,
							in1        => regIF_regDE,
							in2        => data1_regDE,
							in3        => data2_regDE,
							in4        => signExtBranch_regDE,
							in5        => signExtJump_regDE,
							out1       => regDE_adder,
							out2       => data1_alu,
							out3       => data2_muxEX1,
							out4       => regDE_muxEX3_1,
							out5       => regDE_muxEX3_2,
							in5_1      => regIF_control(20 downto 16),
							in5_2      => regIF_control(15 downto 11),
							out5_1     => regDE_muxEX2_1,
							out5_2     => regDE_muxEX2_2);

--EXECUTE
	shift2EX :	shift2 
				generic map(nBit) 
				port map(inp => muxEX3_aluControl, 
						outp => shift2_adder);

	muxEX1: mux 
			generic map(nBit) 
			port map(in1 => data2_muxEX1, 
					in2  => muxEX3_aluControl, 
					sel  => regDE_aluOp(10), 
					outp => muxEX1_alu);

	muxEX2: mux 
			generic map(5) 
			port map(in1 => regDE_muxEX2_1, 
					in2  => regDE_muxEX2_2, 
					sel  => regDE_aluOp(0), 
					outp => muxEX2_regEX);

	muxEX3: mux 
			generic map(nBit) 
			port map(in1 => regDE_muxEX3_1, 
					in2  => regDE_muxEX3_2, 
					sel  => regDE_aluOp(1), 
					outp => muxEX3_aluControl);
	
	adderEX : 	adder 
				generic map (nBit) 
				port map(in1 => regDE_adder, 
						in2  => shift2_adder, 
						outp => adder_regEX);

	aluControlEX : 	aluControl 
					port map(instr => muxEX3_aluControl(5 downto 0), 
							aluOp  => regDE_aluOp(8 downto 5), 
							aluFun => aluControl_alu);

	aluEX : alu 
			generic map(nBit) 
			port map(in1   => data1_alu, 
					in2    => muxEX1_alu, 
					op     => aluControl_alu, 
					result => aluResult_regEX, 
					zero   => aluZero_regEX);

	regPipelineEX : regPipeline 
					generic map(nBit)
					port map(clk       => clock,
							zeroIN     => aluZero_regEX,
							zeroOut    => regEXZero_cNot,
							controlIn  => regDE_aluOp,
							controlOut => regEXControl_dMem,
							in1        => adder_regEX,
							in2        => aluResult_regEX,
							in3        => data2_muxEX1,
							in4        => (others => '0'),
							in5        => (others => '0'),
							out1       => regEX_muxBranchIF,
							out2       => regEX_dMemAddress,
							out3       => regEX_dMemData,
							in5_1      => muxEX2_regEX,
							in5_2      => (others => '0'),
							out5_1     => regEX_regME);

--MEMORY
	cNotME:	cNot
			port map(inp    => regEXZero_cNot,
					control => regEXControl_dMem(12),
					outp    => cNot_and);

	andME : andGate 
			port map(in1 => cNot_and, 
					in2  => regEXControl_dMem(2), 
					outp => and_muxBranchIF);


	dMemoryME : dMemory 
				generic map(nBit)
				port map (addr => regEX_dMemAddress, 
						dataW  => regEX_dMemData, 
						dataR  => dMem_regME,
						memW   => regEXControl_dMem(9), 
						memR   => regEXControl_dMem(3));


	regPipelineME : regPipeline 
					generic map(nBit)
					port map(clk       => clock,
							zeroIn     => '0',
							controlIn  => regEXControl_dMem,
							controlOut => regMEControl_muxWB,
							in1        => dMem_regME,
							in2        => regEX_dMemAddress, 
							in3        => (others => '0'),
							in4        => (others => '0'),
							in5        => (others => '0'),
							out1       => regMEMemory_muxWB,
							out2       => regMEAlu_muxWB,
							in5_1      => regEX_regME,
							in5_2      => (others => '0'),
							out5_1     => regME_registersDE);


--WRITE BACK
	muxWB : mux 
			generic map(nBit) 
			port map(in1 => regMEAlu_muxWB, 
					in2  => regMEMemory_muxWB, 
					sel  => regMEControl_muxWB(4), 
					outp => muxWB_registersDE);



--PROCESS
	clock_process: process
	begin
		clock <= '1';
		wait for 50 ns;
		clock <= '0';
		wait for 50 ns;
	end process;

	main: process
   	begin   
		wait for 60 ns;
		rst <= '0';
		wait;
	end process;

end arc;