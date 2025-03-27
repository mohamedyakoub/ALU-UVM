class v_seq extends uvm_sequence;
    `uvm_object_utils(v_seq)   
    `uvm_declare_p_sequencer(v_sequencer)

    alu_base_seq base_seq;
    alu_rst_seq rst_seq;

    function new(string name="v_seq");
        super.new(name);
        base_seq = alu_base_seq::type_id::create("base_seq");
        rst_seq = alu_rst_seq::type_id::create("rst_seq");
    endfunction

    

    task body();
        `uvm_info("VSeq", "Starting virtual sequence", UVM_MEDIUM)       
        
                rst_seq.start(p_sequencer.alu_seqr);
                base_seq.start(p_sequencer.alu_seqr);
           
        `uvm_info("Seq", "Finishing virtual sequence", UVM_MEDIUM)
        
    endtask
endclass