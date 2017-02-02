restart -q -nowave
view signals wave
add wave Data CLK ARESETN loadEnable Q
force Data(0)		0 0,1 50ns -repeat 100ns
force Data(1)		1 1,0 50ns -repeat 100ns
force CLK		1 1,0 25ns -repeat 50ns	
force ARESETN		1 1,0 75ns -repeat 100ns	
force loadEnable	0 0,1 20ns -repeat 40ns	
run 700ns
