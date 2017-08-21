files="RoshanpmoCAB_alignmentForAndriy_noGaps"


for file in $files
do
   name=`echo "$file" | cut -d'.' -f1`
   command_str='blastp -db nr/nr -query '$file' -out '$name'.xml -evalue 1e-100 -outfmt "6 qseqid sseqid evalue bitscore sgi sacc staxids sscinames scomnames stitle" -num_threads 4 -max_target_seqs 1'
   echo $command_str
   eval $command_str
done
