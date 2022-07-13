module sfifo
  (rst,
   clk,
   w_en,
   din,
   r_en,
   dout,
   full,
   empty,
   overflow,
   underflow
   );

  input          rst;
  input          clk;
  input          w_en;
  input  [7:0]   din;
  input          r_en;
  output [7:0]   dout;
  output         full;
  output         empty;
  output         overflow;
  output         underflow;

endmodule
