module uart_top(

    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,

    output tx,
    output tx_done,

    output [7:0] rx_data,
    output rx_done
);

wire baud_tick;
wire tx_line;

baud_generator baud_inst
(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
);

uart_tx tx_inst
(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .tx_data(tx_data),

    .tx(tx_line),
    .tx_done(tx_done)
);

uart_rx rx_inst
(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),

    .rx(tx_line),

    .rx_data(rx_data),
    .rx_done(rx_done)
);

assign tx = tx_line;

endmodule