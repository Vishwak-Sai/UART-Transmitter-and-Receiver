class uart_monitor extends uvm_monitor;

    virtual uart_if vif;
    uvm_analysis_port #(uart_txn) ap;

    `uvm_component_utils(uart_monitor)

    function new(string name, uvm_component parent);
        super.new(name,parent);
        ap = new("ap",this);
    endfunction

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual uart_if)::get(this,"","vif",vif))
            `uvm_fatal("MON","VIF not found")
    endfunction

    task run_phase(uvm_phase phase);
        uart_txn tr;

        forever begin
            @(posedge vif.rx_valid);

            tr = uart_txn::type_id::create("tr");
            tr.data = vif.rx_data;

            ap.write(tr);

            `uvm_info("MON",$sformatf("RX=%0h",tr.data),UVM_LOW)
        end
    endtask

endclass