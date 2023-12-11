// Author: Dylan Boland

module scale_mux
	# (
	parameter MUX_WIDTH = 1
	)
	(
	// ==== Inputs ====
	input logic [MUX_WIDTH-1:0] in_a,
	input logic [MUX_WIDTH-1:0] in_b,
	input logic sel_a,
	// ==== Outputs ====
	output logic [MUX_WIDTH-1:0] out
	);
	
	// ==== Define the Time Unit and Precision for the Design Element ====
	timeunit 1ns;
	timeprecision 100ps;
	
	// ==== Describe the Logic for the MUX's behaviour ====
	always_comb begin
		unique case (sel_a)
			1'b1: out = in_a;
			1'b0: out = in_b;
			default: out = 'x;
		endcase
	end
endmodule
