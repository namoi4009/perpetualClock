`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Computer Engineering Lab - CSE - HCMUT
// Engineer: Nguyen Xuan Quang
// 
// Create Date: 04/30/2022 11:39:55 AM
// Design Name: 7 segment LEDs with shift register IC 74HC595 Wrapper
// Module Name: mfe_led7seg_74hc595_controller_wrapper
// Project Name: Make FPGA Easier
// Target Devices: Arty-Z7/any
// Tool Versions: 2018.2/any
// Description: Display 8 characters of input to 8 7-seg LEDs automatically
// 
// Dependencies: mfe_led7seg_74hc595_controller.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mfe_led7seg_74hc595_controller_wrapper (
    clk,
    rst,
    dat,
    vld,

    sclk,
    rclk,
    dio
    );

////////////////////////////////////////////////////////////////////////////////
// Parameters
parameter   DIG_NUM       = 8;                      // Number of digits
parameter   SEG_NUM       = 8;                      // Number of segments in a LED
localparam  CHA_WIDTH     = DIG_NUM + SEG_NUM;      // Data width to display a character at a position
localparam  DAT_WIDTH     = SEG_NUM * DIG_NUM;      // Data width of all character (without positions)
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

output                    sclk;
output                    rclk;
output                    dio;

////////////////////////////////////////////////////////////////////////////////
// Logic
reg  [DAT_WIDTH - 1 : 0] dat_reg;
wire [CHA_WIDTH - 1 : 0] char_pos [DIG_NUM - 1 : 0];

// Cache data
always @(posedge clk) begin
    if (rst) begin
        dat_reg <= {DAT_WIDTH{1'b0}};
    end
    else if (vld) begin
        dat_reg <= dat;
    end
end

genvar i;
generate
    for (i = 0; i < DIG_NUM; i = i + 1) begin
        assign char_pos[i] = dat_reg[SEG_NUM * (i + 1) - 1 : SEG_NUM * i];
    end
endgenerate

// Send each charecter in data to controller
localparam CNT_WIDTH = clogb2(DIG_NUM);
reg [CHA_WIDTH - 1 : 0] char;
reg [CNT_WIDTH - 1 : 0] cnt;
reg [  DIG_NUM - 1 : 0] pos;
wire                    char_vld;
wire                    ready;

assign char_vld = ready;

always @(posedge clk) begin
    if (rst) cnt <= 0;
    else if (char_vld) begin
        cnt <= cnt + 1'b1; 
    end
end

// Cal position codes
always @(posedge clk) begin
    if (rst) begin
        pos  <= {{{DIG_NUM - 1}{1'b0}}, 1'b1};
    end
    else if (char_vld) begin
        pos  <= {pos[DIG_NUM - 2 : 0], pos[DIG_NUM - 1]};
    end
end

// Cal char code
always @(posedge clk) begin
    if (rst) begin
        char <= {CHA_WIDTH{1'b0}};
    end
    else begin
        char <= {char_pos[cnt], pos};
    end
end

// Controller
mfe_led7seg_74hc595_controller
    #(
    .DIG_NUM    (DIG_NUM),
    .SEG_NUM    (SEG_NUM),
    .DIV_WIDTH  (DIV_WIDTH)
    )
led7seg_74hc595_ctrl
    (
    .clk        (clk),
    .rst        (rst),
    .dat        (char),
    .vld        (char_vld),
    .rdy        (ready),

    .sclk       (sclk),
    .rclk       (rclk),
    .dio        (dio)
    );

endmodule
