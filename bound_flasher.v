//VU HUYNH TAN PHAT
// 2114391
//FINAL UPDATE: 18/03/2024

module bound_flasher (
    input flick, rst, clk,
    output reg [15:0]led
);
    parameter ALL_LEDs_OFF = 0;
    parameter LED0_TO_LED15_ON = 16;
    parameter LED15_TO_LED5_OFF = 5;
    parameter LED5_TO_LED10_ON = 11;
    // parameter LED10_TO_LED0_OFF = 0; 
    parameter LED0_TO_LED5_ON = 6;
    parameter INIT = 17;


reg[4:0] id = 0;        // CURRENT LED
reg[4:0] state = INIT;  // CURRENT STATE
reg isBoundUp = 0;      // DETERMINE ID UP/DOWN
reg start = 1;          // PRESENT FOR STATE ALL_LEDs_OFF. 
                        // BECAUSE ALL_LEDs_OFF AND LED10_TO_LED0_OFF ARE DUPLICATED DEFINED VALUE, NEED A FLAG

always @(posedge clk) begin
    if (rst == 1'b1) begin      // WHEN RESET = 1, STATE = INIT
        id = 0;
        assign led = id < 17 ? 2**id -1 : 0;    
        state = INIT;
        start = 1;
        isBoundUp = 0;
    end

    if(state == INIT) begin
        if(flick == 1) begin        // START
            state = ALL_LEDs_OFF;
        end
            
    end
    else begin
        if(id == state) begin       //CHANGE TO NEXT STATE
            if(start == 0 && flick == 1 && !isBoundUp) begin // KICKPOINT. GOING TO START POINT OF CURRENT STATE IS SIMILAR TO
                                                                        // GOING TO PREVIOUS STATE
                isBoundUp = 1;
                case (state)
                    LED15_TO_LED5_OFF: begin
                        state = LED0_TO_LED15_ON; 
                    end
                    ALL_LEDs_OFF: begin
                        state = LED5_TO_LED10_ON;
                    end
                endcase
            end
            else begin
                isBoundUp = !isBoundUp;
                case (state) 
                    ALL_LEDs_OFF: begin
                        if(start == 1) begin
                            state = LED0_TO_LED15_ON;
                            start = 0;
                        end
                        else begin
                            state = LED0_TO_LED5_ON;
                        end
                    end
                    LED0_TO_LED15_ON: begin     // LED 0 -> LED 15 IS ON
                        state = LED15_TO_LED5_OFF;
                    end
                    LED15_TO_LED5_OFF: begin    // LED 15 -> LED 5 IS OFF
                        state = LED5_TO_LED10_ON;
                    end
                    LED5_TO_LED10_ON: begin     // LED 5 -> LED 10 IS ON
                        state = ALL_LEDs_OFF;
                    end
                    // LED10_TO_LED0_OFF: begin
                    //     state = LED0_TO_LED5_ON;
                    // end
                    LED0_TO_LED5_ON: begin      // LED 0 -> LED 5 IS ON
                        isBoundUp = 0;
                        start = 1;              // NEW LOOP
                        state = ALL_LEDs_OFF;
                    end
                endcase    
            end
            
            
        end 

        if(isBoundUp && id < state) begin // DETERMINE NEXT LED
            id = id + 1;
        end
        else if(id != 0) begin
            id = id - 1;
        end 

        
    end
    led = id < 17 ? 2**id -1 : 0;    // TURN ON/OFF LED
end
    
endmodule
