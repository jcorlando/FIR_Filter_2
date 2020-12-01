`timescale 1ns / 1ps

module tb_FIR_filter_2;
    
    //Inputs
    reg CLK = 0;                    // Clock
    
    // Clock generation
    always #22 CLK <= ~CLK;
    
    // Instantiate DUT
    top # (.WL(4))                  // Clock
        top( .CLK(CLK) );           // Clock
    
endmodule
