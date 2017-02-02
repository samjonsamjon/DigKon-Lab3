LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY FA IS
	PORT   (ain	:IN	STD_LOGIC;
		bin	:IN	STD_LOGIC;
		ci	:IN	STD_LOGIC;
		s	:OUT	STD_LOGIC;
		cut	:OUT	STD_LOGIC
);
END FA;

ARCHITECTURE dataflow OF FA IS
BEGIN
	s	<= ci XOR ( ain XOR bin );
	cut	<= (ci AND ( ain XOR bin )) OR ( ain AND bin );
END dataflow;