module programCounter (
    input clk,
    input outputEnable,
    input jump,
    input countEnable,
    input [3:0] jumpAddr,

    output reg [3:0] addr
);

reg [3:0] countHold; //internal count register

always @ (posedge clk) begin
    if(countEnable == 1'b1) begin
        countHold <= countHold + 1;
    end

    if (jump == 1'b1) begin
        countHold <= jumpAddr;
    end
    
    if (outputEnable == 1'b1) begin
        addr <= countHold;
    end
    
end

endmodule
