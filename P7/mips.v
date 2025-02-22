module mips(
    input clk,                    // 时钟信号
    input reset,                  // 同步复位信号
    input interrupt,              // 外部中断信号
    output [31:0] macroscopic_pc, // 宏观 PC

    output [31:0] i_inst_addr,    // IM 读取地址（取指 PC）
    input  [31:0] i_inst_rdata,   // IM 读取数据

    output [31:0] m_data_addr,    // DM 读写地址
    input  [31:0] m_data_rdata,   // DM 读取数据
    output [31:0] m_data_wdata,   // DM 待写入数据
    output [3 :0] m_data_byteen,  // DM 字节使能信号

    output [31:0] m_int_addr,     // 中断发生器待写入地址
    output [3 :0] m_int_byteen,   // 中断发生器字节使能信号

    output [31:0] m_inst_addr,    // M 级 PC

    output w_grf_we,              // GRF 写使能信号
    output [4 :0] w_grf_addr,     // GRF 待写入寄存器编号
    output [31:0] w_grf_wdata,    // GRF 待写入数据

    output [31:0] w_inst_addr     // W 级 PC
);

    wire [5:0] HWInt;
    wire [31:0] Timer0_Din,Timer0_Dout;
    wire [31:0] Timer1_Din,Timer1_Dout;
    wire Timer0_enable,Timer1_enable;
    wire Timer0_IRQ,Timer1_IRQ;
    wire [31:0] Timer0_address,Timer1_address;
    wire [31:0] temp_m_data_addr;
    wire [3:0] temp_m_data_byteen;
    wire [31:0] temp_m_data_rdata;
    wire [31:0] temp_m_data_wdata;

    CPU _cpu(
        .clk(clk),
        .reset(reset),
        .macroscopic_pc(macroscopic_pc),
        .hwint(HWInt),

        .i_inst_rdata(i_inst_rdata),
        .i_inst_addr(i_inst_addr),

        .m_data_rdata(temp_m_data_rdata),
        .m_data_addr(temp_m_data_addr),
        .m_data_wdata(temp_m_data_wdata),
        .m_data_byteen(temp_m_data_byteen),
        
        .m_inst_addr(m_inst_addr),
        .w_grf_we(w_grf_we),
        .w_grf_addr(w_grf_addr),
        .w_grf_wdata(w_grf_wdata),
        .w_inst_addr(w_inst_addr)
    );

    Bridge _bridge(
        .interrupt(interrupt),
        .HWInt(HWInt),

        .m_int_addr(m_int_addr),
        .m_int_byteen(m_int_byteen),
        .m_data_addr(m_data_addr),
        .m_data_wdata(m_data_wdata),
        .m_data_rdata(m_data_rdata),
        .m_data_byteen(m_data_byteen),

        .temp_m_data_addr(temp_m_data_addr),
        .temp_m_data_wdata(temp_m_data_wdata),
        .temp_m_data_rdata(temp_m_data_rdata),
        .temp_m_data_byteen(temp_m_data_byteen),

        .Timer0_address(Timer0_address),
        .Timer0_enable(Timer0_enable),
        .Timer0_Din(Timer0_Din),
        .Timer0_Dout(Timer0_Dout),
        .Timer0_IRQ(Timer0_IRQ),

        .Timer1_address(Timer1_address),
        .Timer1_enable(Timer1_enable),
        .Timer1_Din(Timer1_Din),
        .Timer1_Dout(Timer1_Dout),
        .Timer1_IRQ(Timer1_IRQ)
    );

    Timer0 _timer0(
        .clk(clk),
        .reset(reset),
        .Addr(Timer0_address[31:2]),
        .WE(Timer0_enable),
        .Din(Timer0_Din),
        .Dout(Timer0_Dout),
        .IRQ(Timer0_IRQ)
    );

    Timer1 _timer1(
        .clk(clk),
        .reset(reset),
        .Addr(Timer1_address[31:2]),
        .WE(Timer1_enable),
        .Din(Timer1_Din),
        .Dout(Timer1_Dout),
        .IRQ(Timer1_IRQ)
    );

endmodule