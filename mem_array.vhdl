LIBRARY ieee;
USE ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
USE std.textio.all;
USE ieee.numeric_std.all;

ENTITY mem_array IS
	GENERIC (
--		DATA_WIDTH: integer := 12;
		DATA_WIDTH: integer := 8;
		ADDR_WIDTH: integer := 8;
--		INIT_FILE: string := "inst_mem.mif"
		INIT_FILE: string := "data_mem.mif"
);
	PORT(	ADDR : IN STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
		DATAIN : IN STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		CLK : IN STD_LOGIC;
		WE : IN STD_LOGIC;
		OUTPUT : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0));
END mem_array;



ARCHITECTURE behavorial OF mem_array IS
Type MEMORY_ARRAY IS ARRAY (0 to ADDR_WIDTH-1) OF STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);

impure function init_memory_wfile(mif_file_name : in string) return MEMORY_ARRAY is
    file mif_file : text open read_mode is mif_file_name;
    variable mif_line : line;
    variable temp_bv : bit_vector(DATA_WIDTH-1 downto 0);
    variable temp_mem : MEMORY_ARRAY;
begin
    for i in MEMORY_ARRAY'range loop
        readline(mif_file, mif_line);
        read(mif_line, temp_bv);
        temp_mem(i) := to_stdlogicvector(temp_bv);
    end loop;
    return temp_mem;
end function;

SIGNAL MEM1 : MEMORY_ARRAY;

BEGIN

PROCESS(CLK,WE)
BEGIN
IF(WE = '0') THEN
OUTPUT <= MEM1(to_integer(unsigned(ADDR)));
ELSIF(rising_edge(CLK)) THEN 
MEM1(to_integer(unsigned(ADDR))) <= DATAIN;
END IF;
END PROCESS;


END behavorial;