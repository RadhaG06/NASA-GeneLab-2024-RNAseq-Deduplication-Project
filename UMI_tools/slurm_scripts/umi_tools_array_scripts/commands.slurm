  
   samtools sort \
   input.bam \
   -o output_sorted.bam
   
   samtools index \
   input_sorted.bam
   
   
   umi_tools dedup \
   -I input_sorted.bam \
   --paired \
   -S output_deduplicated.bam \
   -L log_file.log \
   -E error_file.err


   samtools collate \
   -o output_sorted.bam \
   input.bam
   
   umi_tools prepare-for-rsem \
   -I input_deduplicated_sorted.bam \
   -S output.bam \
   -L log_file.log \
   -E error_file.err
   
   
   
   