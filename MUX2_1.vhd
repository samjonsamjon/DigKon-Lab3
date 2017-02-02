library IEEE;
use IEEE.std_logic_1164.all;

ENTITY MUX2_1 IS
	PORT   (A : IN 	STD_LOGIC_VECTOR(7 DOWNTO 0); 
		B : IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
      		S : IN 	STD_LOGIC;
      		Y : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END MUX2_1;

ARCHITECTURE dataflow OF MUX2_1 IS
BEGIN
	Y <= A WHEN S = '0' ELSE B;
END dataflow;