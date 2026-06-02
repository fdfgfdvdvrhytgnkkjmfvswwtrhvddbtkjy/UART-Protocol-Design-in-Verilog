module uart_tx(
    input clk,
    input rst,
    input baud_tick,
    input tx_start,
    input [7:0] tx_data,

    output reg tx,
    output reg tx_done
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
        tx        <= 1'b1;
        tx_done   <= 1'b0;
        bit_count <= 0;
        data_reg  <= 0;
    end
    else
    begin
        tx_done <= 0;

        if(baud_tick)
        begin
            case(state)

                IDLE:
                begin
                    tx <= 1'b1;

                    if(tx_start)
                    begin
                        data_reg  <= tx_data;
                        bit_count <= 0;
                        state     <= START;
                    end
                end

                START:
                begin
                    tx    <= 1'b0;
                    state <= DATA;
                end

                DATA:
                begin
                    tx <= data_reg[0];

                    data_reg <= data_reg >> 1;

                    if(bit_count == 7)
                        state <= STOP;
                    else
                        bit_count <= bit_count + 1;
                end

                STOP:
                begin
                    tx      <= 1'b1;
                    tx_done <= 1'b1;
                    state   <= IDLE;
                end

            endcase
        end
    end
end

endmodule