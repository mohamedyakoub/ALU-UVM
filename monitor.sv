class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)
    virtual alu_if vif;
    uvm_analysis_port#(seq_item) mon_ap;
    seq_item item;
    int no_trans;

    function new(string name="monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info("Monitor", "Building monitor", UVM_MEDIUM)

        mon_ap = new ("mon_ap", this);
        if(!(uvm_config_db#(virtual alu_if)::get(null, "", "vif", vif)))
            `uvm_fatal("NOVIF", "No virtual interface found");

        `uvm_info("Monitor", "Finished building monitor", UVM_MEDIUM) 

    endfunction

    virtual task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("Monitor", "Running monitor", UVM_MEDIUM)
        forever begin
            item = seq_item::type_id::create("item");
            item.A=vif.A;
            item.B=vif.B;
            item.ALU_en=vif.ALU_en;
            item.a_en=vif.a_en;
            item.b_en=vif.b_en;
            item.a_op=vif.a_op;
            item.b_op=vif.b_op;
            no_trans++;

            if(!vif.rst_n )begin
                item.rst_n=vif.rst_n;
                item.C=vif.C;
                mon_ap.write(item);
                @(posedge vif.clk);  
            end

            else if(vif.ALU_en ) begin
                @(posedge vif.clk);
                item.rst_n=vif.rst_n;
                item.C=vif.C;
                mon_ap.write(item);          
            end

            else begin
                @(posedge vif.clk);
            end
            ///// OR
            // tr.A=vif.A;
            // tr.B=vif.B;
            // tr.ALU_en=vif.ALU_en;
            // tr.a_en=vif.a_en;
            // tr.b_en=vif.b_en;
            // tr.a_op=vif.a_op;
            // tr.b_op=vif.b_op;
            // @(posedge vif.clk);
            // tr.rst_n=vif.rst_n;
            // tr.C=vif.C;
            // mon_ap.write(item);
        end
    endtask

    task  display();
    //`uvm_info("Monitor", "No. of total transactions is %d",no_trans,UVM_MEDIUM)

        $display("No. of total transactions is %d",no_trans);
    endtask 
    
endclass