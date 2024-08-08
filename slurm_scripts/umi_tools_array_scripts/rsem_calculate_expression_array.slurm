#!/bin/bash
#
#SBATCH --job-name="rsem_calculate_expression"
#SBATCH --output=slurm_output/rsem_calculate_expression/rsem_calculate_expression_%A_%a.out
#SBATCH --partition=normal
#SBATCH --mem=20000 ## Memory required to run the job in MB (using 20GB) ##
#SBATCH --cpus-per-task=5
#SBATCH --array=1-43%15 ## there are 43 total samples in dataset ##
#
#SBATCH --mail-user=radha.ganesh@nasa.gov
#SBATCH --mail-type=END

. ~/.profile


echo "rsem_calculate_expression"
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



## Activate the conda environemnt containing rsem ##

source activate /global/smf/miniconda38_admin/envs/rsem_v1.3.3

in_dir=/global/data/temp_scratch/rganesh1/dedup_osd_511/processed_files/rsem_prep_results/prepped_files
out_dir=/global/data/temp_scratch/rganesh1/dedup_osd_511/processed_files/rsem_output
ref_dir=/global/data/temp_scratch/banovak/rna_umi/Mus_musculus.GRCm39.dna.primary_assembly_and_ERCC92


## If each job is being run on a set of samples, assign each sample to a job array id number ##
sample=$(cat samples.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)
echo ""

## Print the sample name the job is being executed on ##
echo "SAMPLE: ${sample}"

## Print the version of the tool you are using to ensure the tool version is recorded ##
echo ""
echo "rsem version: "
rsem --version
echo ""


call_rsem="rsem-calculate-expression --alignments --bam --paired-end --seed 12345 \
--seed-length 20 --estimate-rspd --no-bam-output --strandedness forward \
$in_dir/${sample}_Aligned.toTranscriptome_deduplicated_prepped.bam \
$ref_dir/Mmus $out_dir/${sample}"

echo $call_rsem ## printing the full command that is going to be called, for troubleshooting later ##
echo ""
eval $call_rsem
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

