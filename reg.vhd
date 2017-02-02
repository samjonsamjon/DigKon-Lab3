LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reg IS
	GENERIC(N:INTEGER:=8);
	PORT( 	Data		: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		CLK		: IN STD_LOGIC;
		ARESETN		: IN STD_LOGIC;
		loadEnable	: IN STD_LOGIC;
		Q		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END reg;

ARCHITECTURE behavioral OF reg IS
BEGIN

PROCESS(CLK,ARESETN)
BEGIN
	IF(ARESETN = '1') THEN	--ARESETN är asynkron och påverkar under hela körningen sätter agendan
		IF(rising_edge(CLK)) THEN    --Förutsatt att klockan triggar på posflank bestämmer loadenable om data ska laddas eller ej
		IF (loadEnable = '1') THEN
			Q <= Data;
		ELSE
			Q <= (OTHERS=>'0'); -- Utsignalen fylls med nollor
		END IF;
		END IF;
		ELSE
			Q <= (OTHERS=>'0');
	END IF;
	END PROCESS;

END behavioral;
