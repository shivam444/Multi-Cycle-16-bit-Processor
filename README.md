# Multi-Cycle-16-bit-Processor
A 16-bit multi cycle processor, with RISC-V instructions. Supports R-format, BNEG, LOAD, STORE instruction.

Instruction format:
1. rformat: {opcode[1:0], alu_op[1:0], rd[3:0], rs1[3:0], rs2[3:0]}
2. bneg: {opcode[1:0], alu_op[1:0], offset[3:0], rs1[3:0], rs2[3:0]}
3. load: {opcode[1:0], alu_op[1:0], rd[3:0], offset[3:0], rs1[3:0]};
4. store: {opcode[1:0], alu_op[1:0], offset[3:0], rs1[3:0], rs2[3:0]}

Opcodes:
1. rformat: 00
2. bneg: 01
3. load: 10
4. store: 11

ALU operation
1. add: 00
2. sub: 01
3. or: 10
4. and: 11
