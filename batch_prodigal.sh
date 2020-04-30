for file in *.fa
do
   name=`echo "$file" | cut -d'.' -f123`
   command_str="prodigal -i "$file" -a "$file".faa"
   echo $command_str
   eval $command_str
done
