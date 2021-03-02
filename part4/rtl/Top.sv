module Top();

   localparam PERIOD = 10;
   localparam RESET_CYCLES = 2;
   localparam TEST_CYCLES = 100;

   logic [4:0] outBus;
   logic [5:0] inpBus;
   logic clk, reset;

   Connector dut(.*);

   always @(posedge clk, posedge reset) begin : loopInputs
      if (reset)
         inpBus <= '0;
      else
         inpBus <= inpBus + 1;
   end : loopInputs

   initial begin : clkGen
      clk = 1'b0;
      forever #(PERIOD / 2) clk = !clk;
   end : clkGen

   initial begin : testProc
      reset = 1'b0;
      @(negedge clk);
      reset = 1'b1;
      repeat (RESET_CYCLES) @(negedge clk);
      reset = 1'b0;

      repeat (TEST_CYCLES) @(posedge clk);

      $stop;
   end : testProc

   initial begin : displayValues
      $monitor("%b -> %b", inpBus, outBus);
   end : displayValues

endmodule
