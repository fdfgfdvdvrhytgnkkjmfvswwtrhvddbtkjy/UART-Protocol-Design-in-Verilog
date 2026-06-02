`timescale 1ns/1ps

module uart_tb;

reg clk;
reg rst;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire tx_done;
wire [7:0] rx_data;
wire rx_done;

uart_top DUT
(
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),

    .tx(tx),
    .tx_done(tx_done),

    .rx_data(rx_data),
    .rx_done(rx_done)
);

always #10 clk = ~clk;

initial
begin
    clk = 0;
    rst = 1;
    tx_start = 0;
    tx_data = 8'h00;

    #100;

    rst = 0;

    #100;

    tx_data = 8'hA5;
    tx_start = 1;

    #20;

    tx_start = 0;

    wait(rx_done);

    #1000;

    tx_data = 8'h3C;
    tx_start = 1;

    #20;

    tx_start = 0;

    wait(rx_done);

    #2000;

    $stop;
end

endmodule