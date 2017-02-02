#För test av IMEM

#restart -f -nowave
#view signals wave
#add wave ADDR DATAIN CLK WE OUTPUT
#
#force CLK		1 1,0 25ns -repeat 50ns	
#
#force WE		1
#
#force ADDR		b"00000001"
#force DATAIN		b"000000000001"
#run 100ns
#
#force ADDR		b"00000010"
#force DATAIN		b"000000000010"
#run 100ns
#
#force ADDR		b"00000011"
#force DATAIN		b"000000000011"
#run 100ns
#
#force WE		0
#
#force ADDR		b"00000001"
#run 100ns
#
#force ADDR		b"00000010"
#run 100ns
#
#force ADDR		b"00000011"
#run 100ns


# För test av DMEM
restart -f -nowave
view signals wave
add wave ADDR DATAIN CLK WE OUTPUT

force CLK		1 1,0 25ns -repeat 50ns	

force WE		1

force ADDR		b"00000001"
force DATAIN		b"00000001"
run 100ns

force ADDR		b"00000010"
force DATAIN		b"00000010"
run 100ns

force ADDR		b"00000011"
force DATAIN		b"00000011"
run 100ns

force WE		0

force ADDR		b"00000001"
run 100ns

force ADDR		b"00000010"
run 100ns

force ADDR		b"00000011"
run 100ns