#!/bin/bash
#SBATCH --job-name=bracken_ch4
#SBATCH --array=1-5
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=4:00:00
#SBATCH --account=a_obrien
#SBATCH --output=/scratch/user/uqnzhai/ch4_reanalysis/logs/bracken_%a.out
#SBATCH --error=/scratch/user/uqnzhai/ch4_reanalysis/logs/bracken_%a.err

DB=/QRISdata/Q8083/databases/kraken2_bacteria_fungi
OUTDIR=/QRISdata/Q6636/ch4_reanalysis/kraken2

LABELS=(GFair PVair BOair Waterair Water)
LABEL=${LABELS[$((SLURM_ARRAY_TASK_ID-1))]}

/home/uqnzhai/envs/ch4_tools/bin/bracken \
    -d ${DB} \
    -i ${OUTDIR}/${LABEL}/${LABEL}.kreport \
    -o ${OUTDIR}/${LABEL}/${LABEL}.bracken \
    -r 150 \
    -l S \
    -t 10

echo "=== ${LABEL} done ==="
