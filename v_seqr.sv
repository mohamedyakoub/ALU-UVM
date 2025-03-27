class v_sequencer extends uvm_sequencer ;
`uvm_component_utils(v_sequencer)

    sequencer alu_seqr;
    
    function new(string name="v_sequencer", uvm_component parent=null);
        super.new(name, parent); 
    endfunction
    



endclass