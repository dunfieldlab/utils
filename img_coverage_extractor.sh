echo -e 'ID\tAvg_fold' > $1contig_coverage.txt

grep "^>" $1 | sed 's/.//'| awk -F "_" '{print($0"\t"$NF)}' >> $1contig_coverage.txt
