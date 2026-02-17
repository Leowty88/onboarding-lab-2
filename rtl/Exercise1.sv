/**
  @brief A simple ALU-like module

  @input op   opcode for the operation to perform
  @input a    input to calculation
  @input b    input to calulation
  @output out result of calculation
*/
module Exercise1 (
    input  logic [1:0] op,
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [7:0] out
);

always_comb begin
  unique case (op)
    2'd0: out = a + b;
    2'd1: out = a - b;
    2'd2: out = a & b;
    2'd3: out = a | b;
    default: out = '0;
  endcase
end

endmodule
