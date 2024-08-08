#!/bin/bash
#
#SBATCH --job-name="fgbio_remove_umi" ## Replace job_name with the name of the job you are running ##
#SBATCH --output=511_rna_seq_RRRM1_MG_FLT_LAR_OLD_FL3_Aligned.toTranscriptome_umi_removed.out ## Replace job_name with the name of the job you are running ##
#SBATCH --partition=normal ## Specifies the job queue to use, for urgent jobs change normal to priority ##
#SBATCH --mem=20000 ## Memory required to run the job in MB, this example is showing 10,000 MB or 10GB, change this number based on how much RAM you need ##
#SBATCH --cpus-per-task=5 ## Number of CPUs to run the job, this example is showing 5 CPUs, change this number based on how many CPUs you need ##
#
#SBATCH --mail-user=dat.l.ho@nasa.gov ## Specifies the e-mail address to e-mail when the job is complete, replace this e-mail address with your NASA e-mail address ##
#SBATCH --mail-type=END ## Tells slurm to e-mail the address above when the job has completed ##

. ~/.profile


echo "fgbio_remove_umi" ## Replace job_name with the name of the job you are running ##
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

source /global/data/temp_scratch/banovak/rna_umi/fgbio.sh ## Replace this with the path to the bash script used to activate your container, see bulkRNASeq_DESeq2.sh for an example of what this file looks like ##

## Print the version of the tool you are using to ensure the tool version is recorded ##
echo ""
echo "fgbio version: " ## Replace Tool with the name of the tool you are using ##
fgbio --version ## Replace this command with the command the tool uses to print its version ##
echo ""


## The command(s) that you want to run in this slurm job ##
fgbio CopyUmiFromReadName \
--input=/global/data/temp_scratch/atorre31/scratch/GLDS-511/GLDS-511_rna_seq_RRRM1_MG_FLT_LAR_OLD_FL3_Aligned.toTranscriptome.out.bam \
--output=511_rna_seq_RRRM1_MG_FLT_LAR_OLD_FL3_Aligned.toTranscriptome_umi_removed.out.bam \
--remove-umi=true \
--field-delimiter=_
 ## Replace command with the command(s) you want to run ##


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