vlib work
vlog interface.sv alu.sv alu_pkg.sv top.sv +cover +fcover
vsim -voptargs=+acc work.top -cover +UVM_TESTNAME=Normal_test -sv_seed random
coverage save top.ucdb -onexit 
run -all 
quit -sim
vcover report top.ucdb -details -annotate -all -output coverage_rpt.txt
