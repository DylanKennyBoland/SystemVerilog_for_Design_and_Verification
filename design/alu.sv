// Author: Dylan Boland

import typedefs::*;

module alu
	(
	// ==== Inputs ====
	input logic clk,
	input logic [7:0] accum,
	input logic [7:0] data,
	input opcode_t opcode,
	// ==== Outputs ====
	output logic [7:0] out,
	output logic zero
	);
	
	// ==== Define the Time Unit and Precision ====
	timeunit 1ns;
	timeprecision 100ps;
	
	// ==== Logic for Generating and Driving the Zero Output ====
	always_comb begin
		// Check if the accumulator is at 0.
		// If it is, assert the zero output. Otherwise, deassert
		// the zero output.
		zero = (accum == 8'b0) ? 1'b1 : 1'b0;
	end
	
	// ==== Synchronous Logic for the Out Signal ====
	always_ff @(negedge clk) begin
		priority case (opcode)
			HLT,SKZ,STO,JMP: out <= accum;
			ADD: out <= data + accum;
			AND: out <= (data & accum);
			XOR: out <= (data ^ accum);
			LDA: out <= data;
		endcase
	end
endmodule
