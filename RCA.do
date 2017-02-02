restart -COUT -nowave
view signals wave
add wave A B CIN SUM COUT
force A(0) 0 0,1 50ns -repeat 100ns
force A(1) 0 0,1 50ns -repeat 100ns
force A(2) 0 0,0 50ns -repeat 100ns
force A(3) 0 0,0 50ns -repeat 100ns
force A(4) 0 0,1 50ns -repeat 100ns
force A(5) 0 0,1 50ns -repeat 100ns
force A(6) 0 0,0 50ns -repeat 100ns
force A(7) 0 0,0 50ns -repeat 100ns
force B(0) 0 0,0 50ns -repeat 100ns
force B(1) 0 0,0 50ns -repeat 100ns
force B(2) 0 0,1 50ns -repeat 100ns
force B(3) 0 0,1 50ns -repeat 100ns
force B(4) 0 0,0 50ns -repeat 100ns
force B(5) 0 0,0 50ns -repeat 100ns
force B(6) 0 0,1 50ns -repeat 100ns
force B(7) 0 0,1 50ns -repeat 100ns
force CIN 0 0,1 200ns -repeat 400ns
run 800ns
