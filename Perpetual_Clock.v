`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HCMUT
// Engineer: Ta Ngoc Nam - 2152788, Vu Nam Binh - 2152441, Ho Anh Dung - 2052921
// 
// Create Date: 08/11/2022 11:27:23 AM
// Design Name: Perpetual Digital Clock
// Module Name: Perpetual_Clock
// Project Name: Project 1 (Perpetual Clock)
// Target Devices: ARTY Z7
// Tool Versions: Vivado 2018.2
// Description: The Clock starts at 00:00:00 August 20th, 2022 and counts continuously like a normal clock.
// Dependencies: 
// 
// Revision: 
// Revision 0.01 - File Created
// 
//////////////////////////////////////////////////////////////////////////////////


module Perpetual_Clock(
    input clk, rst,
    output reg [13:0]year,
    output reg [6:0]mon, day, hour, min, sec
    );

integer count = 1;
reg clk_1hz = 0;
reg leapYear = 0;

// Deviding clock frequency
always @(posedge clk) begin
    if (count == 62500000)
    begin
        clk_1hz <= ~clk_1hz;
        count <= 1;
    end
    else count <= count + 1;
end

// Counting second, minute, hour
reg [6:0]maxDay;
always @(posedge clk_1hz or posedge rst) begin
    if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0)
        leapYear <= 1;
    else leapYear <= 0;
    if (mon == 6'd1 || mon == 6'd3 || mon == 6'd5 || mon == 6'd7 || mon == 6'd8 || mon == 6'd10 || mon == 6'd12)
        maxDay <= 6'd31;
    else if (mon == 2 && leapYear)
        maxDay <= 6'd29;
    else if (mon == 2 && !leapYear)
        maxDay <= 6'd28;
    else maxDay <= 6'd30;
    
    // Set initial day
    if (rst) begin  
        year <= 14'd2024;
        mon <= 6'd1;
        day <= 6'd31;
        hour <= 6'd23;
        min <= 6'd59;
        sec <= 6'd55;
    end
    
    // Check the increasement of year, month, day, hour, minute, second
    else begin
        if (sec != 6'd59)
            sec <= sec + 1;
        else begin
            sec <= 6'd0;
            if (min != 6'd59)
                min <= min + 1;
            else begin
                min <= 6'd0;
                if (hour != 6'd23)
                    hour <= hour + 1;
                else begin
                    hour <= 6'd0;
                    if (day != maxDay)
                        day = day + 1;
                    else begin
                        day <= 1;
                        if (mon != 12)
                            mon = mon + 1;
                        else begin
                            mon <= 1;
                            year <= year + 1;
                        end
                    end
                end
            end
        end
    end
end
endmodule