files=""


for file in `ls *.fa`
do
   name=`echo "$file" | cut -d'.' -f1-2`
   command_str='blastall -p blastn -d nt/nt -i '$file' -o '$name'.xml -e 1e-10 -m 7 -a 4 -K 100 -b 200'
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
