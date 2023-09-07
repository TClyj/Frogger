module D_FF (q, d, reset, clk); 
  output logic  q; 
  input  logic  d, reset, clk; 
 
  always_ff @(posedge clk) begin // Hold val until clock edge 
    if (reset) 
      q <= 0;  // On reset, set to 0 
    else 
      q <= d; // Otherwise out = d 
  end 
 
endmodule

module tem (reset, clk, out, realOut);
   input logic reset, clk, out;
	output logic realOut;
   enum {one, two} ps, ns;
	
	always_comb begin
	   case(ps)
		   one: if (out) ns = two; 
				 else ns = one;
		   two: if (~out) ns = one;
				  else ns = two;
		endcase
   end
	
	assign realOut = (ps == one & out == 1);
	
	always_ff @(posedge clk) begin
      if (reset)
         ps <= one;
      else
         ps <= ns;
   end
endmodule

module inPuts (reset, clk, in1, in2, in3, in4, out1, out2, out3, out4);
   output logic out1, out2, out3, out4;
	input logic reset, clk, in1, in2, in3, in4;
	logic tem1, tem2, tem3, tem4, tempOut1, tempOut2, tempOut3, tempOut4;
	
	D_FF D1 (.q(tem1), .d(in1), .reset, .clk);
	D_FF D2 (.q(tempOut1), .d(tem1), .reset, .clk);
	
   D_FF D3 (.q(tem2), .d(in2), .reset, .clk);
	D_FF D4 (.q(tempOut2), .d(tem2), .reset, .clk);
	
	D_FF D5 (.q(tem3), .d(in3), .reset, .clk);
	D_FF D6 (.q(tempOut3), .d(tem3), .reset, .clk);
	
	D_FF D7 (.q(tem4), .d(in4), .reset, .clk);
	D_FF D8 (.q(tempOut4), .d(tem4), .reset, .clk);
	
	tem t1 (.reset, .clk, .out(tempOut1), .realOut(out1));
   tem t2 (.reset, .clk, .out(tempOut2), .realOut(out2));
   tem t3 (.reset, .clk, .out(tempOut3), .realOut(out3));
   tem t4 (.reset, .clk, .out(tempOut4), .realOut(out4));	
endmodule

module inPuts_testbench();
   logic out1, out2, out3, out4;
	logic reset, clk, in1, in2, in3, in4;
	
   inPuts dut (reset, clk, in1, in2, in3, in4, out1, out2, out3, out4);
	
   parameter CLOCK_PERIOD=100;
   initial begin
      clk <= 0;
      forever #(CLOCK_PERIOD/2) clk <= ~clk;
		end
	
   initial begin
	
   reset <= 1;         @(posedge clk);
   reset <= 0;         @(posedge clk);
   in1 <= 0; in2 <= 0; in3 <= 0; in4 <= 0; repeat(4)     @(posedge clk);
                                     @(posedge clk);
   in1 <= 0; in2 <= 1; in3 <= 0; in4 <= 0; repeat(4)     @(posedge clk);
                                     @(posedge clk);
   in1 <= 1; in2 <= 0; in3 <= 0; in4 <= 0; repeat(4)     @(posedge clk);
                                     @(posedge clk);
	in1 <= 1; in2 <= 1; in3 <= 0; in4 <= 0; repeat(4)     @(posedge clk);
   $stop;
   end
endmodule