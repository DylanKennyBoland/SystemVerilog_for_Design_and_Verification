// Author: Dylan Boland

module counter
	(
	// ==== Inputs ====
	input logic clk,
	input logic rst_,
	input logic enable,
	input logic load,
	input logic [4:0] data,
	// ==== Outputs ====
	output logic [4:0] count
	);
	
	// ==== Define the Time Unit and Precision ====
	// (100 ps)/(1 ns) = (100e-12)/(1e-9) = (100)(1e-3) = (100/1000) = 0.1 <- delay values will be rounded to one decimal place
	timeunit 1ns;
	timeprecision 100ps;
	
	// ==== Describe the Logic for the Counter ====
	always_ff @(posedge clk or negedge rst_) begin
		if (!rst_) begin
			count <= 5'd0;
		end else if (load) begin
			count <= data;
		end else if (enable) begin
			count <= count + 5'b1;
		end
		// Otherwise, the count will hold its current value
	end
endmodule
