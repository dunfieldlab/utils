files="dmpB.fasta
dmpC.fasta
dmpD.fasta
dmpH.fasta
dmpK.fasta
mhpD.fasta
mhpE.fasta
mhpF.fasta
nahAc.fasta
nahC.fasta
nahD.fasta
nahE.fasta
nahF.fasta
praC.fasta
sal-hyd.fasta
todC1.fasta"


for file in $files
do
   name=`echo "$file" | cut -d'.' -f1`
   command_str='blastn -db ../nt/nt -query '$file' -out '$name'.xml -evalue 1e-10 -outfmt 5 -num_threads 8 -max_target_seqs 100'
   echo $command_str
   eval $command_str
#   #echo $location
#   ref_opt=" -r "$ref
#   #echo "elif clause triggered"
#   #echo $chunk_size
#   eval 'python '$filename' -n '$location' '$ref_opt' '$req_opt' '$alen_opt' '$iden_opt' '$e_val_opt' '$shear_opt' '$format_opt
#   c=$(($c+1))
##           if [ "$c" -gt "$iterations" ]
##                then
##                exit
##           fi
done
