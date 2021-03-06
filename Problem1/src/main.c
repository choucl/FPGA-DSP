#include <stdio.h>
#include "xil_printf.h"
#include "xil_io.h"
#include "xparameters.h"

u32 get_cmd(
        u32 bram0_r_addr,
        u32 bram1_r_addr,
        u32 bram1_w_addr,
        u32 inmode,
        u32 opmode,
        u32 alumode)
{
    u32 cmd = bram0_r_addr;
    cmd += bram1_r_addr << 5;
    cmd += bram1_w_addr << 10;
    cmd += inmode << 15;
    cmd += opmode << 20;
    cmd += alumode << 27;
    cmd += 1 << 31;
    return cmd;
}

void execute(u32 cmd) {
    Xil_Out32(XPAR_AXI_GPIO_0_BASEADDR, cmd);
    Xil_Out32(XPAR_AXI_GPIO_1_BASEADDR, 1);  // START
    while (!Xil_In32(XPAR_AXI_GPIO_2_BASEADDR));  // wait for valid
    Xil_Out32(XPAR_AXI_GPIO_1_BASEADDR, 0);  // CLEAR
    return;
}

int main() {

    // BRAM[3] <= BRAM0[0] * BRAM1[2]
    execute(get_cmd(0, 2, 3, 0b10001, 0b0000101, 0b0000));

    // BRAM[7] <= BRAM0[11] * BRAM1[3]
    execute(get_cmd(11, 3, 7, 0b10001, 0b0000101, 0b0000));

    // BRAM[10] <= BRAM0[31] * BRAM1[7] + C
    execute(get_cmd(31, 7, 10, 0b10001, 0b0110101, 0b0000));

    // BRAM[13] <= C - BRAM0[1] * BRAM1[6]
    execute(get_cmd(1, 6, 13, 0b10001, 0b0110101, 0b0011));

    // BRAM[15] <= BRAM0[0] * BRAM1[31] - C - 1
    execute(get_cmd(0, 31, 15, 0b10001, 0b0110101, 0b0001));

    printf("--------------------------------------------\n");
    for (int i = 0; i < 32; ++i) {
        u32 bram_read;
        bram_read = Xil_In32(XPAR_AXI_BRAM_CTRL_1_S_AXI_BASEADDR + i * 4);
        printf("BRAM1[%d] = 0x%x\n", i, bram_read);
    }

    for (int i = 0; i < 32; ++i) {
        Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + i * 4, (i + 1) * (i + 1));
    }

    // BRAM[16] <= BRAM0[0] * BRAM1[2]
    execute(get_cmd(0, 2, 16, 0b10001, 0b0000101, 0b0000));

    // BRAM[17] <= BRAM0[11] * BRAM1[3]
    execute(get_cmd(11, 3, 17, 0b10001, 0b0000101, 0b0000));

    // BRAM[18] <= BRAM0[31] * BRAM1[7] + C
    execute(get_cmd(31, 7, 18, 0b10001, 0b0110101, 0b0000));

    // BRAM[19] <= C - BRAM0[1] * BRAM1[6]
    execute(get_cmd(1, 6, 19, 0b10001, 0b0110101, 0b0011));

    // BRAM[20] <= BRAM0[0] * BRAM1[31] - C - 1
    execute(get_cmd(0, 31, 20, 0b10001, 0b0110101, 0b0001));

    printf("--------------------------------------------\n");
    for (int i = 0; i < 32; ++i) {
        u32 bram_read;
        bram_read = Xil_In32(XPAR_AXI_BRAM_CTRL_1_S_AXI_BASEADDR + i * 4);
        printf("BRAM1[%d] = 0x%x\n", i, bram_read);
    }
    return 0;
}
