/* Part4 top level module */

module Part4(output logic [4:0] outBus,
             input logic [5:0] inpBus,
             input logic clk,
             input logic reset);

   ConstPropC constProp(.outA(outBus[4]),
                        .inpA(inpBus[5]),
                        .inpB(inpBus[4]));

   EqualOppPropC equalOppProp(.outA(outBus[3]),
                              .outB(outBus[2]),
                              .inpA(inpBus[3]),
                              .clk,
                              .reset);

   UnconnPropC unconnProp(.outA(outBus[1]),
                          .inpA(inpBus[2]),
                          .inpB(inpBus[1]),
                          .clk,
                          .reset);

   InvPushC invPush(.outA(outBus[0]),
                    .inpA(inpBus[0]),
                    .clk,
                    .reset);

endmodule

/* Constants across hierarchy */

module ConstPropC(output logic outA,
                  input logic inpA,
                  input logic inpB);

   ConstProp cp(.outA,
                .inpA,
                .inpG(1'b0),
                .inpB);

endmodule

module ConstProp(output logic outA,
                 input logic inpA,
                 input logic inpG,
                 input logic inpB);

   assign outA = (inpA || inpG) && inpB;

endmodule

/* Propagation of equal and opposite information */

module EqualOppPropC(output logic outA,
                     output logic outB,
                     input logic inpA,
                     input logic clk,
                     input logic reset);

   EqualOppProp eop(.outA,
                    .outB,
                    .inpA,
                    .inpB(!inpA),
                    .clk,
                    .reset);

endmodule

module EqualOppProp(output logic outA,
                    output logic outB,
                    input logic inpA,
                    input logic inpB,
                    input logic clk,
                    input logic reset);

   localparam RSIZE = 2;

   logic [RSIZE-1:0] dummy;

   assign outA = !inpA && dummy[1];
   assign outB = dummy[0] && inpB;

   DummyLogic #(.RSIZE(RSIZE)) dl(.dummy,
                           .clk,
                           .reset);

endmodule

/* Propagation of unconnected port information */

module UnconnPropC(output logic outA,
                   input logic inpA,
                   input logic inpB,
                   input logic clk,
                   input logic reset);

   UnconnProp up(.outA,
                 .inpA(inpA && inpB),
                 .clk,
                 .reset);

endmodule

module UnconnProp(output logic outA,
                  input logic inpA,
                  input logic clk,
                  input logic reset);

   logic dummy;

   assign outA = dummy;

   DummyLogic dl(.dummy,
                 .clk,
                 .reset);

endmodule;

/* Pushing of inverters across hierarchy */

module InvPushC(output logic outA,
                input logic inpA,
                input logic clk,
                input logic reset);

   InvPush invP(.outA,
                .inpA(!inpA),
                .clk,
                .reset);

endmodule

module InvPush(output logic outA,
               input logic inpA,
               input logic clk,
               input logic reset);

   logic dummy;

   assign outA = !inpA && dummy;

   DummyLogic dl(.dummy,
                 .clk,
                 .reset);

endmodule

/* Make the dummy logic into separate blocks (for visual reasons only) */

module DummyLogic #(parameter int RSIZE = 1)
                   (output logic [RSIZE-1:0] dummy,
                    input logic clk,
                    input logic reset);

   always_ff @(posedge clk, posedge reset) begin : setDummyVal
      if (reset)
         dummy <= '0;
      else
         dummy <= dummy + 1;
   end : setDummyVal

endmodule
