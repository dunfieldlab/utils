#!/usr/bin/env bash


#capturing the basename and initial housekeeping
bn=`echo "$1" | cut -d'.' -f1`
echo $# arguments


#mapping reads in 8 threads

# detecting if reads are R1/R2 or interleaved
if [ $# -eq 2 ]; then
    cmd_str="bowtie2 -x "$bn" --interleaved "$2" -S "$bn".sam -p 8"
elif [ $# -eq 3 ]; then
    cmd_str="bowtie2 -x "$bn" -1 "$2" -2 "$3" -S "$bn".sam -p 8"
else
     echo 'Unexpected number of arguments. Exiting...'
     echo 'Usage: PROGRAM <assembled> <R1> <R2>'
     echo 'OR'
     echo '       RROGRAM <assembled> <interleavedReads>'
     exit 1
fi

#creating index
cmd_str=bowtie2-build" "$1" "$bn
echo $cmd_str
eval $cmd_str
#index created

echo $cmd_str
eval $cmd_str

#converting to bam
cmd_str="samtools view -b -S -@ 8 "$bn".sam -o "$bn".bam"
echo $cmd_str
eval $cmd_str

#sorting bam file
cmd_str="samtools sort -@ 8 "$bn".bam -o "$bn".sorted.bam"
echo $cmd_str
eval $cmd_str

#indexing bam file
cmd_str="samtools index  "$bn".sorted.bam"
echo $cmd_str
eval $cmd_str

#starting metabat
cmd_str="jgi_summarize_bam_contig_depths --outputDepth depth.txt "$bn".sorted.bam"
echo $cmd_str
eval $cmd_str

cmd_str="metabat2 -i "$1" -a depth.txt -o mb2bins/bin --unbinned"
echo $cmd_str
eval $cmd_str

cmd_str="checkm lineage_wf  mb2bins mb2bins_checkm --tab_table -f qa.tsv --reduced_tree -x fa -t 8"
echo $cmd_str
eval $cmd_str
cmd_str="checkm tree_qa mb2bins_checkm -o 2 --tab_table -f detailed_checkm_taxonomy.tsv"
echo $cmd_str
eval $cmd_str