class enviroment extends uvm_env;
    `uvm_component_utils(enviroment)
    agent m_agt;
    scoreboard m_scb;
    coverage m_cov;
    alu_cfg cfg;
    function new(string name="enviroment", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    
    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("Env", "Building enviroment", UVM_MEDIUM)
        m_agt =agent::type_id::create("m_agt", this);   
        m_scb =scoreboard::type_id::create("m_scb", this);
        m_cov =coverage::type_id::create("m_cov", this);
        cfg   =alu_cfg::type_id::create("cfg", this);

        if(!(uvm_config_db#(virtual alu_if)::get(null, "", "vif", cfg.vif)))
            `uvm_fatal("NOVIF", "No virtual interface found");

        uvm_config_db#(alu_cfg)::set(this, "m_agt*", "alu_cfg", cfg);

        `uvm_info("Env", "Finished building enviroment", UVM_MEDIUM)

    endfunction

    virtual function void connect_phase (uvm_phase phase);
    
        super.connect_phase(phase);    
        `uvm_info("Env", "Connecting enviroment", UVM_MEDIUM) 
        m_agt.m_monitor.mon_ap.connect(m_scb.sb_mb);
        m_agt.m_monitor.mon_ap.connect(m_cov.analysis_export);
        `uvm_info("Env", "Finished connecting enviroment", UVM_MEDIUM)        
    endfunction

endclass