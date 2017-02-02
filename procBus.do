restart -OUTPUT -nowave
view signals wave
add wave INSTRUCTION DATA ACC EXTDATA OUTPUT ERR instrSEL dataSEL accSEL extdataSEL	

force INSTRUCTION 	b"00000001"
force DATA		b"00000010" 
force ACC 		b"00000011"
force EXTDATA		b"00000100"

force instrSEL   0 
force dataSEL    0
force accSEL     0
force extdataSEL 0
run 100ns

force instrSEL   1 
force dataSEL    0
force accSEL     0
force extdataSEL 0
run 100ns

force instrSEL   0 
force dataSEL    1
force accSEL     0
force extdataSEL 0
run 100ns

force instrSEL   0 
force dataSEL    0
force accSEL     1
force extdataSEL 0
run 100ns

force instrSEL   0 
force dataSEL    0
force accSEL     0
force extdataSEL 1
run 100ns

force instrSEL   1 
force dataSEL    1
force accSEL     0
force extdataSEL 0
run 100ns

force instrSEL   0 
force dataSEL    0
force accSEL     1
force extdataSEL 1
run 100ns

force instrSEL   0 
force dataSEL    1
force accSEL     0
force extdataSEL 1
run 100ns

force instrSEL   1 
force dataSEL    1
force accSEL     1
force extdataSEL 1
run 100ns