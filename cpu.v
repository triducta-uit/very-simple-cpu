module cpu (
    input clk,
    input reset);
    reg [7:0] PC;
    reg [7:0] regfile[0:3];             
    reg [7:0] memory[0:31];      
    reg [7:0] alu_result;             
    reg jump;
    wire [7:0] PC_next = PC + 1;
    wire [7:0] PC_jump = {4'b0000, imm4};
    wire [7:0] PC_new = ((opcode == 2'd11)&(regfile[regA] == 8'd0))?PC_jump:PC_next;
    wire [7:0] instr = memory[PC];   // đọc lệnh từ bộ nhớ
    wire [1:0] opcode = instr[7:6];    // phân vùng mã lệnh
    wire [1:0] regA   = instr[5:4];      // phân vùng địa chỉ reg đích
    wire [1:0] regB   = instr[3:2];      // phân vùng địa chỉ reg nguồn
    wire [1:0] func   = instr[1:0];      // phân vùng địa chỉ mã chức năng
    wire [3:0] imm4   = instr[3:0];    // phân vùng địa chỉ mem/nhảy
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 8'd0;
            regfile[0] <= 0;
        end else begin
            PC <= PC_new; 
            jump <= 0;
        case (opcode)
                2'b00: begin // LD reg, [imm]
                    regfile[regA] <= memory[{4'b0001, imm4}];  
                end
                2'b01: begin // ST reg, [imm]
                    memory[{4'b0001, imm4}] <= regfile[regA];  
                end
                2'b10: begin // ALU
                    case (func)
                        2'b00: alu_result = regfile[regA] + regfile[regB]; // ADD
                        2'b01: alu_result = regfile[regA] - regfile[regB]; // SUB
                        2'b10: alu_result = regfile[regA] & regfile[regB]; // AND
                        2'b11: alu_result = regfile[regA] ^ regfile[regB]; // XOR
                    endcase
                    regfile[regA] <= alu_result;
                end
                2'b11: begin // JZ regA, imm
                  if (regfile[regA] == 8'd0) begin
                        jump <= 1;  
                  end else jump <= 0;
                end
            endcase
        end
    end
endmodule

