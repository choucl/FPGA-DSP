`include "def.v"

module controller(
    input [`I_WIDTH-1:0] instruction_i,   
    output bram1_web_o,
    output bram1_reb_o,
    output bram0_reb_o,
    output [`ALUMODE_WIDTH-1:0] alumode_o,
    output [`OPMODE_WIDTH-1:0]  opmode_o,
    output [`INMODE_WIDTH-1:0]  inmode_o,
    output [`ADDR_WIDTH-1:0]    bram1_w_addr_o,
    output [`ADDR_WIDTH-1:0]    bram1_r_addr_o,
    output [`ADDR_WIDTH-1:0]    bram0_r_addr_o   
);

    assign bram1_web_o    = instruction_i[`EXEC];
    assign bram1_reb_o    = instruction_i[`EXEC];
    assign bram0_reb_o    = instruction_i[`EXEC];
    assign alumode_o      = instruction_i[`ALUMODE];
    assign opmode_o       = instruction_i[`OPMODE];
    assign inmode_o       = instruction_i[`INMODE];
    assign bram1_w_addr_o = instruction_i[`BRAM1_W_ADDR];
    assign bram1_r_addr_o = instruction_i[`BRAM1_R_ADDR];
    assign bram0_r_addr_o = instruction_i[`BRAM0_R_ADDR];

endmodule