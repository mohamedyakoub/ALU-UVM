class driver extends uvm_driver#(seq_item);
    `uvm_component_utils(driver)
    virtual alu_if vif;
    seq_item item;

    function new(string name="driver", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("Driver", "Building driver", UVM_MEDIUM)
        if(!(uvm_config_db#(virtual alu_if)::get(null, "", "vif", vif)))
            `uvm_fatal("NOVIF", "No virtual interface found");
        `uvm_info("Driver", "Finished building driver", UVM_MEDIUM)
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("Driver", "Running driver", UVM_MEDIUM)
        //reset();
        forever begin
            seq_item_port.get_next_item(item);
            drive(item);
            seq_item_port.item_done ();
        end
    endtask

    task reset();
        `uvm_info("Driver", "Resetting driver", UVM_MEDIUM)
        vif.rst_n=1;
        vif.ALU_en=0;
        vif.A=0;
        vif.B=0;
        vif.a_en=0;
        vif.b_en=0;
        vif.a_op=0;
        vif.b_op=0;
        @(negedge vif.clk);
        vif.rst_n=0;
        @(negedge vif.clk);
        `uvm_info("Driver", "Finished resetting driver", UVM_MEDIUM)
    endtask 

    task drive(seq_item tr);
            vif.rst_n=tr.rst_n;
            vif.ALU_en=tr.ALU_en;
            vif.A=tr.A;
            vif.B=tr.B;
            vif.a_en=tr.a_en;
            vif.b_en=tr.b_en;
            vif.a_op=tr.a_op;
            vif.b_op=tr.b_op;
            @(negedge vif.clk);
    endtask
endclass