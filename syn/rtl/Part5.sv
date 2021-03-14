/* Part5 top level module */

module Part5 #(parameter int FANOUT = 64,
               parameter int IO_SIZE = $clog2(FANOUT))
              (output logic [FANOUT-1:0] outBus,
              input logic [IO_SIZE-1:0] inpBus,
              input logic enable,
              input logic clk);

   logic [FANOUT-1:0] combOut;
   logic criticalOut;

   BigReg #(.FANOUT(FANOUT)) breg (.regOut(outBus),
                                   .regIn( { combOut[FANOUT-1:1], criticalOut }),
                                   .clk);

   CombCloud #(.FANOUT(FANOUT),
               .IO_SIZE(IO_SIZE)) ccloud (.combOut,
                                          .inpBus,
                                          .enable);

   Criticalizer critical0(.result(criticalOut),
                          .inpValue(combOut[0]));

endmodule

module BigReg #(parameter int FANOUT = 16)
               (output logic [FANOUT-1:0] regOut,
                input logic [FANOUT-1:0] regIn,
                input logic clk);

   always_ff @(posedge clk) begin
      regOut <= regIn;
   end

endmodule

/* High-fanout combinational logic */

module CombCloud #(parameter int FANOUT = 16,
                   parameter int IO_SIZE = $clog2(FANOUT))
                  (output logic [FANOUT-1:0] combOut,
                   input logic [IO_SIZE-1:0] inpBus,
                   input logic enable);

   // fanout the enable signal
   genvar idx;
   generate
      for (idx = 0; idx < FANOUT; idx = idx + 1)
         DecodeChk #(.IO_SIZE(IO_SIZE),
                     .CONST_VALUE(idx)) dchk(.result(combOut[idx]),
                                             .inpBus,
                                             .enable);
   endgenerate

endmodule

module DecodeChk #(parameter int IO_SIZE = 1,
                   parameter int CONST_VALUE = 0)
                  (output logic result,
                   input logic [IO_SIZE-1:0] inpBus,
                   input enable);

   assign result = (inpBus == CONST_VALUE) && enable;

endmodule

module Criticalizer(output logic result,
                    input logic inpValue);

   logic [7:0] buffer;

   always_comb begin
      buffer = { 4'b0011, inpValue, 3'b010 };
      result = ^(buffer + 8'b01010100);
   end

endmodule
