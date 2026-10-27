class uart_basic_seq extends uvm_sequence #(uart_txn);

    `uvm_object_utils(uart_basic_seq)

    function new(string name="uart_basic_seq");
        super.new(name);
    endfunction

    task body();

        uart_txn tr;

        repeat (10) begin
            tr = uart_txn::type_id::create("tr");

            //  FORCE DATA (NO RANDOM CONFUSION)
            tr.data = 8'hA5;

            start_item(tr);
            finish_item(tr);

            `uvm_info("SEQ", $sformatf("Sent: %0h", tr.data), UVM_LOW)

            #200; // spacing between frames
        end

    endtask

endclass