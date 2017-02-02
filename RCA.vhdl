LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RCA IS
	PORT   (A	:IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		B	:IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		CIN	:IN	STD_LOGIC;
		SUM	:OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		COUT	:OUT	STD_LOGIC
);
END RCA;


ARCHITECTURE structural OF RCA IS

COMPONENT FA IS
	PORT   (ain	:IN	STD_LOGIC;
		bin	:IN	STD_LOGIC;
		ci	:IN	STD_LOGIC;
		s	:OUT	STD_LOGIC;
		cut	:OUT	STD_LOGIC
);
END COMPONENT;

SIGNAL C_OUT : STD_LOGIC_VECTOR(6 DOWNTO 0);



BEGIN

FA_0 : FA PORT MAP( A(0) , B(0), CIN, SUM(0), C_OUT(0));
FA_1 : FA PORT MAP( A(1) , B(1), C_OUT(0), SUM(1), C_OUT(1));
FA_2 : FA PORT MAP( A(2) , B(2), C_OUT(1), SUM(2), C_OUT(2));
FA_3 : FA PORT MAP( A(3) , B(3), C_OUT(2), SUM(3), C_OUT(3));
FA_4 : FA PORT MAP( A(4) , B(4), C_OUT(3), SUM(4), C_OUT(4));
FA_5 : FA PORT MAP( A(5) , B(5), C_OUT(4), SUM(5), C_OUT(5));
FA_6 : FA PORT MAP( A(6) , B(6), C_OUT(5), SUM(6), C_OUT(6));
FA_7 : FA PORT MAP( A(7) , B(7), C_OUT(6), SUM(7), COUT);


END structural;