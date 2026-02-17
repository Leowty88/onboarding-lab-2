/**
  @brief A fibonacci linear feedback shift register module

  @input clk    clock
  @input nReset active-low reset
  @input init   initial value following a reset
  @output out   current output
*/
module Exercise2 (
    input  logic        clk,
    input  logic        nReset,
    input  logic [15:0] init,
    output logic [15:0] out
);

  logic [15:0] value;
  logic        feedback;

  // mask = 16'hB400 -> taps at bits 15, 13, 12, 10
  // feedback is parity (XOR) of those tapped bits
  assign feedback = value[15] ^ value[13] ^ value[12] ^ value[10];

  always_ff @(posedge clk) begin
    if (!nReset) begin
      value <= init;
    end else begin
      // left shift, insert feedback into bit 0
      value <= {value[14:0], feedback};
    end
  end

  assign out = value;

endmodule
