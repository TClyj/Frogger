module crash (Red, Grn, reset, clk, crash, LEDR);
   input logic reset, clk;
   input logic [15:0][15:0]Red;
   input logic [15:0][15:0]Grn;
	output logic crash;
	output logic [9:0]LEDR;
	
	enum {crash1, game} ps, ns;
	
	always_comb begin
	   case(ps)
		   crash1: ns = crash1;
		   game: if (Red & Grn) ns = crash1;
					else ns = game;
		endcase
	end
	
	assign crash = (ns == crash1);
	assign LEDR[0] = (ns == crash1);
	
	always_ff @(posedge clk) begin
      if (reset)
         ps <= game;
      else
         ps <= ns;
   end
	
endmodule

module crash_testbench();
   logic reset, clk;
   logic [15:0][15:0]Red;
   logic [15:0][15:0]Grn;
	logic crash;
	logic [9:0]LEDR;
	
   crash dut (Red, Grn, reset, clk, crash, LEDR);
	
   parameter CLOCK_PERIOD=100;
   initial begin
      clk <= 0;
      forever #(CLOCK_PERIOD/2) clk <= ~clk;
   end
	
   initial begin
   reset <= 1;         @(posedge clk);
   reset <= 0;         @(posedge clk);
   Red[1][3] <= 1; Grn[1][3] <= 0; repeat(4)     @(posedge clk);
	Red[1][3] <= 0; Grn[1][3] <= 1; repeat(4)     @(posedge clk);
	Red[1][3] <= 0; Grn[1][3] <= 0; repeat(4)     @(posedge clk);
	Red[1][3] <= 1; Grn[1][3] <= 1; repeat(4)     @(posedge clk);
   $stop;
   end
endmodule