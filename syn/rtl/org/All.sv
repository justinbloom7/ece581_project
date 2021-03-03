module Part4(output logic [4:0] outBus,
             input logic [5:0] inpBus,
             input logic clk,
             input logic reset);

   ConstProp cp(.outA(outBus[4]),
                .inpA(inpBus[5]),
                .inpB(1'b0),
                .inpC(inpBus[4]));

   EqualOppProp eop(.outA(outBus[3]),
                    .outB(outBus[2]),
                    .inpA(inpBus[3]),
                    .inpB(!inpBus[3]),
                    .clk,
                    .reset);

   UnconnProp up(.outA(outBus[1]),
                 .inpA(inpBus[2] && inpBus[1]),
                 .clk,
                 .reset);

   InvPush invP(.outA(outBus[0]),
                .inpA(!inpBus[0]),
                .clk,
                .reset);

endmodule
module ConstProp(output logic outA,
                 input logic inpA,
                 input logic inpB,
                 input logic inpC);

   assign outA = (inpA || inpB) && inpC;

endmodule;
module EqualOppProp(output logic outA,
                    output logic outB,
                    input logic inpA,
                    input logic inpB,
                    input logic clk,
                    input logic reset);

   logic [1:0] dummy;

   assign outA = !inpA && dummy[1];
   assign outB = dummy[0] && inpB;

   always_ff @(posedge clk, posedge reset) begin
      if (reset)
         dummy <= 2'b0;
      else
         dummy <= dummy + 1;
   end

endmodule;
module InvPush(output logic outA,
               input logic inpA,
               input logic clk,
               input logic reset);

   logic dummy;

   assign outA = !inpA && dummy;

   always_ff @(posedge clk, posedge reset) begin
      if (reset)
         dummy <= 1'b0;
      else
         dummy <= !dummy;
   end

endmodule;
module UnconnProp(output logic outA,
                  input logic inpA,
                  input logic clk,
                  input logic reset);

   logic dummy;

   assign outA = dummy;

   always_ff @(posedge clk, posedge reset) begin
      if (reset)
         dummy <= 1'b0;
      else
         dummy <= !dummy;
   end

endmodule;
