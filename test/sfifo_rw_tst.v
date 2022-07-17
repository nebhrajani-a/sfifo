
`include "../sim/sfifo_sim.vh"

module sfifo_rw_tst;

  initial
    begin
      $dumpvars;
      
      // Initialize (reset etc)
      `SFIFO_INIT;

      // Enable read and check
      `SFIFO_CHK_EN(`ON);

      // Perform three writes
     `SFIFO_WR($random);
     `SFIFO_WR($random);
     `SFIFO_WR($random);

      `DELAY(5);

      // One more write
      `SFIFO_WR($random);

      // Delay a bit
      `DELAY(10);

      `FINISH;
    end      

endmodule // sfifo_rw_tst
