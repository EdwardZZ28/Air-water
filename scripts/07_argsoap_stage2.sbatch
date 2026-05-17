#!/bin/bash
#SBATCH --job-name=argsoap_s2
#SBATCH --array=1-5
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=12:00:00
#SBATCH --account=a_obrien
#SBATCH --output=/scratch/user/uqnzhai/ch4_reanalysis/logs/argsoap_s2_%a.out
#SBATCH --error=/scratch/user/uqnzhai/ch4_reanalysis/logs/argsoap_s2_%a.err

export PATH=/home/uqnzhai/envs/ch4_tools/bin:$PATH

LABELS=(GFair PVair BOair Waterair Water)
LABEL=${LABELS[$((SLURM_ARRAY_TASK_ID-1))]}
OUTDIR=/QRISdata/Q6636/ch4_reanalysis/argsoap/${LABEL}

/home/uqnzhai/envs/ch4_tools/bin/args_oap stage_two \
    -i ${OUTDIR} \
    -t 16

echo "=== ${LABEL} stage_two done ==="
