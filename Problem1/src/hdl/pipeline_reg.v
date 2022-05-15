`include "def.v"

module pipeline_reg(
    input clk_i,
    input rst_ni,
    input bram1_web_i,
    input [`ADDR_WIDTH-1:0]    bram1_w_addr_i,
    input [`ALUMODE_WIDTH-1:0] alumode_i,
    input [`OPMODE_WIDTH-1:0]  opmode_i,
    input [`INMODE_WIDTH-1:0]  inmode_i,
    output reg bram1_web_o,
    output reg [`ADDR_WIDTH-1:0]    bram1_w_addr_o,
    output reg [`ALUMODE_WIDTH-1:0] alumode_o,
    output reg [`OPMODE_WIDTH-1:0]  opmode_o,
    output reg [`INMODE_WIDTH-1:0]  inmode_o
);

    reg bram1_web_reg [1:0];
    reg [`ADDR_WIDTH-1:0] bram1_w_addr_reg [1:0];
    reg [`ALUMODE_WIDTH-1:0] alumode_reg;
    reg [`OPMODE_WIDTH-1:0]  opmode_reg;

    always @(posedge clk_i or negedge rst_ni) begin
        if (rst_ni == 1'b0) begin
            bram1_web_o         <= 1'b0
            bram1_w_addr_o      <= 5'b0;
            alumode_o           <= 4'b0;
            opmode_o            <= 7'b0;
            inmode_o            <= 5'b0;
            bram1_web_reg[0]    <= 1'b0;
            bram1_web_reg[1]    <= 1'b0;
            bram1_w_addr_reg[0] <= 5'b0;
            bram1_w_addr_reg[1] <= 5'b0;
            alumode_reg         <= 4'b0;
            opmode_reg          <= 7'b0;
        end
        else begin
            bram1_web_o         <= bram1_web_reg[1];
            bram1_web_reg[1]    <= bram1_web_reg[0];
            bram1_web_reg[0]    <= bram1_web_i;
            bram1_w_addr_o      <= bram1_w_addr_reg[1];
            bram1_w_addr_reg[1] <= bram1_w_addr_reg[0];
            bram1_w_addr_reg[0] <= bram1_w_addr_i;
            alumode_o           <= alumode_reg;
            alumode_reg         <= alumode_i;
            opmode_o            <= opmode_reg;
            opmode_reg          <= opmode_i;
            inmode_o            <= inmode_i;
        end    
    end

endmodule