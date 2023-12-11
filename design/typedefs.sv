// Author: Dylan Boland

package typedefs;

	// ==== Enumerated Type for the Instruction-Operation (OP) Codes ====
	typedef enum logic [2:0] {
		HLT, // the halt instruction
		SKZ, // skip if the zero input is high
		ADD, // add the data input to the accumulator
		AND, // bitwise AND the data with the accumulator value
		XOR, // bitwise XOR the data with the accumulator value
		LDA, // load the value from the accumulator
		STO, // store the value into the accumulator
		JMP  // jump to the address
		} opcode_t;
	
	// ==== Enumerated Type for the State of the Controller ====
	// We have eight states, so a 3-bit vector should be sufficient (2^3 = 8)
	typedef enum logic [2:0] {
		INST_ADDR,  // the reset state (for getting the address (ADDR) of the first instruction (INST))
		INST_FETCH, // state for fetching the instruction
		INST_LOAD,  // state for loading the instruction
		IDLE,
		OP_ADDR,
		OP_FETCH,
		ALU_OP,
		STORE
	} state_t;

endpackage