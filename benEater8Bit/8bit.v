module eightBit (
    input fastClk,
    input pushButttonClock, 
    input clockChooser,
    input rst, //global reset 
    output wire [7:0] dataBus
);

wire clk;
wire hlt, mi, ri, ro, io, ii, ai, ao, sumo, sub, bi, oi, ce, co, j;
wire [7:0] a;
wire [7:0] b;

// INSTANTIATE THE CLOCK //
clock mainClock (.fastClk(fastClk), .clockChooser(clockChooser), .pushButttonClock(pushButttonClock), .halt(hlt), .clk(clk));

// MAKE THE PROGRAM COUNTER //
programCounter pc (.clk(clk), .outputEnable(co), .jump(j), .countEnable(ce), .jumpAddr(dataBus[3:0]), .addr(dataBus[3:0]));

// MAKE THE DECODER LOGIC //

wire [7:0] opcodeTransfer;
decoder controlLogic(.insn(opcodeTransfer), .clk(clk), .hlt(hlt), .mi(mi),
.ri(ri), .ro(ro), .io(io), .ii(ii), .ai(ai), .ao(ao), .sumo(sumo), .sub(sub), 
.bi(bi), .oi(oi), .ce(ce), .co(co), .j(j));

// MAKE THE A REGISTER //
register #(.n(8)) aRegister (.clk(clk), .data(dataBus), .load(ai), .outputEnable(ao), .rst(rst), .dataOut(dataBus), .dataHold(a));

// MAKE THE B REGISTER //
register #(.n(8)) bRegister (.clk(clk), .data(dataBus), .load(bi), .rst(rst), .dataHold(b));

// MAKE THE INSTRUCTION REGISTER //
register #(.n(8)) insnRegister (.clk(clk), .data(dataBus), .load(ii), .outputEnable(io), .dataOut(dataBus), .dataHold(opcodeTransfer), .rst(rst));

wire [3:0] memAddress;
// MAKE THE MEMORY ADDRESS REGISTER //
register #(.n(4)) memAddressRegister (.clk(clk), .data(dataBus[3:0]), .load(mi), .dataOut(dataBus[3:0]), .dataHold(memAddress), .rst(rst));

// MAKE THE RAM //
ram ram (.clk(clk), .w_en(ri), .r_en(ro), .address(memAddress), .w_data(dataBus), .r_data(dataBus));

// MAKE THE ALU //
alu alu (.a(a), .b(b), .sub(sub), .out(dataBus));

// MAKE THE OUPTUT REGISTER //
// I need to get some seven segment displays first before doing this
// display disp (); 

endmodule