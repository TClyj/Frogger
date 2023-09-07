module final_project (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50);
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic [9:0]  LEDR;
    input  logic [3:0]  KEY;
    input  logic [9:0]  SW;
    output logic [35:0] GPIO_1;
    input logic CLOCK_50;

    assign HEX0 = '1;
    assign HEX1 = '1;
    assign HEX2 = '1;
    assign HEX3 = '1;
    assign HEX4 = '1;
    assign HEX5 = '1;
	 
	 logic [31:0] clk;
	 logic SYSTEM_CLOCK, SLOW_CLOCK;
	 
	 clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));
	 
	 assign SYSTEM_CLOCK = clk[15];
    assign SLOW_CLOCK = clk[25];	 
	
	 
	 /* Set up LED board driver
	    ================================================================== */
	 logic [15:0][15:0]RedPixels; // 16 x 16 array representing red LEDs
    logic [15:0][15:0]GrnPixels; // 16 x 16 array representing green LEDs
	 logic RST;                   // reset - toggle this on startup
	 logic left, right, up, down, numOut, crash;
	 
	 assign RST = SW[0];
	 
	 LEDDriver Driver (.CLK(SYSTEM_CLOCK), .RST, .EnableCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);
	 
	 inPuts in (.reset(RST), .clk(SYSTEM_CLOCK), .in1(~KEY[3]), .in2(~KEY[2]), .in3(~KEY[1]), .in4(~KEY[0]), .out1(left), .out2(up), .out3(down), .out4(right));
	 
	 centerLight L1 (.clock(SYSTEM_CLOCK), .reset(RST), .L(left), .R(right), .U(up), .D(down), .NL(GrnPixels[0][1]), .NR(0), .NU(GrnPixels[1][0]), .ND(0), .lightOn(GrnPixels[0][0]), .crash, .win);
	 
    normalLight L2 (.clock(SYSTEM_CLOCK), .reset(RST), .L(left), .R(right), .U(up), .D(down), .NL(0), .NR(GrnPixels[0][14]), .NU(GrnPixels[1][15]), .ND(0), .lightOn(GrnPixels[0][15]), .crash, .win);
	 
	 normalLight L3 (.clock(SYSTEM_CLOCK), .reset(RST), .L(left), .R(right), .U(up), .D(down), .NL(GrnPixels[14][0]), .NR(0), .NU(0), .ND(GrnPixels[14][0]), .lightOn(GrnPixels[15][0]), .crash, .win);
	 
	 normalLight L4 (.clock(SYSTEM_CLOCK), .reset(RST), .L(left), .R(right), .U(up), .D(down), .NL(0), .NR(GrnPixels[15][14]), .NU(0), .ND(GrnPixels[14][15]), .lightOn(GrnPixels[15][15]), .crash, .win);
	 
	 
	 genvar x, y, i, j, k, h;
	 logic [15:0] a, b;
	 logic win;
	 
	 generate
	    for (x = 1; x < 15; x++) begin: eachCol
		    for (y = 1; y<15; y++) begin: eachRow
		       normalLight L5 (.clock(SYSTEM_CLOCK), .reset(RST), .L(left), .R(right), .U(up), .D(down), .NL(GrnPixels[x][y+1]), .NR(GrnPixels[x][y-1]), .NU(GrnPixels[x+1][y]), .ND(GrnPixels[x-1][y]), .lightOn(GrnPixels[x][y]), .crash, .win);
			 end
		 end
	 endgenerate
	 
	 generate
	    for (i = 1; i < 15; i++) begin: eachTop
		    normalLight L6 (.clock(SYSTEM_CLOCK), .reset(RST), .L(left), .R(right), .U(up), .D(down), .NL(GrnPixels[0][i + 1]), .NR(GrnPixels[0][i - 1]), .NU(GrnPixels[1][i]), .ND(0), .lightOn(GrnPixels[0][i]), .crash, .win);
		 end
    endgenerate

    generate
	    for (j = 1; j < 15; j++) begin: eachBottom
		    normalLight L7 (.clock(SYSTEM_CLOCK), .reset(RST), .L(left), .R(right), .U(up), .D(down), .NL(GrnPixels[15][j + 1]), .NR(GrnPixels[15][j - 1]), .NU(0), .ND(GrnPixels[14][j]), .lightOn(GrnPixels[15][j]), .crash, .win);
		 end
    endgenerate

    generate
	    for (k = 1; k < 15; k++) begin: eachLeft
		    normalLight L8 (.clock(SYSTEM_CLOCK), .reset(RST), .L(left), .R(right), .U(up), .D(down), .NL(0), .NR(GrnPixels[k][14]), .NU(GrnPixels[k+1][15]), .ND(GrnPixels[k-1][15]), .lightOn(GrnPixels[k][15]), .crash, .win);
		 end
    endgenerate

    generate
	    for (h = 1; h < 15; h++) begin: eachRight
		    normalLight L9 (.clock(SYSTEM_CLOCK), .reset(RST), .L(left), .R(right), .U(up), .D(down), .NL(GrnPixels[h][1]), .NR(0), .NU(GrnPixels[h+1][0]), .ND(GrnPixels[h-1][0]), .lightOn(GrnPixels[h][0]), .crash, .win);
		 end
    endgenerate
	
   location l (.clock(SYSTEM_CLOCK), .RST, .a, .b, .L(left), .R(right), .U(up), .D(down));
   win w (.b, .win);	
   crash c (.Red(RedPixels[b][a]), .Grn(GrnPixels[b][a]), .reset(RST), .clk(SYSTEM_CLOCK), .crash, .LEDR);
   car_flow car (.RST, .RedPixels, .numOut, .clk(SLOW_CLOCK), .check(1));		
endmodule

module final_project_testbench();
   logic CLOCK_50;
   logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
   logic [9:0] LEDR;
   logic [3:0] KEY;
   logic [9:0] SW;
	logic [35:0] GPIO_1;
	
   final_project dut (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50);

   parameter CLOCK_PERIOD=100;
   initial begin
      CLOCK_50 <= 0;
      forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
   end
	
   initial begin
      SW[0] <= 1;  @(posedge CLOCK_50);
      SW[0] <= 0;  @(posedge CLOCK_50);
      KEY[0] <= 1; KEY[1] <= 1; KEY[2] <= 1; KEY[3] <= 0;     repeat(10)     @(posedge CLOCK_50);
                                                   @(posedge CLOCK_50);
      KEY[2] <= 0;      repeat(4)     @(posedge CLOCK_50);
                                                   @(posedge CLOCK_50);
      KEY[2] <= 0;      repeat(4)     @(posedge CLOCK_50);
		                                             @(posedge CLOCK_50);
      KEY[2] <= 0;      repeat(4)     @(posedge CLOCK_50);
		                                             @(posedge CLOCK_50);
	   KEY[1] <= 0;     repeat(4)     @(posedge CLOCK_50);
		                                             @(posedge CLOCK_50);
      KEY[0] <= 0;     repeat(4)     @(posedge CLOCK_50);
		                                             @(posedge CLOCK_50);
		KEY[2] <= 0;      repeat(4)     @(posedge CLOCK_50);
		                                             @(posedge CLOCK_50);
      $stop;
   end
endmodule