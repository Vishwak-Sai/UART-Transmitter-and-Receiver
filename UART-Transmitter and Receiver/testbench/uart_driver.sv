class uart_driver extends uvm_driver #(uart_txn);

    virtual uart_if vif;

    `uvm_component_utils(uart_driver)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual uart_if)::get(this,"","vif",vif))
            `uvm_fatal("DRV","VIF not found")
    endfunction

    task run_phase(uvm_phase phase);

        uart_txn tr;

        forever begin

            seq_item_port.get_next_item(tr);

            // WAIT until DUT free
            wait(vif.tx_busy == 0);

            // APPLY DATA
            vif.tx_data <= tr.data;

            // START PULSE
            vif.tx_start <= 1;
            @(posedge vif.clk);
            vif.tx_start <= 0;

            `uvm_info("DRV", $sformatf("Driving: %0h", tr.data), UVM_LOW)

            // WAIT for transmission finish
            wait(vif.tx_busy == 0);

            seq_item_port.item_done();

        end
    endtask

endclass