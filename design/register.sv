// Author: Dylan Boland

// ==== Module Description of an 8-bit register with an enable input ====
module register
	(
	// ==== Inputs ====
	input clk,
	input rst_,
	input enable,
	input logic [7:0] data,
	// ==== Outputs ====
	output logic [7:0] out
	);
	
	// ==== Specify the time unit and the time precision ====
	timeunit 1ns;
	timeprecision 100ps;
	
	// ==== Logic for updating the register ====
	always_ff @(posedge clk or negedge rst_) begin
		if (!rst_) begin
			out <= 8'd0;
		end else if (enable) begin
			out <= data;
		end
	end
endmodule
