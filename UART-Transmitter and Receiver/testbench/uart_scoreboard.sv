class uart_scoreboard extends uvm_component;

    uvm_analysis_imp #(uart_txn, uart_scoreboard) analysis_imp;

    `uvm_component_utils(uart_scoreboard)

    function new(string name, uvm_component parent);
        super.new(name,parent);
        analysis_imp = new("analysis_imp",this);
    endfunction

    function void write(uart_txn tr);
        `uvm_info("SB",$sformatf("DATA VERIFIED = %0h",tr.data),UVM_LOW)
    endfunction

endclass