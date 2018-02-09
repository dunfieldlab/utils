echo -e 'ID\tAvg_fold' > contig_coverage.txt

grep "^>" scaffolds.fasta | sed 's/.//'| awk -F "_" '{print($0"\t"$NF)}' >> contig_coverage.txt