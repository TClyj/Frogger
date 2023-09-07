module win (b, win);
   input logic [15:0]b;
	output logic win;
	
	assign win = (b > 14);
endmodule
