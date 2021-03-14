module Part7(output logic result,
             input logic storeVal,
             input logic clk,
             input logic nset);

   always_ff @(posedge clk, negedge nset)
      if (!nset)
         result <= 1'b1;
      else
         result <= storeVal;

endmodule
