module mux5(
    input sel_i,
    input [4:0] w_addr_i,
    input [4:0] r_addr_i,
    output [4:0] addr_o
);

    assign addr_o = (sel_i == 1'b1) ? w_addr_i : r_addr_i;

endmodule