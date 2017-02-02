library IEEE;
use IEEE.std_logic_1164.all;

ENTITY MUX4_1 IS
	PORT   (I  : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      		SEL : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      		O : OUT STD_LOGIC);
END MUX4_1;

ARCHITECTURE behavioral OF MUX4_1 IS
	SIGNAL s_0 : STD_LOGIC;
	SIGNAL s_1 : STD_LOGIC;

COMPONENT MUX2_1 IS
	PORT   (A : IN 	STD_LOGIC; 
		B : IN 	STD_LOGIC;
      		S : IN 	STD_LOGIC;
      		Y : OUT STD_LOGIC
	);
END COMPONENT;

BEGIN
  	L0 : MUX2_1 PORT MAP( I(0), I(1), SEL(0), s_0);
	L1 : MUX2_1 PORT MAP( I(2), I(3), SEL(0), s_1);
	L2 : MUX2_1 PORT MAP( s_0, s_1, SEL(1), O);

END behavioral;