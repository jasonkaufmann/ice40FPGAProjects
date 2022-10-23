
/*This is a clock with a halt signal, depending on the mode
we will use the internal clock or an external pushbutton clock */

module clock (
    input clockChooser,
    input pushButttonClock,
    input fastClk, //this clock is 12MHz
    input halt, 
    output reg clk );

/*the slow clock should go every second
and once enter cycle is two transitions so LOW --> HIGH --> LOW */
localparam maxCount = 6000000; 

//debouce for 1ms, should be long enough
localparam maxDebounceCount = 12000;

//state variable for the state machine
reg state = 1'b0;

//counters
reg [15:0] debounceCount = 0;
reg [31:0] count = 0;

//internal clocks
reg slowClk = 0;
reg pressClk = 0;

always @(posedge fastClk) begin
    count <= count + 1; //increment the counter
    debounceCount <= debounceCount + 1;
    if (count == maxCount) begin
        slowClk <= ~slowClk; //toggle the clock
        count <= 0; //reset the coutner
    end
    clk <= (clockChooser ? slowClk : pressClk) & !halt;
end

always @(posedge pushButttonClock) begin
    case (state)
        1'b0: begin
            state <= 1'b1;
            debounceCount <= 0;
        end
        1'b1: begin
            if(debounceCount == maxDebounceCount) begin
                state <= 1'b0;
                pressClk <= ~pressClk;
            end
        end
    endcase
    clk <= (clockChooser ? slowClk : pressClk) & !halt;
end

/* if clockChooser is LOW, then use the internal slowClock but if it's HIGH then use the pushbutton lock
but if the halt signal is 1 then stop the clock. */
//clk = (clockChooser ? slowClk : pressClk) & !halt;

endmodule