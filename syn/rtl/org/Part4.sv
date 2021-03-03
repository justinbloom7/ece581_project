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
