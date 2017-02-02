LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.numeric_std.all ;

ENTITY CMP IS
	PORT ( 	A : IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
		B : IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
		EQ : OUT STD_LOGIC;
		NEQ : OUT STD_LOGIC 
);
END CMP;

ARCHITECTURE dataflow OF CMP IS

SIGNAL EQtemp : STD_LOGIC;
SIGNAL C : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
-- detta blev ju steeelt
C <= A XOR B;
EQtemp <= C(0) OR C(1) OR  C(2) OR C(3) OR C(4) OR C(5) OR C(6) OR C(7);
NEQ <= EQTemp;
EQ <= NOT EQTemp;


END dataflow ; --Hej
