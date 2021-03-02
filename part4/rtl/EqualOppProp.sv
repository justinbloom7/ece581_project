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
         dummy = dummy + 1;
   end

endmodule;
