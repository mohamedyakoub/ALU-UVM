typedef enum bit [2:0] {ADD_a=0, SUB_a=1, XOR_a=2, AND_a1=3, AND_a2=4, OR_a=5, XNOR_a=6, NULL_a=7} op_a;
typedef enum bit [1:0] {NAND_b=0, ADD_b1=1, ADD_b2=2, NULL_b=3} op_b_0;
typedef enum bit [1:0] {XOR_b=0, XNOR_b=1, A_SUB_b=2, B_ADD_b=3} op_b_1;

class seq_item extends uvm_sequence_item;
    `uvm_object_utils(seq_item)
    parameter MAXPOS    = 15,        // 01111
    MAXNEG    ='b10001,   
    ZERO      ='b0,       
    ILLEGAL   ='b10000,
    ONES      ='b11111,   
    pattern_1 = 10,       // 01010
    pattern_2 ='b10101;

    function new(string name="seq_item");
        super.new(name);
    endfunction

    rand bit signed [4:0] A,B;
    bit signed [5:0] C;
    rand bit rst_n,ALU_en,a_en,b_en;
    rand op_a a_op_0; 
    rand op_b_0 b_op_0; 
    rand op_b_1 b_op_1;
    rand bit [2:0] a_op; 
    rand bit [1:0] b_op;

    // Reset constraint: rst_n is more likely to be deasserted
    constraint rst {
    rst_n dist  {1:=99 , 0:=10};
    }

    // Arithmetic constraints for A and B
    constraint A_B_arith {
    if(a_op_0==ADD_a || a_op_0==SUB_a || b_op_0==ADD_b1 || b_op_0==ADD_b2 || b_op_1==A_SUB_b || b_op_1== B_ADD_b) {
    A dist { MAXPOS :/ 20 , ONES:/20 ,ZERO :/ 20 , MAXNEG :/ 20 , [ZERO+1:MAXPOS-1] :/ 20, ILLEGAL :/ 0 ,[MAXNEG+1:ONES-1]:/20 } ; 
    B dist { MAXPOS :/ 20 , ONES:/20 ,ZERO :/ 20 , MAXNEG :/ 20 , [ZERO+1:MAXPOS-1] :/ 20, ILLEGAL :/ 0 ,[MAXNEG+1:ONES-1]:/20 } ; 
    }
    }

    // Logic constraints for A and B
    constraint A_B_logic {
    if( !(a_op_0==ADD_a || a_op_0==SUB_a || b_op_0==ADD_b1 || b_op_0==ADD_b2 || b_op_1==A_SUB_b || b_op_1== B_ADD_b)) {
    A dist {  ILLEGAL :/0, ONES:/20 ,ZERO :/ 20 , pattern_1:/20 , pattern_2:/20 , [ZERO+1:pattern_1-1] :/ 20 , [pattern_1+1:ILLEGAL-1] :/20 ,[ILLEGAL+1:pattern_2-1] :/ 20 , [pattern_2+1:ONES-1] :/ 20  } ; 
    B dist {  ILLEGAL :/0, ONES:/20 ,ZERO :/ 20 , pattern_1:/20 , pattern_2:/20 , [ZERO+1:pattern_1-1] :/ 20 , [pattern_1+1:ILLEGAL-1] :/20 ,[ILLEGAL+1:pattern_2-1] :/ 20 , [pattern_2+1:ONES-1] :/ 20  } ; 
    }
    }

    // Enable constraints 
    constraint Enable {
    ALU_en dist {1:=90, 0:=30 };
    a_en   dist {1:=50, 0:=50 };
    b_en   dist {1:=50, 0:=50 };

    }

    // Operation constraints
    constraint op {
    a_op_0 dist {NULL_a:=10, [ADD_a:XNOR_a]:=50 };
    a_op==a_op_0;
    b_op_0 dist {NULL_b:=10, [NAND_b:ADD_b2]:=50 };
    b_op_1 dist {[XOR_b:B_ADD_b]:=50 };
    if(a_en && b_en)
    b_op==b_op_1;
    else
    b_op==b_op_0;
    }

endclass
