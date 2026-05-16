#!/bin/bash
#SBATCH --job-name=rgi_ch4
#SBATCH --array=1-5
#SBATCH --cpus-per-task=16
#SBATCH --mem=128G
#SBATCH --time=48:00:00
#SBATCH --account=a_obrien
#SBATCH --output=/scratch/user/uqnzhai/ch4_reanalysis/logs/rgi_ch4_%a.out
#SBATCH --error=/scratch/user/uqnzhai/ch4_reanalysis/logs/rgi_ch4_%a.err

export PATH=/home/uqnzhai/envs/ch4_tools/bin:$PATH

SAMPLES=(GFair_filtered pvair_filtered BOair_filtered oxley4_filtered water1_filtered)
LABELS=(GFair PVair BOair Waterair Water)

SAMPLE=${SAMPLES[$((SLURM_ARRAY_TASK_ID-1))]}
LABEL=${LABELS[$((SLURM_ARRAY_TASK_ID-1))]}

OUTDIR=/QRISdata/Q6636/ch4_reanalysis/rgi/${LABEL}
mkdir -p ${OUTDIR}
cd ${OUTDIR}

/QRISdata/Q6837/envs/rgi_venv/bin/rgi main \
    -i /QRISdata/Q6837/megahit_filtered2/${SAMPLE}.contigs.fa \
    -o ${LABEL} \
    -t contig \
    -a BLAST \
    --clean \
    -n 16 \
    --include_loose

echo "=== ${LABEL} 完成 ==="
