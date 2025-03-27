module alu_assertions (
    input clk,rst_n,ALU_en,
    input signed [4:0] A,B,
    input a_en,b_en,
    input [2:0] a_op,
    input [1:0] b_op,
    input signed [5:0] C
);

    property p1;
        @(posedge clk) disable iff(!ALU_en || !rst_n) (a_en & b_en) |-> (b_op==0) |=>(C[4:0]==$past(A)^$past(B)) ;
    endproperty
    property p2;
        @(posedge clk) disable iff(!ALU_en || !rst_n) (a_en & b_en) |-> (b_op==1) |=>(C[4:0]==$past(A)~^$past(B)) ;
    endproperty
    property p3;
        @(posedge clk) disable iff(!ALU_en || !rst_n) (a_en & b_en) |-> (b_op==2) |=>(C==$past(A)-1) ;
    endproperty
    property p4;
        @(posedge clk) disable iff(!ALU_en || !rst_n) (a_en & b_en) |-> (b_op==3) |=>(C==$past(B)+2) ;
    endproperty
    // Assertion for addition
    assert property (p1);
    assert property (p2);
    assert property (p3);
    assert property (p4);

    cover property  (p1);
    cover property  (p2);
    cover property  (p3);
    cover property  (p4);
endmodule