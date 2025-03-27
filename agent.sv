
class agent extends uvm_agent;
    `uvm_component_utils(agent)
    driver m_driver;
    monitor m_monitor;
    sequencer m_seqr;
    alu_cfg cfg;

    function new(string name="agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("Agent", "Building agent", UVM_MEDIUM)
        cfg = alu_cfg::type_id::create("cfg", this);
        if(!(uvm_config_db#(alu_cfg)::get(this, "", "alu_cfg", cfg)))
            `uvm_fatal("NOCFG", "No configuration found");

        m_driver = driver::type_id::create("m_driver", this);
        m_monitor = monitor::type_id::create("m_monitor", this);
        m_seqr = sequencer::type_id::create("m_seqr", this);

        `uvm_info("Agent", "Finished building agent", UVM_MEDIUM)
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("Agent", "Connecting agent", UVM_MEDIUM)
        m_driver.seq_item_port.connect(m_seqr.seq_item_export);
        `uvm_info("Agent", "Finished connecting agent", UVM_MEDIUM)
    endfunction
endclass 