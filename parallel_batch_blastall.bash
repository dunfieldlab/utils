#!/bin/bash
parallel -j $1 blastall "-p blastn -d nt/nt -i "{}" -o "{.}".xml -e 1e-10 -m 7 -a 1 -K 100 -b 200" ::: *.fa
