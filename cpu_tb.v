`timescale 1ns / 100ps

module cpu_tb;
    reg clk = 0;
    reg reset = 1;
    cpu uut (
        .clk(clk),
        .reset(reset)
    );
    // Clock signal
    always #5 clk = ~clk;
    always begin
      #10;
        $display("R0 = %d", uut.regfile[0]);
        $display("R1 = %d", uut.regfile[1]);
        $display("R2 = %d", uut.regfile[2]);
        $display("PC = %d", uut.PC);
        $display("instr = %b", uut.instr);
        $display("Result at mem[0x13] = %d", uut.memory[19]);
    end
    initial begin
        // === Load program into memory ===
        uut.memory[0]   = 8'h11; 
        uut.memory[1]   = 8'h22; 
        uut.memory[2]   = 8'h99; 
        uut.memory[3]   = 8'h53; 
        uut.memory[4]   = 8'h13; 
        uut.memory[5]   = 8'hD9;
        uut.memory[6]   = 8'h99; 
        uut.memory[7]   = 8'h53; 
        uut.memory[8]   = 8'hC4;
        uut.memory[9]   = 8'hC9;
       	// === Load variables into memory ===
        uut.memory[17]  = 8'd5; 
        uut.memory[18]  = 8'd1;  
        #10 reset = 0;

        #550;
        $finish;
    end
endmodule
