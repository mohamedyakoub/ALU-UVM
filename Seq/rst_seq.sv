class alu_rst_seq extends uvm_sequence #(seq_item);
    `uvm_object_utils(alu_rst_seq)    
    seq_item item;

    function new(string name="alu_rst_seq");
        super.new(name);
    endfunction

    

    virtual task body();
        `uvm_info("Seq", "Starting Reset sequence", UVM_MEDIUM)

        item = seq_item::type_id::create("item");
            start_item(item);
            item.rst_n=1;
            item.A=0;
            item.B=0;
            item.ALU_en=0;
            item.a_en=0;
            item.b_en=0;
            item.a_op=0;
            item.b_op= 0;      
            finish_item(item);
            start_item(item);
            item.rst_n=0;
            finish_item(item);

        `uvm_info("Seq", "Finishing Reset sequence", UVM_MEDIUM)
        
    endtask
endclass