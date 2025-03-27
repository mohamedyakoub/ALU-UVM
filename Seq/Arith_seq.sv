class Arith_seq extends alu_base_seq;
    `uvm_object_utils(Arith_seq)    
//`uvm_sequence_utils(alu_base_seq,sequencer)
    
    function new(string name="Arith_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info("Seq", "Starting sequence", UVM_MEDIUM)
        item = seq_item::type_id::create("item");
        repeat(num_items) begin
            start_item(item);
            assert (item.randomize() with {
                a_op_0 inside{ADD_a,SUB_a};                            
                b_op_0 inside{ADD_b1,ADD_b2 };                   
                b_op_1 inside{A_SUB_b,B_ADD_b};
            });  
            finish_item(item);
        end

        `uvm_info("Seq", "Finishing sequence", UVM_MEDIUM)
        
    endtask
endclass