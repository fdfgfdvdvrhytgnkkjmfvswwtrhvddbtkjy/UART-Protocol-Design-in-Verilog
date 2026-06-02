module uart_rx(
    input clk,
    input rst,
    input baud_tick,
    input rx,

    output reg [7:0] rx_data,
    output reg rx_done
);

reg [1:0] state;
reg [3:0] bit_count;
reg [7:0] data_reg;

localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state     <= IDLE;
        bit_count <= 0;
        data_reg  <= 0;
        rx_data   <= 0;
        rx_done   <= 0;
    end
    else
    begin
        rx_done <= 0;

        if(baud_tick)
        begin
            case(state)

                IDLE:
                begin
                    if(rx == 1'b0)
                    begin
                        bit_count <= 0;
                        state <= START;
                    end
                end

                START:
                begin
                    state <= DATA;
                end

                DATA:
                begin
                    data_reg[bit_count] <= rx;

                    if(bit_count == 7)
                        state <= STOP;
                    else
                        bit_count <= bit_count + 1;
                end

                STOP:
                begin
                    if(rx == 1'b1)
                    begin
                        rx_data <= data_reg;
                        rx_done <= 1'b1;
                    end

                    state <= IDLE;
                end

            endcase
        end
    end
end

endmodule