`include "def.v"

module controller(
    input clk_i,
    input rst_ni,
    input start_i,   
    input [`I_WIDTH-1:0] instruction_i,
    output reg valid_o,   
    output reg bram1_web_o,
    output reg bram1_reb_o,
    output reg bram0_reb_o,
    output reg [`ALUMODE_WIDTH-1:0] alumode_o,
    output reg [`OPMODE_WIDTH-1:0]  opmode_o,
    output reg [`INMODE_WIDTH-1:0]  inmode_o,
    output reg [`ADDR_WIDTH-1:0]    bram1_w_addr_o,
    output reg [`ADDR_WIDTH-1:0]    bram1_r_addr_o,
    output reg [`ADDR_WIDTH-1:0]    bram0_r_addr_o   
);

    parameter IDLE    = 2'd0,
              DECODE  = 2'd1,
              EXECUTE = 2'd2,
              DONE    = 2'd3;

    reg [1:0] c_state;
    reg [1:0] n_state;
    reg [1:0] counter;

    always @(posedge clk_i or negedge rst_ni) begin
        if (rst_ni == 1'b0) begin
            c_state        <= IDLE;
            counter        <= 2'd0;
            bram1_web_o    <= 1'b0;
            bram1_reb_o    <= 1'b0;
            bram0_reb_o    <= 1'b0;
            alumode_o      <= 4'b0;
            opmode_o       <= 7'b0;
            inmode_o       <= 5'b0;
            bram1_w_addr_o <= 5'b0;
            bram1_r_addr_o <= 5'b0;
            bram0_r_addr_o <= 5'b0;
        end
        else begin
            c_state <= n_state;
            case (c_state)
                IDLE: begin 
                    counter <= 2'd0;
                end                   
                DECODE: begin
                    bram1_web_o    <= instruction_i[`EXEC];
                    bram1_reb_o    <= instruction_i[`EXEC];
                    bram0_reb_o    <= instruction_i[`EXEC];
                    alumode_o      <= instruction_i[`ALUMODE];
                    opmode_o       <= instruction_i[`OPMODE];
                    inmode_o       <= instruction_i[`INMODE];
                    bram1_w_addr_o <= instruction_i[`BRAM1_W_ADDR];
                    bram1_r_addr_o <= instruction_i[`BRAM1_R_ADDR];
                    bram0_r_addr_o <= instruction_i[`BRAM0_R_ADDR];
                end
                EXECUTE: begin
                    counter     <= counter + 2'd1;
                    bram1_web_o <= 1'b0; // prevent from writing dirty data
                end
            endcase
        end
    end

    always @(*) begin
        case (c_state)
            IDLE: begin
                n_state = (start_i == 1'b1) ? DECODE : IDLE;
                valid_o = 1'b0;
            end
            DECODE: begin
                n_state = EXECUTE;
                valid_o = 1'b0;
            end
            EXECUTE: begin
                n_state = (counter == 2'd2) ? DONE : EXECUTE; // instruction needs 3 cycles to do.
                valid_o = 1'b0;
            end
            DONE: begin
                n_state = (start_i == 1'b0) ? IDLE : DONE;
                valid_o = 1'b1; // valid until start_i is 0.
            end
        endcase
    end

endmodule