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
