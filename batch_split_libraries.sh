#!/bin/bash
samples=""
ids=""
for file in samples_join.fastq/*
do
   id=`echo "$file" | awk -F "/" '{print ($NF)}'| awk '{split($0,a,"_", seps)};{print a[1]}'`
    
    #echo $file
    #echo $id
    if [[ -z "$samples" ]]
    then
        samples=$file
    else
        samples=$samples","$file
    fi
    
    if [[ -z "$ids" ]]
    then
        ids=$id
    else
        ids=$ids","$id
    fi
done

command_str='split_libraries_fastq.py -i '$samples' -o quality_controlled_Samples --sample_ids '$ids' -q 19 --barcode_type not-barcoded'
   #echo $command_str
   #eval $command_str
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

echo $command_str
#eval $command_str
