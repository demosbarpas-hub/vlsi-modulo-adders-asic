`timescale 1ps / 1ps

module tb; 

   
    reg  [31:0] a_tb;
    reg  [31:0] b_tb;
    reg         clk_tb;
    reg         rst_tb;
    wire [3:0]  remainder_tb;
    
   
    mod_flip_flop uut ( 
        .A(a_tb),         
        .B(b_tb),         
        .clk(clk_tb),
        .rst(rst_tb),
        .remainder(remainder_tb)
    );
    
    
    initial begin
        clk_tb = 0;
        forever #10000 clk_tb = ~clk_tb; 
    end

    
    initial begin
        
        $sdf_annotate("mod15_flip_flop_m.sdf", uut,,"sdf.log", "MAXIMUM");

        
        a_tb = 32'd0;
        b_tb = 32'd0;
        rst_tb = 1'b1; 
        #40000; 

        rst_tb = 1'b0; 
        #5000; 

        
        a_tb = 32'd2147483647;
        b_tb = -32'sd1;
        #50000; 


        a_tb = 32'd216;
        b_tb = 32'd300;
        #50000;

        
        a_tb = -32'sd92;
        b_tb = 32'd100;
        #50000;

       
        a_tb = 32'd715827882;
        b_tb = 32'd357913941;
        #50000;

        
        a_tb = -32'sd715827883;
        b_tb = -32'sd357913941;
        #50000;
        
        
        a_tb = 32'd2147483647;
        b_tb = -32'sd1;
        #50000;

        $stop;
    end

endmodule