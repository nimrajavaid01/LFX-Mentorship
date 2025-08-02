module tb_stack;

  parameter DATA_WIDTH = 8;
  parameter DEPTH = 4;

  logic clk, rst_n, push, pop, peek;
  logic [DATA_WIDTH-1:0] data_in;
  logic [DATA_WIDTH-1:0] data_out;
  logic empty, full;

  stack #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) dut (
    .clk(clk), .rst_n(rst_n),
    .push(push), .pop(pop), .peek(peek),
    .data_in(data_in),
    .data_out(data_out),
    .empty(empty), .full(full)
  );

  // Clock generator
  always #5 clk = ~clk;

  initial begin
    $display("Starting Testbench...");
    clk = 0;
    rst_n = 0;
    push = 0; pop = 0; peek = 0;
    data_in = 0;

    // Reset
    #10 rst_n = 1;

    // Push elements
    repeat (DEPTH) begin
      @(posedge clk);
      push = 1; pop = 0;
      data_in = $random;
    end

    // Test full condition
    @(posedge clk);
    if (!full) $display("ERROR: Stack should be full");

    // Peek
    peek = 1;
    @(posedge clk);
    peek = 0;
    $display("Top Element (peeked): %0d", data_out);

    // Pop all
    repeat (DEPTH) begin
      @(posedge clk);
      push = 0; pop = 1;
    end

    // Test empty condition
    @(posedge clk);
    if (!empty) $display("ERROR: Stack should be empty");

    // Simultaneous push & pop
    @(posedge clk);
    push = 1; pop = 1;
    data_in = 55;

    @(posedge clk);
    peek = 1;
    @(posedge clk);
    $display("After simultaneous push/pop, top is: %0d", data_out);

    $display("Test completed.");
    $stop;
  end
endmodule
