class coverage extends uvm_subscriber#(seq_item);
    `uvm_component_utils(coverage)
   seq_item tr;
   covergroup CovGrp; 
  
        RST_CP    :coverpoint tr.rst_n; 

        // Coverpoint for A ,B and C to cover the important values
		A_CP :coverpoint tr.A {
			bins MAXNEG 	    = {-15};
			bins MAXPOS 	    = {15};
			bins ZERO	    = {0};
			bins pattern_1 	= {-11};
			bins pattern_2 	= {10};
            illegal_bins ILLEGAL= {-16};
			bins Rest[2]	= default;
		}

		B_CP :coverpoint tr.B {
			bins MAXNEG 	    = {-15};
			bins MAXPOS 	    = {15};
			bins ZERO 	    = {0};
			bins pattern_1 	= {-11};
			bins pattern_2 	= {10};
            illegal_bins ILLEGAL= {-16};
			bins Rest[2]	= default;
		}

        C_CP : coverpoint tr.C{
            bins MAXNEG     = {-31};
            bins MAXPOS     = {31};
            bins ZERO       = {0};
            bins ONES     = {-1};
            illegal_bins ILLEGAL = {-32};
            bins Rest[3] = default;
        }

        RST_C_CP :cross RST_CP, C_CP{
            bins C_0 = binsof(RST_CP) intersect {0} && binsof(C_CP.ZERO);
            ignore_bins C_NOT_RST = binsof(RST_CP) intersect {1};
            ignore_bins C_MAXNEG = binsof(RST_CP) intersect {0} && binsof(C_CP.MAXNEG);
            ignore_bins C_MAXPOS = binsof(RST_CP) intersect {0} && binsof(C_CP.MAXPOS);
            ignore_bins C_ONES = binsof(RST_CP) intersect {0} && binsof(C_CP.ONES);
        }

        // Coverpoint for ALU_en, a_en, b_en to cover the enable signals and use a_enum and b_en to cover the b_op operation sets
		ALU_EN_CP :coverpoint tr.ALU_en;
		A_EN_CP   :coverpoint tr.a_en;
		B_EN_CP   :coverpoint tr.b_en;

        A_B_EN_CP :cross ALU_EN_CP,A_EN_CP, B_EN_CP{    
            ignore_bins ALU_NOT_EN = binsof(ALU_EN_CP) intersect {0}; // ignore the case where ALU is not enabled
            bins A_NOT_EN_B_NOT_EN = binsof(A_EN_CP) intersect {0} && binsof(B_EN_CP) intersect {0};       
            bins A_EN_B_NOT_EN = binsof(A_EN_CP) intersect {1} && binsof(B_EN_CP) intersect {0};
            bins A_NOT_EN_B_EN = binsof(A_EN_CP) intersect {0} && binsof(B_EN_CP) intersect {1};
            bins A_EN_B_EN = binsof(A_EN_CP) intersect {1} && binsof(B_EN_CP) intersect {1};
        }

        // Coverpoint for a_op operation set
		A_OP_CP   :coverpoint tr.a_op{
            bins ADD_A={0};
            bins SUB_A={1};
            bins XOR_A={2};
            bins AND_A={3,4};
            bins OR_A={5}; 
            bins XNOR_A={6};
            ignore_bins ILLEGAL={7};
        }

        // Cross coverage between A_EN_CP, B_EN_CP, A_OP_CP to cover all possible combinations for the set of operations 
        // The cross coverage will be used to cover the 7 possible combinations
        A_OP_EN_CP :cross A_OP_CP, A_EN_CP,B_EN_CP,ALU_EN_CP {
            ignore_bins ALU_NOT_EN = binsof(ALU_EN_CP) intersect {0}; // ignore the case where ALU is not enabled
            ignore_bins A_NOT_EN = binsof(A_EN_CP) intersect {0}; // ignore the case where a_en is not enabled
            ignore_bins B_EN = binsof(B_EN_CP) intersect {1}; // ignore the case where b_en is enabled 
            bins ADD_a = binsof(A_OP_CP.ADD_A);
            bins SUB_a = binsof(A_OP_CP.SUB_A);
            bins XOR_a = binsof(A_OP_CP.XOR_A);
            bins AND_a = binsof(A_OP_CP.AND_A);
            bins OR_a = binsof(A_OP_CP.OR_A);
            bins XNOR_a = binsof(A_OP_CP.XNOR_A);
            
        }

        // Coverpoint for b_op but not for a specific operation set
        B_OP_CP   :coverpoint tr.b_op {
            bins B_0 ={0};
            bins B_1 ={1};
            bins B_2 ={2};
            bins B_3 ={3};
            option.weight=0;
        } 

        // Cross coverage between A_EN_CP, B_EN_CP, B_OP_CP to cover all possible combinations for the 2 sets of operations 
        // The cross coverage will be used to cover the 8 possible combinations, 4 for each set of operations
        B_OP_EN_CP : cross A_EN_CP, B_EN_CP, B_OP_CP , ALU_EN_CP{
            ignore_bins ALU_NOT_EN = binsof(ALU_EN_CP) intersect {0}; // ignore the case where ALU is not enabled
            ignore_bins B_NOT_EN =binsof(B_EN_CP) intersect {0}; // ignore the case where b_en is not enabled
            // The first set of operations when b_en is enabled and a_en is not
            bins NAND_b = binsof(A_EN_CP) intersect{0}  && binsof(B_OP_CP.B_0);
            bins ADD_b = binsof(A_EN_CP) intersect{0}   && (binsof(B_OP_CP.B_1) || binsof(B_OP_CP.B_2));
            bins NULL_b = binsof(A_EN_CP) intersect{0}  && binsof(B_OP_CP.B_3);
            // The first set of operations when b_en is enabled and a_en is also enabled
            bins XOR_b = binsof(A_EN_CP) intersect{1}   && binsof(B_OP_CP.B_0);
            bins XNOR_b = binsof(A_EN_CP) intersect{1}  && binsof(B_OP_CP.B_1);
            bins A_SUB_b = binsof(A_EN_CP) intersect{1} && binsof(B_OP_CP.B_2);
            bins B_ADD_b = binsof(A_EN_CP) intersect{1} && binsof(B_OP_CP.B_3);
        }

        
	endgroup

    function new(string name="coverage", uvm_component parent=null);
        super.new(name, parent);
        CovGrp=new();
    endfunction
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
    function void write(T t);
        $cast(tr, t);
        CovGrp.sample();
    endfunction

endclass