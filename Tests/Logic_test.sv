class Logic_test extends Normal_test;
`uvm_component_utils(Logic_test)

    function new(string name="Logic_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        set_type_override_by_type(alu_base_seq::get_type(),Logic_seq::get_type());
        super.build_phase(phase);
    endfunction


endclass