#!/bin/bash
#SBATCH --job-name=integron
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=48:00:00
#SBATCH --account=a_obrien
#SBATCH --output=/scratch/user/uqnzhai/ch4_reanalysis/logs/integron_%j_%a.out
#SBATCH --error=/scratch/user/uqnzhai/ch4_reanalysis/logs/integron_%j_%a.err
# Usage: sbatch --array=1-N 02_integron_finder.sbatch LABEL N_CHUNKS
# e.g.:  sbatch --array=1-60 02_integron_finder.sbatch GFair 60

LABEL=$1
ENV=/QRISdata/Q6837/envs/integron_finder/bin
CHUNK=$(printf "%03d" ${SLURM_ARRAY_TASK_ID})
INPUT=/scratch/user/uqnzhai/ch4_reanalysis/split_${LABEL}/chunk_${CHUNK}.fa
OUTDIR=/scratch/user/uqnzhai/ch4_reanalysis/integron_out/${LABEL}/chunk_${CHUNK}
mkdir -p ${OUTDIR}

${ENV}/integron_finder \
    ${INPUT} \
    --linear --local-max \
    --cpu 4 \
    --prodigal ${ENV}/prodigal \
    --cmsearch ${ENV}/cmsearch \
    --hmmsearch ${ENV}/hmmsearch \
    --outdir ${OUTDIR}
