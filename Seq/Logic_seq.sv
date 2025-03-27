class Logic_seq extends alu_base_seq;
    `uvm_object_utils(Logic_seq)    
//`uvm_sequence_utils(alu_base_seq,sequencer)
    
    function new(string name="Logic_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info("Seq", "Starting sequence", UVM_MEDIUM)
        item = seq_item::type_id::create("item");
        repeat(num_items) begin
            start_item(item);
            assert (item.randomize() with {
                a_op_0 inside{XOR_a,AND_a1,AND_a2,OR_a,XNOR_a};                            
                b_op_0 inside{NAND_b};                   
                b_op_1 inside{XNOR_b,XOR_b};
            });  
            finish_item(item);
        end

        `uvm_info("Seq", "Finishing sequence", UVM_MEDIUM)
        
    endtask
endclass