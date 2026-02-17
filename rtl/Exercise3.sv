module Exercise3 (
    input  logic        clk,
    input  logic        nReset,   // active-low reset
    input  logic [3:0]  a,
    input  logic [15:0] b,
    input  logic [15:0] c,
    output logic [15:0] out
);

  // ---------------------------------------------------------------------------
  // mystery1: combinational byte function
  // ---------------------------------------------------------------------------
  function automatic logic [7:0] mystery1(input logic [1:0] a2,
                                          input logic [7:0] b8,
                                          input logic [7:0] c8);
    begin
      unique case (a2)
        2'd0: mystery1 = b8;
        2'd1: mystery1 = {b8[3:0], c8[7:4]}; // (b << 4) | (c >> 4)
        2'd2: mystery1 = c8;
        default: begin
          // default: ((a & 0x7) << 6) | ((c & 0x7) << 3) | (b & 0x7)
          // Here a2 is only 2 bits, so (a2 & 3) is fine; it becomes bits [7:6].
          mystery1 = {a2, c8[2:0], b8[2:0]};
        end
      endcase
    end
  endfunction

  // Inputs to Mystery2
  logic [7:0] a_in, b_in;

  always_comb begin
    a_in = mystery1(a[1:0], b[7:0],  c[7:0]);
    b_in = mystery1(a[3:2], b[15:8], c[15:8]);
  end

  // ---------------------------------------------------------------------------
  // Mystery2: sequential state + 2-bit mod-4 counter
  // ---------------------------------------------------------------------------
  logic [1:0] count;

  always_ff @(posedge clk) begin
    if (!nReset) begin
      out   <= {a_in, b_in};
      count <= 2'd0;
    end else begin
      unique case (count)
        2'd0: begin
          // out = ((out & 0xFF) << 8) | (out >> 8)  (swap bytes)
          out <= {out[7:0], out[15:8]};
        end
        2'd1: begin
          // out = ((out & 0xFF) << 8) | a
          out <= {out[7:0], a_in};
        end
        2'd2: begin
          // out = (b << 8) | (out >> 8)
          out <= {b_in, out[15:8]};
        end
        default: begin
          // out = (out << 12) | ((out & 0xF0) << 4) | ((out >> 4) & 0xF0) | (out >> 12)
          // This permutes nibbles exactly like the C++.
          out <= { out[3:0], out[7:4], out[11:8], out[15:12] };
        end
      endcase

      count <= count + 2'd1; // mod-4 automatically
    end
  end

endmodule
