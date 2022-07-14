#!/bin/tcsh

if (-e a.out) then
  \rm -f a.out
endif

set logs = `ls | grep log | wc -l`
if ($logs != 0) then
  \rm -f *.log
endif

set dumps = `ls | grep vcd | wc -l`    
if ($dumps != 0) then
  \rm -f *.vcd
endif

exit 0

