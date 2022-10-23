module ram #(

    // Parameters
    parameter   INIT_FILE = ""
    
) (
     // Inputs
    input               clk,
    input               w_en,
    input               r_en,
    input       [3:0]   address,
    input       [7:0]   w_data,
    
    // Outputs
    output  reg [7:0]   r_data );

    // Declare memory
    reg [7:0]  mem [0:15];
    
    always @ (posedge clk) begin
        if(r_en == 1'b1) begin
            r_data <= mem[address];
        end 
        
        if (w_en == 1'b1) begin
            mem[address] <= w_data;
        end
    end

    // Initialization (if available)
    initial if (INIT_FILE) begin
        $readmemh(INIT_FILE, mem);
    end

endmodule