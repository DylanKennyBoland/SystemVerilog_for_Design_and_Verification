// Author: Dylan Boland

module mem_test
	(
	// ==== Inputs ====
	input logic clk,
	input wire [7:0] data_out,
	// ==== Outputs ====
	output logic read,
	output logic write,
	output logic [4:0] addr,
	output logic [7:0] data_in
	);
	
	// ==== Time Unit and Precision ====
	timeunit 1ns;
	timeprecision 1ns;
	
	// ==== Local Variables ====
	bit debug = 1'b1;
	logic [7:0] rdata;
	int num_addresses = 32; // A 5-bit address line means there are 2^5 = 32 addresses
	
	initial begin
		$timeformat (-9, 0, "ns", 9);
		#50000ns;
		$display("Test Timeout");
		$finish;
	end
	
	initial begin: memory_test
		// ==== Local Variables ====
		int error_status;
		
		$display("Test stage: Clearing memory");
		
		// ==== Write Zero to Every Address ====
		for (int addr = 0; addr < num_addresses;  addr++) begin
			write_mem(addr, 8'h00, 1'b1);
		end
		
		// ==== Read Every Address Back and Ensure the Data is Correct ====
		for (int addr = 0; addr < num_addresses;  addr++) begin
			read_mem(addr, rdata, 1'b1);
			error_status = check_data(addr, rdata, 8'h00);
		end
		
		$display("Done clearing memory. No. errors: %0d", error_status);
		
		$display("Test stage: Set data at each address equal to the address");
		
		// ==== Write Address Value to Every Address Location ====
		for (int addr = 0; addr < num_addresses;  addr++) begin
			write_mem(addr, 8'(addr), 1'b1);
		end
		
		// ==== Read Every Address Back and Ensure the Data is Correct ====
		for (int addr = 0; addr < num_addresses;  addr++) begin
			read_mem(addr, rdata, 1'b1);
			error_status = check_data(addr, rdata, addr);
		end
		
		$display("No. errors: %0d", error_status);
		
		print_status(error_status);
		
		$finish;
	end

	// ==== Tasks ====
	// Task to write a value to memory
	task write_mem (input logic [4:0] waddr, input logic [7:0] data, input bit debug = 1'b0);
		@(negedge clk);
		#1; // change the data just after the falling clock edge
		addr    <= waddr;
		data_in <= data;
		read    <= 1'b0;
		write   <= 1'b1;
		if (debug) begin
			$display("Writing to memory:\nAddress = %0x, Data = %0x", addr, data);
		end
		// Wait until the next rising edge of the clock
		@(posedge clk);
		#1;
		write <= 1'b0; // de-assert the write signal
	endtask
	
	// Task to read a value from memory
	task read_mem (input logic [4:0] raddr, output [7:0] data, input bit debug = 1'b0);
		@(negedge clk);
		#1; // change the data just after the falling clock edge
		addr    <= raddr;
		read    <= 1'b1;
		write   <= 1'b0;
		// Wait until the next rising edge of the clock, 
		// when the data should be ready
		@(posedge clk);
		#1;
		read <= 1'b0; // de-assert the read signal
		data <= data_out; // sampling the read-data bus coming from the memory
		#1;
		if (debug) begin
			$display("Reading from memory:\nAddress = %0x, Data = %0x", addr, data);
		end
	endtask
	
	// ==== Functions ====
	function void print_status(int error_count);
		// ==== Check if the Tests Passed or Failed ====
		if (error_count == 0) begin
			$display("Memory test PASSED");
		end else begin
			$display("Memory test FAILED");
		end
	endfunction
	
	// ==== A Function to Check if the Data is as Expected ====
	function int check_data (input [4:0] addr, input [7:0] actual, expected);
		static int error_count;
		if (actual != expected) begin
			$display("Data is NOT as expected for address 0x%0x. Actual: 0x%0x, Expected: 0x%0x", addr, actual, expected);
			error_count++; // increment the error count
		end
	endfunction
endmodule
