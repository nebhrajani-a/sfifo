#!/bin/tcsh

#------------------------------------------------------------------------------
# Script to clean up a run area
# Removes a.out, the executable from iverilog if it exists
# Removes any .log files if they exist
# Removes any .vcd dumps if they exist
#
# The name of this file is with an extension .sh - the idea being that this
# isn't a script a user calls directly; it is called by other scripts.
#
# Author: Vijay A. Nebhrajani
# Email:  vijay.nebhrajani@gmail.com
# Date:   July 15, 2022
#------------------------------------------------------------------------------


# If it exists, delete a.out
if (-e a.out) then
  \rm -f a.out
endif

# If logs exist, delete them
set logs = `ls | grep log | wc -l`
if ($logs != 0) then
  \rm -f *.log
endif

# If VCD dumps exist, delete them
set dumps = `ls | grep vcd | wc -l`    
if ($dumps != 0) then
  \rm -f *.vcd
endif

exit 0

