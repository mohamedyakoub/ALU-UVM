class add_test extends Normal_test;
`uvm_component_utils(add_test)

    function new(string name="add_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        set_type_override_by_type(alu_base_seq::get_type(),add_seq::get_type());
        super.build_phase(phase);
    endfunction


endclass