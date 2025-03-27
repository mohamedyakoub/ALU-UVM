class alu_cfg extends uvm_object;
    `uvm_object_utils(alu_cfg)
    int cfg_val;
    virtual alu_if vif;
    int num_items=5000;
    function new(string name="alu_cfg");
        super.new(name);
    endfunction
endclass