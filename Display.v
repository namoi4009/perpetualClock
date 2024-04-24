`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HCMUT
// Engineer: Ta Ngoc Nam - 2152788, Vu Nam Binh - 2152441, Ho Anh Dung - 2052921
// 
// Create Date: 08/16/2022 05:35:15 PM
// Design Name: Display Number
// Module Name: Display
// Project Name: Project 1 (Perpetual Clock)
// Target Devices: ARTY Z7
// Tool Versions: 2018.2
// Description: Display day/month/year or hour/minute/second
// 
// Dependencies: Perpetual_Clock
//               mfe_led7seg_74hc595_controller_wrapper
//               mfe_led7seg_74hc595_controller
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Display(
    input clk, rst, btn, sw0,
    output sclk, rclk, dio
    );

// Declaration
parameter   DIG_NUM       = 8;
parameter   SEG_NUM       = 8;
localparam  CHA_WIDTH     = DIG_NUM + SEG_NUM;
localparam  DAT_WIDTH     = SEG_NUM * DIG_NUM;
parameter   DIV_WIDTH     = 8;

parameter NUM_0 = 8'hC0, NUM_1 = 8'hF9, NUM_2 = 8'hA4, NUM_3 = 8'hB0, NUM_4 = 8'h99,
          NUM_5 = 8'h92, NUM_6 = 8'h82, NUM_7 = 8'hF8, NUM_8 = 8'h80, NUM_9 = 8'h90,
          NUM_A = 8'h8C, NUM_b = 8'hBF, NUM_C = 8'hC6, NUM_d = 8'hA1, NUM_E = 8'h86,
          NUM_F = 8'hFF, NUM_LINE = 8'hbf;
reg [DAT_WIDTH - 1 : 0] data;
wire                    vld;
reg clk_1hz = 0;
integer count = 1;

// Initialing value for hour, second and minute
wire [13:0]year;
wire [6:0]mon, day, hour, min, sec;

// Call Perpetual Clock
Perpetual_Clock clock(clk, rst, year, mon, day, hour, min, sec);

// Dividing clock frequency
always @(posedge clk) begin
    if (count == 62500000) begin
        clk_1hz = ~clk_1hz;
        count <= 1;
    end
    else count <= count + 1;
end

// Task: Display sec
reg [7:0]h1,h2,m1,m2,s1,s2;
task bcd1;
input [6:0]sec;
output [7:0]s1,s2;
case(sec)
    6'd0: begin s1<=NUM_0;s2<=NUM_0; end
    6'd1: begin s1<=NUM_0;s2<=NUM_1; end
    6'd2: begin s1<=NUM_0;s2<=NUM_2; end
    6'd3: begin s1<=NUM_0;s2<=NUM_3; end
    6'd4: begin s1<=NUM_0;s2<=NUM_4; end
    6'd5: begin s1<=NUM_0;s2<=NUM_5; end
    6'd6: begin s1<=NUM_0;s2<=NUM_6; end
    6'd7: begin s1<=NUM_0;s2<=NUM_7; end
    6'd8: begin s1<=NUM_0;s2<=NUM_8; end
    6'd9: begin s1<=NUM_0;s2<=NUM_9; end
    6'd10: begin s1<=NUM_1;s2<=NUM_0; end
    6'd11: begin s1<=NUM_1;s2<=NUM_1; end
    6'd12: begin s1<=NUM_1;s2<=NUM_2; end
    6'd13: begin s1<=NUM_1;s2<=NUM_3; end
    6'd14: begin s1<=NUM_1;s2<=NUM_4; end
    6'd15: begin s1<=NUM_1;s2<=NUM_5; end
    6'd16: begin s1<=NUM_1;s2<=NUM_6; end
    6'd17: begin s1<=NUM_1;s2<=NUM_7; end
    6'd18: begin s1<=NUM_1;s2<=NUM_8; end
    6'd19: begin s1<=NUM_1;s2<=NUM_9; end
    6'd20: begin s1<=NUM_2;s2<=NUM_0; end
    6'd21: begin s1<=NUM_2;s2<=NUM_1; end
    6'd22: begin s1<=NUM_2;s2<=NUM_2; end
    6'd23: begin s1<=NUM_2;s2<=NUM_3; end
    6'd24: begin s1<=NUM_2;s2<=NUM_4; end
    6'd25: begin s1<=NUM_2;s2<=NUM_5; end
    6'd26: begin s1<=NUM_2;s2<=NUM_6; end
    6'd27: begin s1<=NUM_2;s2<=NUM_7; end
    6'd28: begin s1<=NUM_2;s2<=NUM_8; end
    6'd29: begin s1<=NUM_2;s2<=NUM_9; end
    6'd30: begin s1<=NUM_3;s2<=NUM_0; end
    6'd31: begin s1<=NUM_3;s2<=NUM_1; end
    6'd32: begin s1<=NUM_3;s2<=NUM_2; end
    6'd33: begin s1<=NUM_3;s2<=NUM_3; end
    6'd34: begin s1<=NUM_3;s2<=NUM_4; end
    6'd35: begin s1<=NUM_3;s2<=NUM_5; end
    6'd36: begin s1<=NUM_3;s2<=NUM_6; end
    6'd37: begin s1<=NUM_3;s2<=NUM_7; end
    6'd38: begin s1<=NUM_3;s2<=NUM_8; end
    6'd39: begin s1<=NUM_3;s2<=NUM_9; end
    6'd40: begin s1<=NUM_4;s2<=NUM_0; end
    6'd41: begin s1<=NUM_4;s2<=NUM_1; end
    6'd42: begin s1<=NUM_4;s2<=NUM_2; end
    6'd43: begin s1<=NUM_4;s2<=NUM_3; end
    6'd44: begin s1<=NUM_4;s2<=NUM_4; end
    6'd45: begin s1<=NUM_4;s2<=NUM_5; end
    6'd46: begin s1<=NUM_4;s2<=NUM_6; end
    6'd47: begin s1<=NUM_4;s2<=NUM_7; end
    6'd48: begin s1<=NUM_4;s2<=NUM_8; end
    6'd49: begin s1<=NUM_4;s2<=NUM_9; end
    6'd50: begin s1<=NUM_5;s2<=NUM_0; end
    6'd51: begin s1<=NUM_5;s2<=NUM_1; end
    6'd52: begin s1<=NUM_5;s2<=NUM_2; end
    6'd53: begin s1<=NUM_5;s2<=NUM_3; end
    6'd54: begin s1<=NUM_5;s2<=NUM_4; end
    6'd55: begin s1<=NUM_5;s2<=NUM_5; end
    6'd56: begin s1<=NUM_5;s2<=NUM_6; end
    6'd57: begin s1<=NUM_5;s2<=NUM_7; end
    6'd58: begin s1<=NUM_5;s2<=NUM_8; end
    6'd59: begin s1<=NUM_5;s2<=NUM_9; end  
endcase
endtask

// Task: Display minute
task bcd2;
input [6:0]min;
output [7:0]m1,m2;
case(min)
    6'd0: begin m1<=NUM_0;m2<=NUM_0; end
    6'd1: begin m1<=NUM_0;m2<=NUM_1; end
    6'd2: begin m1<=NUM_0;m2<=NUM_2; end
    6'd3: begin m1<=NUM_0;m2<=NUM_3; end
    6'd4: begin m1<=NUM_0;m2<=NUM_4; end
    6'd5: begin m1<=NUM_0;m2<=NUM_5; end
    6'd6: begin m1<=NUM_0;m2<=NUM_6; end
    6'd7: begin m1<=NUM_0;m2<=NUM_7; end
    6'd8: begin m1<=NUM_0;m2<=NUM_8; end
    6'd9: begin m1<=NUM_0;m2<=NUM_9; end
    6'd10: begin m1<=NUM_1;m2<=NUM_0; end
    6'd11: begin m1<=NUM_1;m2<=NUM_1; end
    6'd12: begin m1<=NUM_1;m2<=NUM_2; end
    6'd13: begin m1<=NUM_1;m2<=NUM_3; end
    6'd14: begin m1<=NUM_1;m2<=NUM_4; end
    6'd15: begin m1<=NUM_1;m2<=NUM_5; end
    6'd16: begin m1<=NUM_1;m2<=NUM_6; end
    6'd17: begin m1<=NUM_1;m2<=NUM_7; end
    6'd18: begin m1<=NUM_1;m2<=NUM_8; end
    6'd19: begin m1<=NUM_1;m2<=NUM_9; end
    6'd20: begin m1<=NUM_2;m2<=NUM_0; end
    6'd21: begin m1<=NUM_2;m2<=NUM_1; end
    6'd22: begin m1<=NUM_2;m2<=NUM_2; end
    6'd23: begin m1<=NUM_2;m2<=NUM_3; end
    6'd24: begin m1<=NUM_2;m2<=NUM_4; end
    6'd25: begin m1<=NUM_2;m2<=NUM_5; end
    6'd26: begin m1<=NUM_2;m2<=NUM_6; end
    6'd27: begin m1<=NUM_2;m2<=NUM_7; end
    6'd28: begin m1<=NUM_2;m2<=NUM_8; end
    6'd29: begin m1<=NUM_2;m2<=NUM_9; end
    6'd30: begin m1<=NUM_3;m2<=NUM_0; end
    6'd31: begin m1<=NUM_3;m2<=NUM_1; end
    6'd32: begin m1<=NUM_3;m2<=NUM_2; end
    6'd33: begin m1<=NUM_3;m2<=NUM_3; end
    6'd34: begin m1<=NUM_3;m2<=NUM_4; end
    6'd35: begin m1<=NUM_3;m2<=NUM_5; end
    6'd36: begin m1<=NUM_3;m2<=NUM_6; end
    6'd37: begin m1<=NUM_3;m2<=NUM_7; end
    6'd38: begin m1<=NUM_3;m2<=NUM_8; end
    6'd39: begin m1<=NUM_3;m2<=NUM_9; end
    6'd40: begin m1<=NUM_4;m2<=NUM_0; end
    6'd41: begin m1<=NUM_4;m2<=NUM_1; end
    6'd42: begin m1<=NUM_4;m2<=NUM_2; end
    6'd43: begin m1<=NUM_4;m2<=NUM_3; end
    6'd44: begin m1<=NUM_4;m2<=NUM_4; end
    6'd45: begin m1<=NUM_4;m2<=NUM_5; end
    6'd46: begin m1<=NUM_4;m2<=NUM_6; end
    6'd47: begin m1<=NUM_4;m2<=NUM_7; end
    6'd48: begin m1<=NUM_4;m2<=NUM_8; end
    6'd49: begin m1<=NUM_4;m2<=NUM_9; end
    6'd50: begin m1<=NUM_5;m2<=NUM_0; end
    6'd51: begin m1<=NUM_5;m2<=NUM_1; end
    6'd52: begin m1<=NUM_5;m2<=NUM_2; end
    6'd53: begin m1<=NUM_5;m2<=NUM_3; end
    6'd54: begin m1<=NUM_5;m2<=NUM_4; end
    6'd55: begin m1<=NUM_5;m2<=NUM_5; end
    6'd56: begin m1<=NUM_5;m2<=NUM_6; end
    6'd57: begin m1<=NUM_5;m2<=NUM_7; end
    6'd58: begin m1<=NUM_5;m2<=NUM_8; end
    6'd59: begin m1<=NUM_5;m2<=NUM_9; end 
endcase
endtask

// Task: Display hour
task bcd3;
input [6:0]hour;
output [7:0]h1,h2;
case(hour)
6'd0: begin h1<=NUM_0;h2<=NUM_0; end
6'd1: begin h1<=NUM_0;h2<=NUM_1; end
6'd2: begin h1<=NUM_0;h2<=NUM_2; end
6'd3: begin h1<=NUM_0;h2<=NUM_3; end
6'd4: begin h1<=NUM_0;h2<=NUM_4; end
6'd5: begin h1<=NUM_0;h2<=NUM_5; end
6'd6: begin h1<=NUM_0;h2<=NUM_6; end
6'd7: begin h1<=NUM_0;h2<=NUM_7; end
6'd8: begin h1<=NUM_0;h2<=NUM_8; end
6'd9: begin h1<=NUM_0;h2<=NUM_9; end
6'd10: begin h1<=NUM_1;h2<=NUM_0; end
6'd11: begin h1<=NUM_1;h2<=NUM_1; end
6'd12: begin h1<=NUM_1;h2<=NUM_2; end
6'd13: begin h1<=NUM_1;h2<=NUM_3; end
6'd14: begin h1<=NUM_1;h2<=NUM_4; end
6'd15: begin h1<=NUM_1;h2<=NUM_5; end
6'd16: begin h1<=NUM_1;h2<=NUM_6; end
6'd17: begin h1<=NUM_1;h2<=NUM_7; end
6'd18: begin h1<=NUM_1;h2<=NUM_8; end
6'd19: begin h1<=NUM_1;h2<=NUM_9; end
6'd20: begin h1<=NUM_2;h2<=NUM_0; end
6'd21: begin h1<=NUM_2;h2<=NUM_1; end
6'd22: begin h1<=NUM_2;h2<=NUM_2; end
6'd23: begin h1<=NUM_2;h2<=NUM_3; end
endcase
endtask

// Set display-value for second, minute, hour every positive edge of clock
always @(posedge clk) begin
    bcd1(sec,s1,s2);
end
always @(posedge clk) begin
    bcd2(min,m1,m2);
end
always @(posedge clk) begin
    bcd3(hour,h1,h2);
end

// Initializing value for displaying day, month and year
reg [7:0]d1,d2,mon1,mon2;
reg [7:0]y1,y2,y3,y4;

// Task: Display day 
task bcd4; 
input [6:0]day;
output [7:0]d1,d2;
case(day)
    6'd1: begin d1<=NUM_0;d2<=NUM_1; end
    6'd2: begin d1<=NUM_0;d2<=NUM_2; end
    6'd3: begin d1<=NUM_0;d2<=NUM_3; end
    6'd4: begin d1<=NUM_0;d2<=NUM_4; end
    6'd5: begin d1<=NUM_0;d2<=NUM_5; end
    6'd6: begin d1<=NUM_0;d2<=NUM_6; end
    6'd7: begin d1<=NUM_0;d2<=NUM_7; end
    6'd8: begin d1<=NUM_0;d2<=NUM_8; end
    6'd9: begin d1<=NUM_0;d2<=NUM_9; end
    6'd10: begin d1<=NUM_1;d2<=NUM_0; end
    6'd11: begin d1<=NUM_1;d2<=NUM_1; end
    6'd12: begin d1<=NUM_1;d2<=NUM_2; end
    6'd13: begin d1<=NUM_1;d2<=NUM_3; end
    6'd14: begin d1<=NUM_1;d2<=NUM_4; end
    6'd15: begin d1<=NUM_1;d2<=NUM_5; end
    6'd16: begin d1<=NUM_1;d2<=NUM_6; end
    6'd17: begin d1<=NUM_1;d2<=NUM_7; end
    6'd18: begin d1<=NUM_1;d2<=NUM_8; end
    6'd19: begin d1<=NUM_1;d2<=NUM_9; end
    6'd20: begin d1<=NUM_2;d2<=NUM_0; end
    6'd21: begin d1<=NUM_2;d2<=NUM_1; end
    6'd22: begin d1<=NUM_2;d2<=NUM_2; end
    6'd23: begin d1<=NUM_2;d2<=NUM_3; end
    6'd24: begin d1<=NUM_2;d2<=NUM_4; end
    6'd25: begin d1<=NUM_2;d2<=NUM_5; end
    6'd26: begin d1<=NUM_2;d2<=NUM_6; end
    6'd27: begin d1<=NUM_2;d2<=NUM_7; end
    6'd28: begin d1<=NUM_2;d2<=NUM_8; end
    6'd29: begin d1<=NUM_2;d2<=NUM_9; end
    6'd30: begin d1<=NUM_3;d2<=NUM_0; end
    6'd31: begin d1<=NUM_3;d2<=NUM_1; end
endcase
endtask

// Task: Display month
task bcd5;
input [6:0]mon;
output [7:0]mon1,mon2;
case(mon)
    6'd1: begin mon1<=NUM_0;mon2<=NUM_1; end
    6'd2: begin mon1<=NUM_0;mon2<=NUM_2; end
    6'd3: begin mon1<=NUM_0;mon2<=NUM_3; end
    6'd4: begin mon1<=NUM_0;mon2<=NUM_4; end
    6'd5: begin mon1<=NUM_0;mon2<=NUM_5; end
    6'd6: begin mon1<=NUM_0;mon2<=NUM_6; end
    6'd7: begin mon1<=NUM_0;mon2<=NUM_7; end
    6'd8: begin mon1<=NUM_0;mon2<=NUM_8; end
    6'd9: begin mon1<=NUM_0;mon2<=NUM_9; end
    6'd10: begin mon1<=NUM_1;mon2<=NUM_0; end
    6'd11: begin mon1<=NUM_1;mon2<=NUM_1; end
    6'd12: begin mon1<=NUM_1;mon2<=NUM_2; end
endcase
endtask

// Task: Display year
task bcd6;
input [13:0]year;
output [7:0]y1,y2,y3,y4;
case(year)
    14'd2000: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_0;y4<=NUM_0; end
    14'd2001: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_0;y4<=NUM_1; end
    14'd2002: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_0;y4<=NUM_2; end
    14'd2003: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_0;y4<=NUM_3; end
    14'd2004: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_0;y4<=NUM_4; end
    14'd2005: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_0;y4<=NUM_5; end
    14'd2006: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_0;y4<=NUM_6; end
    14'd2007: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_0;y4<=NUM_7; end
    14'd2008: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_0;y4<=NUM_8; end
    14'd2009: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_0;y4<=NUM_9; end
    14'd2010: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_1;y4<=NUM_0; end
    14'd2011: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_1;y4<=NUM_1; end
    14'd2012: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_1;y4<=NUM_2; end
    14'd2013: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_1;y4<=NUM_3; end
    14'd2014: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_1;y4<=NUM_4; end
    14'd2015: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_1;y4<=NUM_5; end
    14'd2016: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_1;y4<=NUM_6; end
    14'd2017: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_1;y4<=NUM_7; end
    14'd2018: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_1;y4<=NUM_8; end
    14'd2019: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_1;y4<=NUM_9; end
    14'd2020: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_2;y4<=NUM_0; end
    14'd2021: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_2;y4<=NUM_1; end
    14'd2022: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_2;y4<=NUM_2; end
    14'd2023: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_2;y4<=NUM_3; end
    14'd2024: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_2;y4<=NUM_4; end
    14'd2025: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_2;y4<=NUM_5; end
    14'd2026: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_2;y4<=NUM_6; end
    14'd2027: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_2;y4<=NUM_7; end
    14'd2028: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_2;y4<=NUM_8; end
    14'd2029: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_2;y4<=NUM_9; end
    14'd2030: begin y1<=NUM_2;y2<=NUM_0;y3<=NUM_3;y4<=NUM_0; end
endcase
endtask

// Set display-value for day, month and year every positive edge of clock
always @(posedge clk) begin
    bcd4(day,d1,d2);
end
always @(posedge clk) begin
    bcd5(mon,mon1,mon2);
end
always @(posedge clk) begin
    bcd6(year,y1,y2,y3,y4);
end

// Mode display
reg                     btn_vld_p;
reg               [2:0] ff_btn;
reg                     sw0_vld_p;
reg               [2:0] ff_sw0;
reg                     mode;
reg                     state_mode;
integer                 delay = 1;

initial begin
    mode = 0;
    state_mode = 0;
end
always @(posedge clk) begin
    if (!sw0) begin
        if (btn_vld_p) begin
            state_mode <= 1;
            mode = ~mode;
        end
        else if (state_mode) begin
            if (delay == 625000000) begin
                state_mode <= 0;
                delay <= 1;
                mode = ~mode;
            end
            else delay = delay + 1;
        end
        else mode <= 0;
    end
    else mode <= 1;
end

always @(posedge clk) begin
    // Set for button
    ff_btn[0]   <= btn;
    ff_btn[2:1] <= ff_btn[1:0];
    btn_vld_p   <= ~ff_btn[2] & ff_btn[1];
end

// Display number 
parameter defaultLed=8'hFF;
always @(posedge clk_1hz) begin
    if (!mode) data <= {h1, h2, NUM_LINE, m1, m2, NUM_LINE, s1, s2};
    else data <= {d1, d2, mon1, mon2, y1, y2, y3, y4};
end

assign vld = 1;
        
//Call LED controller
mfe_led7seg_74hc595_controller_wrapper
    #(
    .DIG_NUM    (DIG_NUM),
    .SEG_NUM    (SEG_NUM),
    .DIV_WIDTH  (DIV_WIDTH)
    )
led7seg_ctrl_wrapper(
    .clk        (clk),
    .rst        (rst),
    .dat        (data),
    .vld        (vld),

    .sclk       (sclk),
    .rclk       (rclk),
    .dio        (dio)
    );

endmodule
