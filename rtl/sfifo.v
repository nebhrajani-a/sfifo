//--------------------------------------------------------------------------------
// (c) Nebhrajani
// Description: Top level module for sfifo
//--------------------------------------------------------------------------------

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

  //----------------------------------------------------------------------
  // I/O
  //----------------------------------------------------------------------
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

  // Flopouts
  reg [7:0]      dout;
  reg            full;
  reg            empty;
  reg            overflow;
  reg            underflow;

  //----------------------------------------------------------------------
  // Local wires, regs
  //----------------------------------------------------------------------

  reg [7:0]      fifo [63:0];
  reg [5:0]      write_ptr;
  reg [5:0]      read_ptr;
  reg [6:0]      word_cnt;

  // Flopins
  reg            w_en_reg;
  reg [7:0]      din_reg;
  reg            r_en_reg;

  //----------------------------------------------------------------------
  // Flopin logic
  //----------------------------------------------------------------------
  always @(posedge clk or negedge rst)
    begin
      if (rst == 1'b0)
        begin
          w_en_reg <= 1'b0;
          din_reg  <= 'h0;
          r_en_reg <= 1'b0;
        end
      else
        begin
          w_en_reg <= w_en;
          din_reg  <= din;
          r_en_reg <= r_en;
        end
    end

  //----------------------------------------------------------------------
  // FIFO Logic
  //----------------------------------------------------------------------
  always @(posedge clk or negedge rst)
    begin
      // Reset logic
      if (rst == 1'b0)
        begin
          write_ptr <= 'h0;
          read_ptr  <= 'h0;
          word_cnt <= 'h0;
          dout      <= 'h0;
          overflow  <= 1'b0;
          underflow <= 1'b0;
          empty     <= 1'b1;
          full      <= 1'b0;
        end
      else
        begin

          // Write logic
          if ((w_en_reg == 1'b1) && (r_en_reg == 1'b0))
            begin
              if (word_cnt !== 7'd64)
                begin
                  fifo[write_ptr] <= din_reg;
                  write_ptr <= write_ptr + 1'b1;
                  empty <= 1'b0;
                  word_cnt <= word_cnt + 1'b1;
                end
              else
                begin
                  overflow <= 1'b1;
                end
            end // if ((w_en_reg == 1'b1) && (r_en_reg == 1'b0))

          // Read logic
          if ((r_en_reg == 1'b1) && (w_en_reg == 1'b0) && (empty == 1'b0))
            begin
              if (word_cnt !== 7'd0)
                begin
                  dout <= fifo[read_ptr];
                  read_ptr <= read_ptr + 1'b1;
                  empty <= (word_cnt == 7'd1) ? 1'b1 : 1'b0;
                  word_cnt <= word_cnt - 1'b1;
                end
              else
                begin
                  underflow <= 1'b1;
                end // else: !if(word_cnt !== 7'd0)
            end // if ((r_en_reg == 1'b1) && (w_en_reg == 1'b0))

          // Read && write logic
          if ((r_en_reg == 1'b1) && (w_en_reg == 1'b1))
              begin
                if (empty == 1'b1)
                  begin
                    word_cnt <= 7'd1;
                    fifo[write_ptr] <= din_reg;
                    write_ptr <= write_ptr + 1'b1;
                    empty <= 1'b0;
                  end
                else
                  begin
                    fifo[write_ptr] <= din_reg;
                    write_ptr <= write_ptr + 1'b1;
                    dout <= fifo[read_ptr];
                    read_ptr <= read_ptr + 1'b1;
                  end
              end
        end // else: !if(rst == 1'b0)
    end // always @ (posedge clk or negedge rst)

endmodule
