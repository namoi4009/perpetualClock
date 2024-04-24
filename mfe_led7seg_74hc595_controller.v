`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Computer Engineering Lab - CSE - HCMUT
// Engineer: Nguyen Xuan Quang
// 
// Create Date: 04/29/2022 11:24:37 PM
// Design Name: 7 segment LEDs with shift register IC 74HC595 Controller
// Module Name: mfe_led7seg_74hc595
// Project Name: Make FPGA Easier
// Target Devices: Arty-Z7/any
// Tool Versions: 2018.2/any
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mfe_led7seg_74hc595_controller (
    clk,
    rst,
    dat,
    vld,
    rdy,

    sclk,
    rclk,
    dio
    );

////////////////////////////////////////////////////////////////////////////////
// Parameters
parameter   DIG_NUM       = 8;                      // Number of digits
parameter   SEG_NUM       = 8;                      // Number of segments in a LED
localparam  DAT_WIDTH     = DIG_NUM + SEG_NUM;      // Data width to display a character at a position
parameter   DIV_WIDTH     = 8;                      // Scan freqency div factor from original clock

function integer clogb2;
   input [31:0] value;
   integer 	i;
   begin
      clogb2 = 0;
      for(i = 0; 2**i < value; i = i + 1)
	clogb2 = i + 1;
   end
endfunction

////////////////////////////////////////////////////////////////////////////////
// Ports delcaration
input                     clk;
input                     rst;
input [DAT_WIDTH - 1 : 0] dat;
input                     vld;
output                    rdy;

output                    sclk;
output                    rclk;
output                    dio;

////////////////////////////////////////////////////////////////////////////////
// Logic

reg [DAT_WIDTH - 1 : 0] dat_reg;
reg                     start;

reg [DIV_WIDTH - 1:0]   div_cnt=0;
reg                     sclk_reg=0;
wire                    sclk_enb;

localparam CNT_WIDTH = clogb2(DAT_WIDTH);
reg [CNT_WIDTH - 1 : 0] cnt;
reg                     rclk_enb;
wire                    stop;

assign stop = rclk & (div_cnt == 0);

// Cache data
always @(posedge clk) begin
    if (rst) begin
        dat_reg <= {DAT_WIDTH{1'b0}};
    end
    else if (vld) begin
        dat_reg <= dat;
    end
    else if (sclk_enb) begin
        dat_reg <= dat_reg << 1;
    end
end

// Start controll
always @(posedge clk) begin
    if (rst) begin
        start <= 1'b0;
    end
    else if (vld) begin
        start <= 1'b1;
    end
    else if (stop) begin
        start <= 1'b0;
    end
end

assign rdy = ~start;
assign dio = dat_reg[DAT_WIDTH - 1];

// Generate SCLK
always @(posedge clk) begin
    div_cnt <= div_cnt + 1'b1;
end

assign sclk_enb = (div_cnt == 'd1) & sclk_reg;

always @(posedge clk) begin
    if (start) begin
        if (div_cnt == 0) sclk_reg <= ~sclk_reg;
    end
end

assign sclk = sclk_reg & start;

// Generate RCLK
always @(posedge clk) begin
    if (rst) begin
        cnt <= {CNT_WIDTH{1'b0}};
    end
    else if (start & sclk_enb) begin
        cnt <= cnt + 1'b1;
    end
end

always @(posedge clk) begin
    if (rst) begin
        rclk_enb <= 1'b0;
    end
    if (vld) begin
        rclk_enb <= 1'b0;
    end
    else if (sclk_enb) begin
        rclk_enb <= 1'b1;
    end
end

assign rclk = (cnt == 'd0) & ~sclk & rclk_enb;

endmodule
