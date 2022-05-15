module mux12(
    input sel_i,
    input [11:0] w_addr_i,
    input [11:0] r_addr_i,
    output [11:0] addr_o
);

    assign addr_o = (sel_i == 1'b1) ? w_addr_i : r_addr_i;

endmodule