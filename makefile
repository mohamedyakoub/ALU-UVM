#Define 
SRC_FILES =assertions.sv alu.sv interface.sv alu_pkg.sv
TOP = top.sv

#The test you want to run. 
TEST=+UVM_TESTNAME=Normal_test

#Choose from:
#Normal_test : a test that randomize all the inputs based on the constraints
#add_test: a test that only uses the op codes tha uses the add functions in the alu 
#sub_test: a test that only uses the op codes tha uses the substraction functions in the alu 
#Arith_test: Tests the arithmatic functions in the alu 
#Logic_test: Tests the logic functions in the alu 

#Random seed value so if a specific seed catches an error we can reproduce it 
Seed_value = 26523844

#Flags 
VCS_FLAGS = -sverilog -debug_access+all -cm line+cond+tgl+fsm+branch -timescale=1ns/1ps -ntb_opts uvm +define+
DVE_FLAGS = -l simulation_log.txt -cm line+cond+tgl+fsm+branch  +ntb_random_seed=$(Seed_value) -gui
URG_FLAGS = -dir simv.vdb -format both

#Default target
# Uses only one test that is specifed by the TEST parameter above
all: clean compile simulate coverage_reports coverage open_coverage_reports

#uses more than one test and merges the coverage of them (currently using the Artihamtic test and the Logic test)
#all: clean Test_Arith Test_Logic coverage_merge DVE_coverage open_reports

#compile the design
compile:  
	@echo "Compiling with VCS Test1..."
	vcs $(VCS_FLAGS)  $(SRC_FILES)	$(TOP)  -o simv 

#simulate the design
simulate:
	@echo "Running simulation Test1..."
	./simv $(DVE_FLAGS) $(TEST) 

#coverage report
coverage_reports:
	@echo "Running coverage reports..."
	urg  $(URG_FLAGS)
 
#coverage
coverage:
	@echo "Running coverage..."
	dve -cov -dir simv.vdb & 

#simulate and compile the Test_Arith
Test_Arith:
	@echo "Compiling with VCS Test1..."
	vcs $(VCS_FLAGS)  $(SRC_FILES)	$(TOP)  -o simv -cm_dir ./cov_Arith
	@echo "Running simulation Test1..."
	./simv $(DVE_FLAGS) +UVM_TESTNAME=Arith_test
	


#simulate and compile the Test_Logic
Test_Logic:  
	@echo "Compiling with VCS Test2 ..."
	vcs $(VCS_FLAGS)  $(SRC_FILES)	$(TOP)  -o simv -cm_dir ./cov_Logic
	@echo "Running simulation Test2..."
	./simv $(DVE_FLAGS) +UVM_TESTNAME=Logic_test



#coverage report for the mergesd==d
coverage_merge:
	@echo "Running coverage reports..."
	urg  -dir cov_Arith -dir cov_Logic  -dbname merged_cov_db -format both
 
#coverage for the merged using dve gui
DVE_coverage:
	@echo "Running coverage..."
	dve -cov -dir merged_cov_db.vdb & 



#open coverage reports
open_coverage_reports:
	@echo "open coverage reports..."
	#firefox urgReport/dashboard.html 
	gedit urgReport/dashboard.txt 

# clean files 
clean:
	@echo "Cleaning up..."
	rm -rf csrc *.vcd *.vpd *.log *.key DVEfiles simv.daidir urgReport *.tar.gz
