
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
      `SFIFO_WR(8'h75);
//      `SFIFO_WR(8'h76);
//      `SFIFO_WR(8'h77);

      `DELAY(3);

      // One more write
      `SFIFO_WR(8'h78);

      // Delay a bit
      `DELAY(10);

      `FINISH;
    end      

endmodule // sfifo_rw_tst
