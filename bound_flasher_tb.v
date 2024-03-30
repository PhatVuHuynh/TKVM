`timescale 1ns / 1ps

module bound_flasher_tb;

    reg flick, rst, clk;
    // reg rst;
    // reg clk;
    // wire [4:0] id;
    wire [15:0]led;

    bound_flasher uut(flick, rst, clk, led);
    
    initial begin
        // $monitor("At time %t : flick = %b - rst = %b - clk = %b - id = %d - led = %d ", $time, flick, rst, clk, id, led);
        $monitor("At time %t : flick = %b - rst = %b - clk = %b - led = %d ", $time, flick, rst, clk, led);
    end

    always begin
        #1 clk <= ~clk;
    end

    initial begin
    clk <= 0;
    flick <= 0;
    rst <= 0;
    #1
    flick <= 1;
    #1
    flick <= 0;
    #55
    flick <= 1;
    #1
    flick <= 0;
    #77
    flick <= 1;
    #1
    flick <= 0;
    #100
    rst <= 1;
    #1
    rst <= 0;
    #1
    flick <= 1;
    #1
    flick <= 0;
    #140 $finish;
    end

    initial begin
    $recordfile ("wave");
    $recordvars ("depth=0", bound_flasher_tb);
    end
    
endmodule
