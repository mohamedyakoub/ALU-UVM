module top ();

    import uvm_pkg::*;
    import alu_pkg::*;
    bit clk=0;
    initial begin
        forever begin
            #10 clk=!clk;
        end
    end

    alu_if aluif(clk);
    ALU dut (clk,aluif.rst_n,aluif.ALU_en,aluif.A,aluif.B,aluif.a_en,aluif.b_en,aluif.a_op,aluif.b_op,aluif.C);
    bind ALU alu_assertions assertions_inst (clk,aluif.rst_n,aluif.ALU_en,aluif.A,aluif.B,aluif.a_en,aluif.b_en,aluif.a_op,aluif.b_op,aluif.C);





    initial begin 
        uvm_config_db#(virtual alu_if)::set(null,"","vif",aluif);
        $dumpfile("dump.vcd"); $dumpvars;
    end
      
    initial begin 
        run_test();
    end
    
    
    // initial begin
    //     m_env= new();
    //     m_env.connect_env(aluif);
    //     m_env.reset();
    //     m_env.run(50000);
    //     $stop;
    // end
    
endmodule