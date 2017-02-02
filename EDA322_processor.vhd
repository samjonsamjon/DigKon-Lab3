LIBRARY ieee;
USE ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
USE std.textio.all;
USE ieee.numeric_std.all;

entity EDA322_processor is
 	Port ( 	externalIn : in STD_LOGIC_VECTOR (7 downto 0); -- ?extIn? in Figure 1
		CLK : in STD_LOGIC;
		master_load_enable: in STD_LOGIC;
		ARESETN : in STD_LOGIC;
		pc2seg : out STD_LOGIC_VECTOR (7 downto 0); -- PC
		instr2seg : out STD_LOGIC_VECTOR (11 downto 0); -- Instruction register
		Addr2seg : out STD_LOGIC_VECTOR (7 downto 0); -- Address register
		dMemOut2seg : out STD_LOGIC_VECTOR (7 downto 0); -- Data memory output
		aluOut2seg : out STD_LOGIC_VECTOR (7 downto 0); -- ALU output
		acc2seg : out STD_LOGIC_VECTOR (7 downto 0); -- Accumulator
		flag2seg : out STD_LOGIC_VECTOR (3 downto 0); -- Flags
		busOut2seg : out STD_LOGIC_VECTOR (7 downto 0); -- Value on the bus
		disp2seg: out STD_LOGIC_VECTOR(7 downto 0); --Display register
		errSig2seg : out STD_LOGIC; -- Bus Error signal
		ovf : out STD_LOGIC; -- Overflow
		zero : out STD_LOGIC); -- Zero
end EDA322_processor;



ARCHITECTURE structural OF EDA322_processor IS
	
-- SIGNAL dataIn : STD_LOGIC_VECTOR(7 DOWNTO 0); Samma som BusOut till DataMem


SIGNAL MemDataOut : STD_LOGIC_VECTOR(7 DOWNTO 0); -- DataMem -> DE/EX registret
SIGNAL InstrMemOut : STD_LOGIC_VECTOR(11 DOWNTO 0); --IMEM -> FE/DE registret
SIGNAL FlagInp : STD_LOGIC_VECTOR(3 DOWNTO 0); -- ALU -> FReg
SIGNAL ALUOut : STD_LOGIC_VECTOR(7 DOWNTO 0); -- ALU -> ACC, samt skall till utsig aluOut2seg
SIGNAL pc : STD_LOGIC_VECTOR(7 DOWNTO 0); --FE reg -> Instructionsignalen, samt till utsig instr2seg
SIGNAL Instruction : STD_LOGIC_VECTOR(11 DOWNTO 0); -- 4 bitar -> opcode, 8 bitar -> addrFromInstructionsignalen som ska till muxen innan dataMem
SIGNAL nxtpc : STD_LOGIC_VECTOR(7 DOWNTO 0); -- PCMUX-> FE.
SIGNAL error : STD_LOGIC; --Interna bussen -> errSig2Seg
SIGNAL dispOut : STD_LOGIC_VECTOR(7 DOWNTO 0); --Display output -> disp2seg
SIGNAL FRegOut : STD_LOGIC_VECTOR(3 DOWNTO 0); --FReg -> NEQ,EQ (Controller), flag2seg
SIGNAL ACC_input : STD_LOGIC_VECTOR(7 DOWNTO 0); -- utsignal från ALUaccMUXen
SIGNAL OutFromAcc : STD_LOGIC_VECTOR(7 DOWNTO 0); -- ACC -> acc2seg, Display
SIGNAL BusOut : STD_LOGIC_VECTOR(7 DOWNTO 0); -- Utsignalen från interna bussen, insignal till diverse
SIGNAL PCIncrOut : STD_LOGIC_VECTOR(7 DOWNTO 0); --PCRCA ut in i PCMUXEN
SIGNAL Addr : STD_LOGIC_VECTOR(7 DOWNTO 0); -- AddrMuxen -> Datamem
SIGNAL MemDataOutReged : STD_LOGIC_VECTOR(7 DOWNTO 0); -- Från dataregistret ut op bussen
SIGNAL AddrFromInstruction : STD_LOGIC_VECTOR(7 DOWNTO 0); --Icke opkoden från Instructionfrån instruction mem via FE/DE muxen
SIGNAL opcode : STD_LOGIC_VECTOR(3 DOWNTO 0); -- opkoden från instruction
SIGNAL NEQ : STD_LOGIC; -- FReg -> Controllern
SIGNAL EQ : STD_LOGIC; -- FReg -> Controllern

--Signaler från controllern
SIGNAL pcSEL : STD_LOGIC;
SIGNAL pcLd : STD_LOGIC;
SIGNAL instrLd : STD_LOGIC;
SIGNAL addrMd : STD_LOGIC;
SIGNAL dmWr : STD_LOGIC;
SIGNAL dataLd : STD_LOGIC;
SIGNAL flagLd : STD_LOGIC;
SIGNAL accSel : STD_LOGIC;
SIGNAL accLd : STD_LOGIC;
SIGNAL im2bus : STD_LOGIC;
SIGNAL dmRd : STD_LOGIC;
SIGNAL acc2bus : STD_LOGIC;
SIGNAL ext2bus : STD_LOGIC;
SIGNAL dispLd: STD_LOGIC;
SIGNAL aluMd : STD_LOGIC_VECTOR(1 downto 0);



COMPONENT RCA IS
	PORT   (A	:IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		B	:IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		CIN	:IN	STD_LOGIC;
		SUM	:OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		COUT	:OUT	STD_LOGIC
);
END COMPONENT;

COMPONENT MUX2_1 IS
	PORT   (A	:IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		B	:IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		S	:IN	STD_LOGIC;
		Y	:OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END COMPONENT;

COMPONENT reg IS
	GENERIC(N:INTEGER:=8);
	PORT( 	Data		: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		CLK		: IN STD_LOGIC;
		ARESETN		: IN STD_LOGIC;
		loadEnable	: IN STD_LOGIC;
		Q		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END COMPONENT;

COMPONENT mem_array IS
	GENERIC (
		DATA_WIDTH: integer := 12;
		ADDR_WIDTH: integer := 8;
		INIT_FILE: string := "inst_mem.mif"
);
	PORT(	ADDR : IN STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
		DATAIN : IN STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		CLK : IN STD_LOGIC;
		WE : IN STD_LOGIC;
		OUTPUT : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0));
END COMPONENT;

COMPONENT alu_wRCA IS
	PORT ( 	ALU_inA 	: IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
		ALU_inB 	: IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
		Operation 	: IN STD_LOGIC_VECTOR(1 DOWNTO 0) ;
		ALU_out		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0) ;
		Carry		: OUT STD_LOGIC ;
		NotEq		: OUT STD_LOGIC ;
		Eq		: OUT STD_LOGIC ;
		isOutZero	: OUT STD_LOGIC 

);
END COMPONENT;

COMPONENT procBus IS
	PORT(	INSTRUCTION	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		DATA		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		ACC		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		EXTDATA		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		OUTPUT		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		ERR		: OUT STD_LOGIC;
		instrSEL	: IN STD_LOGIC;
		dataSEL		: IN STD_LOGIC;
		accSEL		: IN STD_LOGIC;
		extdataSEL	: IN STD_LOGIC);
end COMPONENT;


COMPONENT procController is
   Port ( master_load_enable: in STD_LOGIC;
          opcode : in  STD_LOGIC_VECTOR (3 downto 0);
          neq : in STD_LOGIC;
          eq : in STD_LOGIC; 
          CLK : in STD_LOGIC;
          ARESETN : in STD_LOGIC;
          pcSel : out  STD_LOGIC;
          pcLd : out  STD_LOGIC;
          instrLd : out  STD_LOGIC;
          addrMd : out  STD_LOGIC;
          dmWr : out  STD_LOGIC;
          dataLd : out  STD_LOGIC;
          flagLd : out  STD_LOGIC;
          accSel : out  STD_LOGIC;
          accLd : out  STD_LOGIC;
          im2bus : out  STD_LOGIC;
          dmRd : out  STD_LOGIC;
          acc2bus : out  STD_LOGIC;
          ext2bus : out  STD_LOGIC;
          dispLd: out STD_LOGIC;
          aluMd : out STD_LOGIC_VECTOR(1 downto 0));
END COMPONENT;

BEGIN

--Data Memory
Data_MEM : mem_array GENERIC MAP(DATA_WIDTH => 8, INIT_FILE => "data_mem.mif") PORT MAP( Addr , BusOut , CLK , dmWr , MemDataOut );

--Instruction Memory
Instruction_MEM : mem_array GENERIC MAP(DATA_WIDTH => 12, ADDR_WIDTH => 8)PORT MAP( pc , "000000000000" , CLK , '0' , InstrMemOut );

--ALU
ALU : alu_wRCA PORT MAP( OutFromAcc , BusOut , aluMd , ALUOut , FlagInp(0) , FlagInp(1) , FlagInp(2) , FlagInp(3) );

--FE Reg
FE : reg GENERIC MAP(N => 8) PORT MAP( nxtpc, CLK , '1' , pcLd , pc );

--FE/DE Reg, InstrMemOut deklarerad i InstrMem
FE_DE : reg GENERIC MAP(N => 12) PORT MAP( InstrMemOut , CLK , '1' , instrLd , Instruction );

--DE/EX Reg, MemDataOut  deklarerad i DATAMEM
DE_EX : reg GENERIC MAP(N => 8) PORT MAP( MemDataOut , CLK , '1' , dataLd , MemDataOutReged );

--ACC Reg
ACC : reg GENERIC MAP(N => 8) PORT MAP( ACC_input , CLK , '1' , accLd , OutFromAcc );

--Display Reg, OutFromAcc deklarerad i ACC
Display : reg GENERIC MAP(N => 8) PORT MAP( OutFromAcc , CLK , '1' , dispLd , dispOut );
--Display Reg

--FReg Reg, FlagInp  deklarerad i ALU
FReg : reg GENERIC MAP( N => 4) PORT MAP( FlagInp , CLK , '1' , flagLd, FRegOut );

--PC_MUX, nxtpc deklarerad i FE reg.
PC_MUX : MUX2_1 PORT MAP(PCIncrOut,BusOut,pcSel,nxtpc);

--AddrMUX,
AddrMUX : MUX2_1 PORT MAP(AddrFromInstruction,MemDataOutReged,addrMd,Addr);

--ALUaccMUX, AluOut deklarerad i ALU, ACC_input deklarerad i ACC
ALUaccMUX : MUX2_1 PORT MAP(AluOut,BusOut,accSel,ACC_input);

--PCrca
PCrca : RCA PORT MAP(pc,"00000001",'0',PCIncrOut,OPEN);

--Internal_Bus
Internal_Bus : procBus PORT MAP(addrFromInstruction,MemDataOutReged,OutFromAcc,externalIn,BusOut,error,im2bus,dmRd,acc2bus,ext2bus);

--Controller
Controller : procController PORT MAP(Master_load_enable,opcode,NEQ,EQ,CLK,ARESETN,pcSEL,pcLd,instrLd,addrMd,dmWr,dataLd,
   flagLd,accSel,accLd,im2bus,dmRd,acc2bus,ext2bus,dispLd,aluMd);



--Split at juntion Instruction -> opcode, addrFromInstruction
opcode <= Instruction(11) & Instruction(10) & Instruction(9) & Instruction(8);
addrFromInstruction <= Instruction(7) & Instruction(6) & Instruction(5) & Instruction(4) & Instruction(3) & Instruction(2) & Instruction(1) & Instruction(0);

--Signaler från olika signaler i processorn till 7-segmentdispayer
pc2seg <= pc;
instr2seg <= Instruction;
Addr2seg <= Addr;
dMemOut2seg <= MemDataOutReged;
aluOut2seg <= ALUOut;
errsig2seg <= error;
busOut2seg <= BusOut;
acc2seg <= OutFromAcc;
disp2seg <= dispOut;
flag2seg <= FRegOut;

-- Flaggbitar som sänds till Controllern och processorns utsignaler
ovf <= FlagInp(0);
neq <= FlagInp(1);
eq <= FlagInp(2);
zero <= FlagInp(3);

END structural;
