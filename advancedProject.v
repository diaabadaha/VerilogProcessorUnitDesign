`timescale 1ns / 1ns

module alu (
    input [5:0] opcode,
    input signed [31:0] a, b,
    output reg signed [31:0] result
);

always @ (*) begin
    case (opcode)
      	// Cases of opcodes based on ID digit '8'
        6'b000001:  result = a + b;             // a + b
        6'b000110:  result = a - b;             // a - b
        6'b001101: begin                        // |a|
            if (a[31] == 1'b1) begin
                result = ~a + 1;
            end else begin
                result = a;
            end
        end
        6'b001000:  result = -a;                // Negation of a
        6'b000111: begin                        // Max(a, b)
            if (a > b) begin
                result = a;
            end else begin
                result = b;
            end
        end
        6'b000100: begin                        // Min(a, b)
            if (a < b) begin
                result = a;
            end else begin
                result = b;
            end
        end
      	6'b001011: result = (a + b) / 2;        // Avg(a, b)
        6'b001111: result = ~a;                 // Not a
        6'b000011: result = a | b;              // a OR b
        6'b000101: result = a & b;              // a AND b
        6'b000010: result = a ^ b;              // a XOR b
    endcase
end

endmodule

// ***************************************************************************************************

module reg_file (
    input clk,
    input valid_opcode,
  	input [4:0] addr1, addr2, addr3,
    input signed [31:0] in,
  	output reg signed [31:0] out1, out2
);

// 2D array of 32 registers, each 32 bits wide
reg [31:0] registers[31:0];

// Fill the registers based on ID digit '7'
initial begin
    registers[0] = 32'h0000;
  	registers[1] = 32'h3aba;
  	registers[2] = 32'h2296;
  	registers[3] = 32'haa;
  	registers[4] = 32'h1c3a;
  	registers[5] = 32'h1180;
  	registers[6] = 32'h22e0;
  	registers[7] = 32'h1c86;
  	registers[8] = 32'h22da;
  	registers[9] = 32'h414;
    registers[10] = 32'h1a32;
  	registers[11] = 32'h102;
  	registers[12] = 32'h1cba;
  	registers[13] = 32'hcde;
  	registers[14] = 32'h3994;
  	registers[15] = 32'h1984;
  	registers[16] = 32'h28c4;
  	registers[17] = 32'h2e7c;
  	registers[18] = 32'h3966;
  	registers[19] = 32'h227e;
  	registers[20] = 32'h2208;
  	registers[21] = 32'h11b4;
  	registers[22] = 32'h237c;
  	registers[23] = 32'h360e;
  	registers[24] = 32'h2722;
  	registers[25] = 32'h500;
  	registers[26] = 32'h16b6;
  	registers[27] = 32'h29e;
  	registers[28] = 32'h2280;
  	registers[29] = 32'h3b52;
	registers[30] = 32'h11a0;
    registers[31] = 32'h0;
end


always @(*) begin
    if (valid_opcode) begin
        out1 = registers[addr1]; // Read from addr1
      	out2 = registers[addr2]; // Read from addr2
    end
end
   
always @(posedge clk) begin
    if (valid_opcode) begin
        registers[addr3] <= in; // Write to addr3
    end
end

endmodule

// ***************************************************************************************************

module mp_top (
    input clk,
    input [31:0] instruction,
  	output reg signed [31:0] result
);

  reg [5:0] opcode;
  reg [4:0] addr1;
  reg [4:0] addr2;
  reg [4:0] addr3;
  reg [31:0] read_data1, read_data2, alu_result;
  reg valid_opcode;
  
// Instruction bits distribution
always @(posedge clk) begin
    opcode <= instruction[5:0];
    addr1 <= instruction[10:6];
    addr2 <= instruction[15:11];
    addr3 <= instruction[20:16];
end
  
reg [5:0] opcodes[0:10]; // Array of opcodes to check if the opcode is valid or not
  
// Initialize opcodes array
initial begin
  opcodes[0] = 6'b000001;  // Add
  opcodes[1] = 6'b000110;  // Subtract
  opcodes[2] = 6'b001101;  // Absolute
  opcodes[3] = 6'b001000;  // Negation
  opcodes[4] = 6'b000111;  // Max
  opcodes[5] = 6'b000100;  // Min
  opcodes[6] = 6'b001011;  // Avg
  opcodes[7] = 6'b001111;  // Not A
  opcodes[8] = 6'b000011;  // Or
  opcodes[9] = 6'b000101;  // And
  opcodes[10] = 6'b000010; // Xor
end
  
// Set valid_opcode based on the opcodes array
always @(*) begin
    valid_opcode = 1'b0; // Default to invalid
    for (int i = 0; i < 11; i = i + 1) begin
        if (opcode == opcodes[i]) begin
            valid_opcode = 1'b1; // Set to valid if the opcode matches
            break; // Exit the loop early if we have a match
        end
    end
end  

// Instantiate the register file
reg_file reg_file1 (clk, valid_opcode, addr1, addr2, addr3, result, read_data1, read_data2);

// Instantiate the ALU
alu alu1 (opcode, read_data1, read_data2, result);

endmodule		 
	
// ***************************************************************************************************

`timescale 1ns / 1ns

module mp_top_tb;

    reg clk;
    reg [31:0] instruction;
    wire signed [31:0] result;
    reg valid_opcode;
  	reg fail_flag;

    // Instantiate the top module
    mp_top mp_top1 (clk, instruction, result);
  
  	// Function to calculate the absolute value
  	function [31:0] absolute_value;
		input signed [31:0] num;
		begin
  		if (num[31])
        	absolute_value = ~num + 1;
        else 
          	absolute_value = num;
  		end
  	endfunction
  
  	// Function to find the maximum value between two inputs
	function [31:0] max_value;
        input [31:0] a, b;
        begin
            if (a > b)
                max_value = a;
            else
                max_value = b;
        end
    endfunction
  
	// Function to find the maximum value between two inputs
  	function [31:0] min_value;
        input [31:0] a, b;
        begin
          if (a < b)
                min_value = a;
            else
                min_value = b;
        end
    endfunction

    // Test vectors and memory
  	reg [31:0] instructions[11:0];
    reg signed [31:0] expected_results[11:0];
  	reg signed [31:0] mem [31:0];

    // Initialize test vectors and memory
    initial begin
      mem[0] = 32'h0000;
  	  mem[1] = 32'h3aba;
      mem[2] = 32'h2296;
  	  mem[3] = 32'haa;
  	  mem[4] = 32'h1c3a;
  	  mem[5] = 32'h1180;
  	  mem[6] = 32'h22e0;
  	  mem[7] = 32'h1c86;
  	  mem[8] = 32'h22da;
  	  mem[9] = 32'h414;
      mem[10] = 32'h1a32;
  	  mem[11] = 32'h102;
  	  mem[12] = 32'h1cba;
  	  mem[13] = 32'hcde;
  	  mem[14] = 32'h3994;
  	  mem[15] = 32'h1984;
  	  mem[16] = 32'h28c4;
  	  mem[17] = 32'h2e7c;
  	  mem[18] = 32'h3966;
  	  mem[19] = 32'h227e;
  	  mem[20] = 32'h2208;
  	  mem[21] = 32'h11b4;
  	  mem[22] = 32'h237c;
  	  mem[23] = 32'h360e;
  	  mem[24] = 32'h2722;
  	  mem[25] = 32'h500;
  	  mem[26] = 32'h16b6;
  	  mem[27] = 32'h29e;
  	  mem[28] = 32'h2280;
  	  mem[29] = 32'h3b52;
	  mem[30] = 32'h11a0;
      mem[31] = 32'h0;
      
      // Filling arrays of instructions and expected results
      instructions[0] = 32'b0000000000000100000100000000001; // Add R0, R1, R2 --> R2 = R0 + R1
      expected_results[0] = mem[0] + mem[1]; 
      
      instructions[1] = 32'b00000000000001010010000011000110; // Sub R3, R4, R5 --> R5 = R3 - R4
      expected_results[1] = mem[3] - mem[4]; 
      
      instructions[2] = 32'b00000000000001110000000110001101; // Abs R6, R7 --> R7 = |R6|
      expected_results[2] = absolute_value(mem[6]); 
      
      instructions[3] = 32'b00000000000010010000001000001000; // Neg R8, R9 --> R9 = -R8
      expected_results[3] = -mem[8]; 
      
      instructions[4] = 32'b00000000000011000101101010000111; // Max R10, R11, R12 --> R12 = Max(R10, R11)
      expected_results[4] = max_value(mem[10], mem[11]); 
      
      instructions[5] = 32'b00000000000011110111001101000100; // Min R13, R14, R15 --> R15 = Min (R13, R14)
      expected_results[5] = min_value(mem[13], mem[14]); 
      
      instructions[6] = 32'b00000000000100101000110000001011; // Avg R16, R17, R18 --> R18 = Avg (R16, R17)
      expected_results[6] = (mem[16] + mem[17]) / 2; 
      
      instructions[7] = 32'b00000000000101000000010011001111; // Not R19, R20 --> R20 = Not(R19)
      expected_results[7] = ~mem[19]; 
      
      instructions[8] = 32'b00000000000101111011010101000011; // OR R21, R22, R23 --> R23 = R21 | R22
      expected_results[8] = mem[21] | mem[22]; 
      
      instructions[9] = 32'b00000000000110101100111000000101; // AND R24, R25, R26 --> R26 = R24 & R25
      expected_results[9] = mem[24] & mem[25]; 
      
      instructions[10] = 32'b00000000000111011110011011000010; // XOR R27, R28, R29 --> R29 = R27 ^ R28
      expected_results[10] = mem[27] ^ mem[28]; 
      
      instructions[11] = 32'b00000000000111011110011011001001; // Additional test instruction on an invalid opcode
      expected_results[11] = mem[27] ^ mem[28]; // Same as the previous result since the opcode is invalid
      
      fail_flag = 0;
      
      // Initialize Clock
      clk = 0;
    end
  
     // Test Procedure
    integer i;
    initial begin
        for (i = 0; i <= 11; i = i + 1) begin
            instruction = instructions[i]; // Load instruction
            #20; // Wait for the result to be computed
            $write("Time=%3d\tInstruction: %b\tResult: %0d\tExpected: %0d\t\t", $time, instruction, result, expected_results[i]);

            if (result != expected_results[i]) begin
               fail_flag = 1;
               $display(" Fail");
            end else begin
               $display(" Pass");
            end
        end

        #10; // Allow time for the final operation to complete
      
      if (fail_flag == 0) begin
        $display("\nAll casses passed the test successfully!\n");
      end
      else begin
        $display("\nAt least one case failed to pass the test successfully!\n");
      end
              
      $finish; 
    end

    always #10 clk = ~clk;
      
endmodule