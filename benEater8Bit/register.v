//This is an n- bit register with load, output enable, and asynchronous clear signals

module register #(parameter n = 8) (
    input clk,
    input [n-1:0] data,
    input load,
    input outputEnable,
    input rst,
    output reg [n-1:0] dataHold,
    output reg [n-1:0] dataOut);

always @ (posedge clk or posedge rst) begin
    if (rst == 1) begin
        dataHold <= 0;
    end

    if (load == 1) begin
        dataHold <= data;
    end

    if(outputEnable == 1) begin 
        dataOut <= dataHold;
    end
end
endmodule