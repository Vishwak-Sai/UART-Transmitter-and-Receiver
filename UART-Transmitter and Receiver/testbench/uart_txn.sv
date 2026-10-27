class uart_txn extends uvm_sequence_item;

    rand bit [7:0] data;

    `uvm_object_utils(uart_txn)

    function new(string name="uart_txn");
        super.new(name);
    endfunction

endclass