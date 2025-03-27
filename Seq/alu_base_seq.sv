class alu_base_seq extends uvm_sequence #(seq_item);
    `uvm_object_utils(alu_base_seq)    
    seq_item item;
    int num_items;
    alu_cfg cfg;

    function new(string name="alu_base_seq");
        super.new(name);
    endfunction

    virtual task pre_body();
        `uvm_info("Seq", "Starting pre body ", UVM_MEDIUM)
        cfg=alu_cfg::type_id::create("cfg");

        if(!uvm_config_db#(alu_cfg)::get(m_sequencer, "", "cfg", cfg))
            `uvm_fatal("NOCFG", "No configuration object found");
        
        num_items = cfg.num_items;
        `uvm_info("Seq", "Finished pre body ", UVM_MEDIUM)

    endtask

    virtual task body();

        `uvm_info("Seq", "Starting sequence", UVM_MEDIUM)
    
        item = seq_item::type_id::create("item");
        repeat(num_items) begin
            start_item(item);
            assert (item.randomize()); 
            finish_item(item);
        end

        `uvm_info("Seq", "Finishing sequence", UVM_MEDIUM)
        
    endtask
endclass