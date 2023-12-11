// Author: Dylan Boland

import typedefs::*; // importing the type definitions for this module

module control
	(
	// ==== Inputs ====
	input clk,
	input rst_,
	input logic zero,
	input opcode_t opcode,
	// ==== Outputs ====
	output logic mem_rd,
	output logic load_ir,
	output logic halt,
	output logic inc_pc,
	output logic load_ac,
	output logic load_pc,
	output logic mem_wr
	);
	
	// ==== Define the Time Unit and Precision ====
	timeunit 1ns;
	timeprecision 100ps;
	
	// ==== Internal Signals ====
	wire alu_op = (opcode == ADD) || (opcode == AND) || (opcode == XOR) || (opcode == LDA);
	
	state_t ctrl_next_state; // variable to store the next-state value of the controller
	state_t ctrl_curr_state; // variable to store the current-state value of the controller
	
	// ==== Combinational Logic for the Next State ====
	always_comb begin
		case (ctrl_curr_state)
			INST_ADDR: ctrl_next_state  = INST_FETCH;
			INST_FETCH: ctrl_next_state = INST_LOAD;
			INST_LOAD: ctrl_next_state  = IDLE;
			IDLE: ctrl_next_state       = OP_ADDR;
			OP_ADDR: ctrl_next_state    = OP_FETCH;
			OP_FETCH: ctrl_next_state   = ALU_OP;
			ALU_OP: ctrl_next_state     = STORE;
			STORE: ctrl_next_state      = INST_ADDR;
		endcase
	end
	
	// ==== Synchronous Logic for the Current State ====
	always_ff @(posedge clk or negedge rst_) begin
		if (!rst_) begin
			ctrl_curr_state <= INST_ADDR;
		end else begin
			ctrl_curr_state <= ctrl_next_state;
		end
	end
	
	// ==== Logic for Generating the Outputs ====
	always_comb begin
		// ==== Define the Default Behaviour ====
		mem_rd  = 1'b0;
		load_ir = 1'b0;
		halt    = 1'b0;
		inc_pc  = 1'b0;
		load_ac = 1'b0;
		load_pc = 1'b0;
		mem_wr  = 1'b0;
		// ==== The Output Values depend on the Current State as well as the Inputs ====
		case (ctrl_curr_state)
			INST_ADDR: begin
				// All the outputs stay low. This
				// is accounted for by the default-behaviour definition
				// that we have given above
			end
			INST_FETCH: begin
				mem_rd = 1'b1;
			end
			INST_LOAD: begin
				mem_rd = 1'b1;
				load_ir = 1'b1;
			end
			IDLE: begin
				mem_rd = 1'b1;
				load_ir = 1'b1;
			end
			OP_ADDR: begin
				halt = (opcode == HLT);
				inc_pc = 1'b1;
			end
			OP_FETCH: begin
				mem_rd = alu_op;
			end
			ALU_OP: begin
				mem_rd = alu_op;
				inc_pc = (opcode == SKZ) && zero;
				load_ac = alu_op;
				load_pc = (opcode == JMP);
			end
			STORE: begin
				mem_rd = alu_op;
				inc_pc = (opcode == JMP);
				load_ac = alu_op;
				load_pc = (opcode == JMP);
				mem_wr = (opcode == STO);
			end
		endcase
	end
	
endmodule

