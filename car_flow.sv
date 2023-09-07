module car_flow (RST, RedPixels, numOut, clk, check);
   input logic RST, numOut, clk, check;
	output logic [15:0][15:0] RedPixels;
	
	enum logic [15:0]{one = 16'b1001001001001001, two = 16'b0100100100100100, three = 16'b0010010010010010} ps, ns;
	
	always_comb begin
	   case(ps)
		   one: if (check) ns = two;
			     else ns = one;
		   two: if (check) ns = three;
			     else ns = two;
		   three: if (check) ns = one;
			       else ns = three;
		endcase
   end
	
	assign RedPixels[9] = ps;
	
	always_ff @(posedge clk) begin
      if (RST)
         ps <= one;
      else
         ps <= ns;
   end
endmodule

module car_flow_testbench();
   logic RST, numOut, clock, check;
	logic [15:0][15:0] RedPixels;
	
   car_flow dut (RST, RedPixels, numOut, clock, check);

   parameter CLOCK_PERIOD=100;
   initial begin
      clock <= 0;
      forever #(CLOCK_PERIOD/2) clock <= ~clock;
   end

   initial begin
   RST <= 1;         @(posedge clock);
   RST <= 0; check <=1;        @(posedge clock);
          repeat(10)     @(posedge clock);
	$stop;
   end
endmodule