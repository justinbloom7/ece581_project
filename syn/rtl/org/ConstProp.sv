module ConstProp(output logic outA,
                 input logic inpA,
                 input logic inpB,
                 input logic inpC);

   assign outA = (inpA || inpB) && inpC;

endmodule;
