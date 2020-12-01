`timescale 1ns / 1ps
module top # ( parameter WL = 4 )
(
    input CLK
);
    reg end_of_input_flag = 0;
    reg [4 : 0] index = 0;                                      // index for input initialiazed to 0
    reg [WL - 1 : 0] x_input[0 : 20];                           // Input x values memory
    wire signed [WL - 1 : 0] x_out;                             // x values output
    initial $readmemb("x.mem", x_input);                        // Initialize Inputs
    
    always @ (posedge CLK)
    begin
        if(index < 20) index = index + 1;       // Index iterates through x_input vector @ pos-edge of CLK
        else end_of_input_flag <= 1;            // this signals the end of input
    end
    
    assign x_out = end_of_input_flag ? 0 : x_input[index];                          // x_out gets assigned to the current index of x_input
    delay_register # (.WL(WL)) delay_1( .CLK(CLK), .in(x_out), .out() );            // The two delay registers
    delay_register # (.WL(WL)) delay_2( .CLK(CLK), .in(delay_1.out), .out() );      // The two delay registers
    
    wire signed [WL + WL - 1 : 0] mult_out_1 =       x_out * 4'sb1101;          // h[0] multiplier
    wire signed [WL + WL - 1 : 0] mult_out_2 = delay_1.out * 4'sb0011;          // h[1] multiplier
    wire signed [WL + WL - 1 : 0] mult_out_3 = delay_2.out * 4'sb0101;          // h[2] multiplier
    
    wire signed [WL + WL : 0] add_out_1 = mult_out_1 + mult_out_2;              // h[0] + h[1]
    wire signed [WL + WL + 1 : 0] add_out_2 = add_out_1 + mult_out_3;           // Adder + h[2]
endmodule