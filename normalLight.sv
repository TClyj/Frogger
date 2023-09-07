module normalLight (clock, reset, L, R, U, D, NL, NR, NU, ND, lightOn, crash, win);
   input logic clock, reset, crash, win;
   input logic L, R, U, D, NL, NR, NU, ND;
   output logic lightOn;
   
	enum {on, off} ps, ns;
	
	always_comb begin
	   case(ps)
		   on: if (L & ~R & ~U & ~D & ~NR & ~NL & ~NU & ~ND) ns = off;
		       else if (~L & R & ~U & ~D & ~NR & ~NL & ~NU & ~ND) ns = off;
				 else if (~L & ~R & U & ~D & ~NR & ~NL & ~NU & ~ND) ns = off;
				 else if (~L & ~R & ~U & D & ~NR & ~NL & ~NU & ~ND) ns = off;
				 else ns = on;
		   off: if (L & ~R & ~U & ~D & NR & ~NL & ~NU & ~ND) ns = on;
			     else if (~L & R & ~U & ~D & ~NR & NL & ~NU & ~ND) ns = on;
				  else if (~L & ~R & U & ~D & ~NR & ~NL & ~NU & ND) ns = on;
				  else if (~L & ~R & ~U & D & ~NR & ~NL & NU & ~ND) ns = on;
				  else ns = off;
		endcase
   end
	
	assign lightOn = (ps == on);
	
	always_ff @(posedge clock) begin
      if (reset || crash || win)
         ps <= off;
      else
         ps <= ns;
      end
endmodule

module normalLight_testbench();
   logic clock, reset, crash;
   logic L, R, U, D, NL, NR, NU, ND;
	logic lightOn;
	
   normalLight dut (clock, reset, L, R, U, D, NL, NR, NU, ND, lightOn, crash);

   parameter CLOCK_PERIOD=100;
   initial begin
      clock <= 0;
      forever #(CLOCK_PERIOD/2) clock <= ~clock;
   end

   initial begin
   reset <= 1;         @(posedge clock);
   reset <= 0;         @(posedge clock);
   L <= 1; R <= 0; U <= 0; D <= 0; NR <= 0; NL <= 0; NU <= 0; ND <= 0; repeat(4)     @(posedge clock);
                                                   @(posedge clock);
   L <= 0; R <= 1; U <= 0; D <= 0; NR <= 0; NL <= 0; NU <= 0; ND <= 0; repeat(4)     @(posedge clock);
                                                   @(posedge clock);
   L <= 1; R <= 0; U <= 0; D <= 0; NR <= 1; NL <= 0; NU <= 0; ND <= 0; repeat(4)     @(posedge clock);
                                                   @(posedge clock);
	L <= 0; R <= 1; U <= 0; D <= 0; NR <= 0; NL <= 1; NU <= 0; ND <= 0; repeat(4)     @(posedge clock);
   $stop;
   end
endmodule
