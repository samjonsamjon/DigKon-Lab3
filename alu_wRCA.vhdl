
LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.numeric_std.all ;

ENTITY alu_wRCA IS
	PORT ( 	ALU_inA 	: IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
		ALU_inB 	: IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
		Operation 	: IN STD_LOGIC_VECTOR(1 DOWNTO 0) ;
		ALU_out		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0) ;
		Carry		: OUT STD_LOGIC ;
		NotEq		: OUT STD_LOGIC ;
		Eq		: OUT STD_LOGIC ;
		isOutZero	: OUT STD_LOGIC 

);
END alu_wRCA;

ARCHITECTURE structural OF alu_wRCA IS

COMPONENT RCA IS
	PORT   (A	:IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		B	:IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		CIN	:IN	STD_LOGIC;
		SUM	:OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		COUT	:OUT	STD_LOGIC
);
END COMPONENT;

COMPONENT CMP IS
	PORT ( 	A : IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
		B : IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
		EQ : OUT STD_LOGIC;
		NEQ : OUT STD_LOGIC 
);
END COMPONENT;


SIGNAL A : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL B : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL C : STD_LOGIC;

SIGNAL SIGN_AND : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL SIGN_NOT : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL SIGN_ADD : STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL EQSPEZ	: STD_LOGIC;
SIGNAL NEQSPZ	: STD_LOGIC;

SIGNAL ALU_outTemp : STD_LOGIC_VECTOR(7 DOWNTO 0);

signal zero : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal one : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal two : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal three : STD_LOGIC_VECTOR(1 DOWNTO 0);

signal zerov : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

zero <= "00";
one <= "01";
two <= "10";
three <= "11";

zerov <= "00000000";

C <= '1' when Operation = one else '0';
B <= NOT ALU_inB when Operation = one else ALU_inB;

SIGN_AND <= ALU_inA AND ALU_inB;
SIGN_NOT <= NOT ALU_inA;

RCA_A : RCA PORT MAP(ALU_inA,B,C,SIGN_ADD,Carry);
CMP_1 : CMP PORT MAP(ALU_inA,ALU_inB,Eq,NotEq);


ALU_outTemp <= 	SIGN_ADD WHEN Operation = zero ELSE
		SIGN_ADD WHEN Operation = one ELSE
 		SIGN_AND WHEN Operation = two ELSE
		SIGN_NOT WHEN Operation = three ELSE
		zerov;

ALU_out <= ALU_outTemp;

CMP_2 : CMP PORT MAP(ALU_inA,ALU_inB,EQSPEZ,NEQSPZ);
		
IsOutZero <= '1' WHEN EQSPEZ = '1' ELSE '0';

END structural;