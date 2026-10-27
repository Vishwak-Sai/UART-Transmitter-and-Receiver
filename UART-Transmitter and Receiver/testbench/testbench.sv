module tb_top;

    import uvm_pkg::*;
    import uart_uvm_pkg::*;

    bit clk = 0;
    always #5 clk = ~clk;

    uart_if vif(clk);

    uart_top dut (
        .clk(clk),
        .rst_n(vif.rst_n),
        .baud_div(vif.baud_div),
        .tx_start(vif.tx_start),
        .tx_data(vif.tx_data),
        .tx_busy(vif.tx_busy),
        .tx(vif.tx),
        .rx(vif.rx),
        .rx_data(vif.rx_data),
        .rx_valid(vif.rx_valid),
        .parity_error(vif.parity_error),
        .framing_error(vif.framing_error)
    );

    assign vif.rx = vif.tx;

    initial begin
        $dumpfile("uart.vcd");
        $dumpvars(0, tb_top);
    end

    initial begin
        vif.rst_n = 0;
        vif.baud_div = 100;
        vif.tx_start = 0;

        repeat(5) @(posedge clk);
        vif.rst_n = 1;
    end

    initial begin
        uvm_config_db #(virtual uart_if)::set(null,"*","vif",vif);
        run_test("uart_test");
    end

endmodule