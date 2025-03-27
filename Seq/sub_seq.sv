class sub_seq extends alu_base_seq;
    `uvm_object_utils(sub_seq)    
    
    function new(string name="sub_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info("Seq", "Starting sequence", UVM_MEDIUM)
        item = seq_item::type_id::create("item");
        repeat(num_items) begin
            start_item(item);
            assert (item.randomize() with {
            a_op_0 == SUB_a;
            b_op_1 == A_SUB_b;
            if(b_en) (a_en==1);
                                           });  
            finish_item(item);
        end

        `uvm_info("Seq", "Finishing sequence", UVM_MEDIUM)
        
    endtask
endclass