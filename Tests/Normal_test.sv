class Normal_test extends uvm_test;
`uvm_component_utils(Normal_test)
    enviroment m_env;
    alu_base_seq base_seq;
    alu_rst_seq rst_seq;
    alu_cfg cfg;
    function new(string name="Normal_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("Test", "Building test", UVM_MEDIUM)
        m_env = enviroment::type_id::create("m_env", this);
        base_seq = alu_base_seq::type_id::create("base_seq", this);
        rst_seq = alu_rst_seq::type_id::create("rst_seq", this);
        cfg = alu_cfg::type_id::create("cfg", this);
        cfg.num_items = 10_000;
        uvm_config_db#(alu_cfg)::set(this, "m_env*", "cfg", cfg);
        `uvm_info("Test", "Finished building test", UVM_MEDIUM)
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("Test", "Running test", UVM_MEDIUM)
        phase.raise_objection(this);
        base_seq.start(m_env.m_agt.m_seqr);
        rst_seq.start(m_env.m_agt.m_seqr);
        phase.drop_objection(this);
        `uvm_info("Test", "Finished running test", UVM_MEDIUM)
        m_env.m_agt.m_monitor.display();
        m_env.m_scb.display();
    endtask

endclass
