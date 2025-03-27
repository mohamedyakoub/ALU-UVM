module ALU (
    input clk,rst_n,ALU_en,
    input signed [4:0] A,B,
    input a_en,b_en,
    input [2:0] a_op,
    input [1:0] b_op,
    output reg [5:0] C
);
    
    always @(posedge clk,negedge rst_n) begin
        if(!rst_n) // ALU_rst
            `ifdef BAD_RST
                C<='b1;
            `else
                C<='b0;
            `endif
        else
            if(ALU_en)
                if(a_en && !b_en)
                    case (a_op)

                        `ifdef BAD_ADD
                            3'd0: C<= A+ !B;
                        `else
                            3'd0: C<= A+B;
                        `endif

                        3'd0: C<= A+B;
                        3'd1: C<= A-B;
                        3'd2: C<= A^B;
                        
                        `ifdef BAD_AND
                            3'd3: C<= A& !B;
                            3'd4: C<= A& !B;
                        `else
                            3'd3: C<= A&B;
                            3'd4: C<= A&B;
                        `endif

                        3'd5: C<= A|B;
                        3'd6: C<= A~^B;
                        default: C<='hFF; 
                    endcase
                else if(!a_en && b_en)
                    case (b_op)
                        2'd0: C<= ~(A & B);

                        `ifdef BAD_ADD
                            2'd1: C<= A+~B;
                            2'd2: C<= A+~B;
                        `else
                            2'd1: C<= A+B;
                            2'd2: C<= A+B;
                        `endif
                            
                        default: C<='hFF; 
                    endcase
                else if(a_en && b_en)
                    case (b_op)
                        2'd0: C<= A^B;
                        2'd1: C<= A~^B;
                        2'd2: C<= A-1;
                        2'd3: C<= B+2;
                    endcase
                else
                    C<=C;
            else
                C<=C;
    end
endmodule
