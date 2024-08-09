#!/bin/bash
#
#SBATCH --job-name="umi_tools_dedup"
#SBATCH --output=slurm_output/umi_tools_dedup/umi_tools_dedup_%A_%a.out
#SBATCH --partition=normal
#SBATCH --mem=60000 ## Memory required to run the job in MB (using 60GB) ##
#SBATCH --cpus-per-task=5
#SBATCH --array=1-43%10 ## there are 43 total samples in dataset ##
#
#SBATCH --mail-user=radha.ganesh@nasa.gov
#SBATCH --mail-type=END

. ~/.profile


echo "umi_tools_dedup"
echo ""


## Add a time-stamp at the start of the job ##
start=$(date +%s)
echo "start time: $start"

## Print the name of the compute node executing the job ##
echo $HOSTNAME
echo ""

## Print the slurm array job number being executed ##
echo "My SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID
echo ""



## Activate the containerized environemnt containing umi_tools ##

source /global/data/temp_scratch/banovak/rna_umi/umi_tools.sh

in_dir=/global/data/temp_scratch/rganesh1/dedup_osd_511/processed_files/sorted_indexed_alignment_files
out_dir=/global/data/temp_scratch/rganesh1/dedup_osd_511/processed_files/deduplication_results

## If each job is being run on a set of samples, assign each sample to a job array id number ##
sample=$(cat samples.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)
echo ""

## Print the sample name the job is being executed on ##
echo "SAMPLE: ${sample}"

## Print the version of the tool you are using to ensure the tool version is recorded ##
echo ""
echo "umi_tools version: "
umi_tools --version
echo ""


## Storing the command as a variable ##
call_dedup="umi_tools dedup -I $in_dir/${sample}_Aligned.toTranscriptome_sorted.out.bam \
--paired \
-S $out_dir/deduplicated_files/${sample}_Aligned.toTranscriptome_deduplicated.out.bam \
-L $out_dir/log_files/${sample}_Aligned.toTranscriptome_deduplicated.out.log \
-E $out_dir/error_files/${sample}_Aligned.toTranscriptome_deduplicated.out.err"

echo $call_dedup ## printing the full command that is going to be called, for troubleshooting later ##
echo ""
eval $call_dedup
echo ""


## Add a time-stamp at the end of the job then calculate how long the job took to run in seconds, minutes, and hours ##
echo ""
end=$(date +%s)
echo "end time: $end"
runtime_s=$(echo $(( end - start )))
echo "total run time(s): $runtime_s"
sec_per_min=60
sec_per_hr=3600
runtime_m=$(echo "scale=2; $runtime_s / $sec_per_min;" | bc)
echo "total run time(m): $runtime_m"
runtime_h=$(echo "scale=2; $runtime_s / $sec_per_hr;" | bc)
echo "total run time(h): $runtime_h"
echo ""


## Print the slurm job ID so you have it recorded and can view slurm job statistics if needed ##
echo "slurm job ID: ${SLURM_JOB_ID}"

