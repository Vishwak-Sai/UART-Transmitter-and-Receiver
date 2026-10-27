package uart_uvm_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "uart_txn.sv"
    `include "uart_basic_seq.sv"
    `include "uart_sequencer.sv"
    `include "uart_driver.sv"
    `include "uart_monitor.sv"
    `include "uart_scoreboard.sv"
    `include "uart_agent.sv"
    `include "uart_env.sv"
    `include "uart_test.sv"

endpackage


// ================= UART TX =================
module uart_tx (
    input  logic clk,
    input  logic rst_n,
    input  logic [15:0] baud_div,
    input  logic tx_start,
    input  logic [7:0] tx_data,

    output logic tx,
    output logic tx_busy
);

    logic [3:0] bit_cnt;
    logic [15:0] baud_cnt;
    logic [10:0] shift_reg;
    logic parity;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx <= 1;
            tx_busy <= 0;
            baud_cnt <= 0;
            bit_cnt <= 0;
        end else begin

            if (tx_start && !tx_busy) begin
                parity = ^tx_data;
                shift_reg <= {1'b1, parity, tx_data, 1'b0};

                tx_busy <= 1;
                baud_cnt <= 0;
                bit_cnt <= 0;
            end

            else if (tx_busy) begin
                if (baud_cnt == baud_div) begin
                    baud_cnt <= 0;
                    tx <= shift_reg[0];
                    shift_reg <= shift_reg >> 1;
                    bit_cnt++;

                    if (bit_cnt == 10) begin
                        tx_busy <= 0;
                        tx <= 1;
                    end
                end else baud_cnt++;
            end
        end
    end
endmodule


// ================= UART RX =================
module uart_rx (
    input  logic clk,
    input  logic rst_n,
    input  logic [15:0] baud_div,
    input  logic rx,

    output logic [7:0] rx_data,
    output logic rx_valid,
    output logic parity_error,
    output logic framing_error
);

    logic [3:0] bit_cnt;
    logic [15:0] baud_cnt;
    logic [7:0] data_reg;
    logic busy;
    logic parity_calc;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            busy <= 0;
            rx_valid <= 0;
            parity_error <= 0;
            framing_error <= 0;
            baud_cnt <= 0;
            bit_cnt <= 0;
            data_reg <= 0;
            parity_calc <= 0;
        end else begin

            rx_valid <= 0;
            parity_error <= 0;
            framing_error <= 0;

            if (!busy && rx == 0) begin
                busy <= 1;
                baud_cnt <= baud_div/2;
                bit_cnt <= 0;
                parity_calc <= 0;
            end

            else if (busy) begin
                if (baud_cnt == 0) begin
                    baud_cnt <= baud_div;

                    if (bit_cnt < 8) begin
                        data_reg[bit_cnt] <= rx;
                        parity_calc <= parity_calc ^ rx;
                        bit_cnt++;
                    end
                    else if (bit_cnt == 8) begin
                        if (parity_calc != rx)
                            parity_error <= 1;
                        bit_cnt++;
                    end
                    else begin
                        if (rx != 1)
                            framing_error <= 1;

                        rx_data <= data_reg;
                        rx_valid <= 1;
                        busy <= 0;
                    end

                end else baud_cnt--;
            end
        end
    end
endmodule


// ================= TOP =================
module uart_top (
    input  logic clk,
    input  logic rst_n,
    input  logic [15:0] baud_div,

    input  logic tx_start,
    input  logic [7:0] tx_data,

    output logic tx_busy,
    output logic tx,

    input  logic rx,

    output logic [7:0] rx_data,
    output logic rx_valid,
    output logic parity_error,
    output logic framing_error
);

    uart_tx tx_u (.*);
    uart_rx rx_u (.*);

endmodule


// ================= INTERFACE =================
interface uart_if(input bit clk);

    logic rst_n;

    logic tx_start;
    logic [7:0] tx_data;
    logic tx_busy;
    logic tx;

    logic rx;
    logic [7:0] rx_data;
    logic rx_valid;

    logic parity_error;
    logic framing_error;

    logic [15:0] baud_div;

endinterface