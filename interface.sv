interface alu_if(input bit clk);

    logic rst_n,ALU_en,a_en,b_en;
    logic signed [4:0] A,B;
    logic signed [5:0] C;
    logic [2:0] a_op;
    logic [1:0] b_op;

        
endinterface 