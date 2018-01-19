#!/bin/sh

mkdir samples_join.fastq
#ls paired/*/*.join.fastq | awk -F '/' '{print ("cp " $0 " ./samples_join.fastq/"substr($2, 1,5)"_join.fastq")}' | bash
#ls paired/*/*.join.fastq | awk -F '/' '{print ("cp " $0 " ./samples_join.fastq/"{ split($2, a, "_") ; print a[1] }"_join.fastq")}'
ls paired/*/*.join.fastq | awk -F '/' '{split( $2, a, "_") ; print("cp " $0 " ./samples_join.fastq/"a[1]"_join.fastq")}' | sh
#testing
#ls paired/*/*.join.fastq | awk -F '/' '{print(substr($2, 1,2))}'
