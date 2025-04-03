module alu_assertions (
    input clk,rst_n,ALU_en,
    input signed [4:0] A,B,
    input a_en,b_en,
    input [2:0] a_op,
    input [1:0] b_op,
    input signed [5:0] C
);
    sequence xor_b;
	(a_en & b_en) ##0 (b_op==0);
    endsequence
    sequence xor_a;
	(a_en & !b_en) ##0 (a_op==2);
    endsequence
    sequence xnor_b;
	(a_en & b_en) ##0 (b_op==1);
    endsequence
    sequence xnor_a;
	(a_en & !b_en) ##0 (a_op==6);
    endsequence
    sequence add_b;
	(!a_en & b_en) ##0 (b_op==1 || b_op==2 );
    endsequence
    sequence add_a;
	(a_en & !b_en) ##0 (a_op==0);
    endsequence

    property xor_p;
        @(posedge clk) disable iff(!ALU_en || !rst_n) (xor_a or xor_b) |=>(C[4:0]==$past(A)^$past(B)) ;
    endproperty
    property xnor_p;
        @(posedge clk) disable iff(!ALU_en || !rst_n) (xnor_a or xnor_b) |=>(C[4:0]==$past(A)~^$past(B)) ;
    endproperty
    property sub_a_p;
        @(posedge clk) disable iff(!ALU_en || !rst_n) (a_en & b_en) |-> (b_op==2) |=>(C==$past(A)-1) ;
    endproperty
    property add_b_p;
        @(posedge clk) disable iff(!ALU_en || !rst_n) (a_en & b_en) |-> (b_op==3) |=>(C==$past(B)+2) ;
    endproperty

    property add_p;
        @(posedge clk) disable iff(!ALU_en || !rst_n) (add_a or add_b) |=>(C==$past(A)+$past(B)) ;
    endproperty
    property and_p;
        @(posedge clk) disable iff(!ALU_en || !rst_n) (a_en & !b_en) |-> (a_op== 3 || a_op== 4)  |=> (C[4:0]==($past(A)&$past(B)))  ;
    endproperty
    property or_p;
        @(posedge clk) disable iff(!ALU_en || !rst_n) (a_en & !b_en) |-> (a_op== 5)  |=> (C[4:0]==$past(A)||$past(B)) ;
    endproperty
    property nand_p;
        @(posedge clk) disable iff(!ALU_en || !rst_n) (!a_en & b_en) |-> (b_op== 0)  |=> (C[4:0]==~($past(A)&$past(B))) ;
    endproperty

    // Assertion for addition
    xor_assert: assert property (xor_p);
    xnor_assert: assert property (xnor_p);
    sub_a_assert: assert property (sub_a_p);
    add_b_assert: assert property (add_b_p);
    add_assert: assert property (add_p);
    and_assert: assert property (and_p);
    or_assert: assert property (or_p);
    nand_assert: assert property (nand_p);

    xor_cover: cover property  (xor_p);
    xnor_cover: cover property  (xnor_p);
    sub_a_cover:cover property  (sub_a_p);
    add_b_cover:cover property  (add_b_p);
    add_cover:cover property  (add_p);
    and_cover:cover property (and_p);
    or_cover:cover property (or_p);
    nand_cover:cover property (nand_p);
endmodule
