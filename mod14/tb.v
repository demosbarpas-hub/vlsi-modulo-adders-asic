`timescale 1ps / 1ps

module tb;

    
    localparam DATA_WIDTH = 32;

    reg         clk_tb;
    reg         rst_tb;
    reg [DATA_WIDTH-1:0] a_tb;
    reg [DATA_WIDTH-1:0] b_tb;
    wire [3:0]  remainder_tb;

    
    mod_flip_flop uut (
        .clk(clk_tb),
        .rst(rst_tb),
        .A(a_tb),
        .B(b_tb),
        .remainder(remainder_tb)
    );
    
   
    initial begin
        clk_tb = 0;
        forever #10000 clk_tb = ~clk_tb; 
    end

    
    initial begin
       
        $sdf_annotate("mod_flip_flop_m.sdf", uut, ,"sdf.log", "MAXIMUM");

        
        a_tb = 32'd0;
        b_tb = 32'd0;
        rst_tb = 1'b1; 
        
        #10000; 

        rst_tb = 1'b0; 
        
        @(posedge clk_tb); 

        
        a_tb = 32'd100;
        b_tb = 32'd50;
        
        #10000; 
        
        a_tb = 32'd75;
        b_tb = -32'sd25;
        
        #10000;

        
        a_tb = -32'sd10;
        b_tb = -32'sd20;
        
        #10000;
        
        
        a_tb = 32'd123456;
        b_tb = 32'd7891011;
        
        #10000;

        
        #100000; 
        $stop;
    end

endmodule
