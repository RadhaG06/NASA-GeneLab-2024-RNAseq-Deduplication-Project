#!/bin/bash
#
#SBATCH --job-name="download_from_OSDR"
#SBATCH --output=download_from_OSDR_%A.out
#SBATCH --partition=normal
#SBATCH --mem=36000
#SBATCH --cpus-per-task=8
#
#SBATCH --mail-user=barbara.a.novak@nasa.gov
#SBATCH --mail-type=END
 
. ~/.profile
 
echo "download_from_OSDR"
echo ""
 
start=$(date +%s)
echo "start time: $start"
echo ""
echo $HOSTNAME

eval "$(conda shell.bash hook)"
conda activate /global/smf/miniconda38_admin/envs/genelab-utils

## Define file paths ##
outdir="$1"
OSD="$2"
assay_table="$3"

mkdir -p $outdir

## run genelab-utils download command
GL-download-GLDS-data -f -o ${outdir} -a ${assay_table} -g ${OSD}

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
echo "slurm job ID: ${SLURM_JOB_ID}"
