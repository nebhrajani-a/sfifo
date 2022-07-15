//------------------------------------------------------------------------------
// Header with some basic tick defines for constants and tasks/functions
//
// Author: Vijay A. Nebhrajani
// Email:  vijay.nebhrajani@gmail.com
// Date:   July 12, 2022
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Constants
//----------------------------------------------------------------------
`define ON  1
`define OFF 0

//----------------------------------------------------------------------
// Functions/Tasks
//----------------------------------------------------------------------
`define SFIFO_INIT    sfifo_tb.init
`define SFIFO_WR      sfifo_tb.wrfifo
`define SFIFO_CHK_EN  sfifo_tb.fifo_chk_en
`define DELAY         sfifo_tb.delay
`define FINISH        sfifo_tb.endsim
