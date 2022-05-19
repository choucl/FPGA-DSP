`include "def.v"

module pipeline_reg(
    input clk_i,
    input rst_ni,
    input bram1_web_i,
    input [`ADDR_WIDTH-1:0]    bram1_w_addr_i,
    output reg bram1_web_o,
    output reg [`ADDR_WIDTH-1:0]    bram1_w_addr_o
);

    reg bram1_web_reg [2:0];
    reg [`ADDR_WIDTH-1:0] bram1_w_addr_reg [2:0];

    always @(posedge clk_i or negedge rst_ni) begin
        if (rst_ni == 1'b0) begin
            bram1_web_o         <= 1'b0;
            bram1_w_addr_o      <= 5'b0;
            bram1_web_reg[0]    <= 1'b0;
            bram1_web_reg[1]    <= 1'b0;
            bram1_web_reg[2]    <= 1'b0;
            bram1_w_addr_reg[0] <= 5'b0;
            bram1_w_addr_reg[1] <= 5'b0;
            bram1_w_addr_reg[2] <= 5'b0;
        end
        else begin
            bram1_web_o         <= bram1_web_reg[2];
            bram1_web_reg[2]    <= bram1_web_reg[1];
            bram1_web_reg[1]    <= bram1_web_reg[0];
            bram1_web_reg[0]    <= bram1_web_i;
            bram1_w_addr_o      <= bram1_w_addr_reg[2];
            bram1_w_addr_reg[2] <= bram1_w_addr_reg[1];
            bram1_w_addr_reg[1] <= bram1_w_addr_reg[0];
            bram1_w_addr_reg[0] <= bram1_w_addr_i;
        end    
    end

endmodule