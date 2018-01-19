#!/bin/bash
declare -a input_samples=(
samples_join.fastq/gl1_join.fastq
samples_join.fastq/gl2_join.fastq
samples_join.fastq/gl2-1_join.fastq
samples_join.fastq/gl2-2_join.fastq
samples_join.fastq/gl2-3_join.fastq
samples_join.fastq/gl2-4_join.fastq
samples_join.fastq/gl2-5_join.fastq
samples_join.fastq/gl2-6_join.fastq
samples_join.fastq/gl2-7_join.fastq
samples_join.fastq/m1_join.fastq
samples_join.fastq/m1-1_join.fastq
samples_join.fastq/m1-2_join.fastq
samples_join.fastq/m1-3_join.fastq
samples_join.fastq/m1-4_join.fastq
samples_join.fastq/nm22_join.fastq
samples_join.fastq/nm22f0_join.fastq
samples_join.fastq/nm22f1_join.fastq
samples_join.fastq/nm22f2_join.fastq
samples_join.fastq/nm22f3_join.fastq
samples_join.fastq/nm35_join.fastq
samples_join.fastq/dc*0-3-5_join.fastq
samples_join.fastq/dc*1-3-5_join.fastq
samples_join.fastq/dc*2-3-5_join.fastq
samples_join.fastq/dc03-5_join.fastq
samples_join.fastq/dc3-5_join.fastq)

declare -a input_ids=(
gl1
gl2
gl2-1
gl2-2
gl2-3
gl2-4
gl2-5
gl2-6
gl2-7
m1
m1-1
m1-2
m1-3
m1-4
nm22
nm22f0
nm22f1
nm22f2
nm22f3
nm35
dc*0-3-5
dc*1-3-5
dc*2-3-5
dc03-5
dc3-5)


arraylength=${#input_samples[@]}

i=0
for (( i = 0 ; i < ${arraylength} ; i++ ))
do
    #echo "cp " ${files[$i-1]} $dirname"/"${ids[$i-1]}"_join.fastq"
    #cp ${files[$i-1]} $dirname"/"${ids[$i-1]}"_join.fastq"
    id=${input_ids[$i]}
    file=${input_samples[$i]}
    #echo $i " / " ${arraylength} " : " ${files[$i-1]} " : " ${ids[$i-1]}



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

#for file in samples_join.fastq/*

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
eval $command_str
