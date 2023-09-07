module location (clock, RST, a, b, L, R, U, D);
   input logic clock, RST, L, R, U, D;
	output logic [15:0] a, b;
	
	always_ff @(posedge clock)
	   begin
		   if (RST) begin
			   a = '0;
				b = '0;
			end 
			else begin
			if (L) begin
			   a = a + 1;
			end 
			else if (R) begin
			   a = a - 1;
			end
			else if (U) begin
			   b = b + 1;
			end
			else if (D) begin
			   b = b - 1;
			end
			end
		end
	
endmodule	

module location_testbench();
   logic clock, RST, L, R, U, D;
	logic [15:0] a, b;
	
   location dut (clock, RST, a, b, L, R, U, D);

   parameter CLOCK_PERIOD=100;
   initial begin
      clock <= 0;
      forever #(CLOCK_PERIOD/2) clock <= ~clock;
   end

   initial begin
   RST <= 1;         @(posedge clock);
   RST <= 0;        @(posedge clock);
   L <= 1; R <= 0; U <= 0; D <= 0; repeat(4)     @(posedge clock);
                                                   @(posedge clock);
   L <= 0; R <= 1; U <= 0; D <= 0; repeat(4)     @(posedge clock);
                                                   @(posedge clock);
   L <= 1; R <= 0; U <= 0; D <= 0; repeat(4)     @(posedge clock);
                                                   @(posedge clock);
	L <= 0; R <= 1; U <= 0; D <= 0; repeat(4)     @(posedge clock);
	$stop;
   end
endmodule	   