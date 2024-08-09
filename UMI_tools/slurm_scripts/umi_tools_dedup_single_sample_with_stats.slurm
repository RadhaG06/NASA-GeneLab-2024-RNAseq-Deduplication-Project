#!/bin/bash
#
#SBATCH --job-name="umi_tools_dedup_test" ## Replace job_name with the name of the job you are running ##
#SBATCH --output=umi_tools_dedup_test_with_stats.out ## Replace job_name with the name of the job you are running ##
#SBATCH --partition=normal ## Specifies the job queue to use, for urgent jobs change normal to priority ##
#SBATCH --mem=20000 ## Memory required to run the job in MB, this example is showing 10,000 MB or 10GB, change this number based on how much RAM you need ##
#SBATCH --cpus-per-task=2 ## Number of CPUs to run the job, this example is showing 5 CPUs, change this number based on how many CPUs you need ##
#
#SBATCH --mail-user=radha.ganesh@nasa.gov ## Specifies the e-mail address to e-mail when the job is complete, replace this e-mail address with your NASA e-mail address ##
#SBATCH --mail-type=END ## Tells slurm to e-mail the address above when the job has completed ##

. ~/.profile


echo "umi_tools_dedup_test" ## Replace job_name with the name of the job you are running ##
echo ""


## Add a time-stamp at the start of the job ##
start=$(date +%s)
echo "start time: $start"

## Print the name of the compute node executing the job ##
echo $HOSTNAME


## Activate the containerized environemnt containing the tools you need to run your job ##
## Containers currently available can be found here: /global/data/Data_Processing/Singularity_Cache/singularity/ ##
## If you need a containerized envrionment not currenlty available, you can upload the respective image to the location indicated above ##
## You will need to create a bash script to activate the environment within the slurm job, similar to the bulkRNASeq_DESeq2.sh example bash script here ##

source /global/data/temp_scratch/banovak/rna_umi/umi_tools.sh ## Replace this with the path to the bash script used to activate your container, see bulkRNASeq_DESeq2.sh for an example of what this file looks like ##


## Print the version of the tool you are using to ensure the tool version is recorded ##
echo ""
echo "Tool version: " ## Replace Tool with the name of the tool you are using ##
umi_tools --version ## Replace this command with the command the tool uses to print its version ##
echo ""


## The command(s) that you want to run in this slurm job ##
umi_tools dedup -I /global/data/temp_scratch/rganesh1/umi_tools_test/single_sample_test/GLDS-511_rna_seq_RRRM1_MG_VIV_LAR_YNG_VL5_Aligned.toTranscriptome_sorted.out.bam \
--paired \
--output-stats=/global/data/temp_scratch/rganesh1/umi_tools_test/Dedup_Stats_Test_Results/test_sample \
-S /global/data/temp_scratch/rganesh1/umi_tools_test/Dedup_Stats_Test_Results/test_sample_deduplicated_with_stats.bam \
-L /global/data/temp_scratch/rganesh1/umi_tools_test/Dedup_Stats_Test_Results/test_sample_deduplicated_with_stats.log \
-E /global/data/temp_scratch/rganesh1/umi_tools_test/Dedup_Stats_Test_Results/test_sample_deduplicated_with_stats.err

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

