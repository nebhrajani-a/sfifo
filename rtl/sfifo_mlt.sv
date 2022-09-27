module sfifo_mlt;

  reg          rst;
  reg          clk;
  reg          w_en;
  reg  [7:0]   din;
  reg          r_en;
  wire [7:0]   dout;
  wire         full;
  wire         empty;
  wire         overflow;
  wire         underflow;

sfifo dut
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

  integer      i;

  always
    begin
      clk <= 1'b1;
      #1;
      clk <= 1'b0;
      #1;
    end

  initial
    begin
      $dumpvars;
      rst = 1'b0;
      // w_en = 1'b0;
      r_en = 1'b0;
      repeat(4) @ (posedge clk);
      rst = 1'b1;
      w_en = 1'b1;
      for (i = 0; i < 100; ++i)
        begin
          din = i + 100;
          #2;
          if (i == 63)
            begin
              r_en = 1'b1;
            end
        end
      w_en = 1'b0;
      while (!empty) #2;
      r_en = 1'b0;
      #20;
      $finish;
    end

endmodule
