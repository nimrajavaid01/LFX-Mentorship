module stack #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  logic clk,
    input  logic rst_n,

    input  logic push,
    input  logic pop,
    input  logic peek,  

    input  logic [DATA_WIDTH-1:0] data_in,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic empty,
    output logic full
);

  // Internal memory and stack pointer
  logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
  logic [ADDR_WIDTH:0] sp; // One extra bit to detect overflow

  //  logic
  assign empty = (sp == 0);
  assign full  = (sp == DEPTH);

  // Output for peek (top of the stack)
  assign data_out = (!empty) ? mem[sp - 1] : '0;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      sp <= 0;
    end else begin
      case ({push, pop})
        2'b10: begin // Push
          if (!full) begin
            mem[sp] <= data_in;
            sp <= sp + 1;
          end
        end
        2'b01: begin // Pop
          if (!empty) begin
            sp <= sp - 1;
          end
        end
        2'b11: begin // Simultaneous push & pop
          if (!empty && !full) begin
            mem[sp - 1] <= data_in; // Replace top
          end
        end
        default: ; 
      endcase
    end
  end

endmodule
