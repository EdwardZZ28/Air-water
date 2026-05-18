#!/bin/bash
#SBATCH --job-name=kraken2_ch4
#SBATCH --array=1-5
#SBATCH --cpus-per-task=16
#SBATCH --mem=256G
#SBATCH --time=24:00:00
#SBATCH --account=a_obrien
#SBATCH --output=/scratch/user/uqnzhai/ch4_reanalysis/logs/kraken2_%a.out
#SBATCH --error=/scratch/user/uqnzhai/ch4_reanalysis/logs/kraken2_%a.err

source ~/.bashrc
module load anaconda3/2023.09-0
source /sw/auto/rocky9a/epyc3/software/Anaconda3/2023.09-0/etc/profile.d/conda.sh
conda activate /scratch/user/uqnzhai/conda_envs/kraken2_bracken

DB=/QRISdata/Q8083/databases/kraken2_bacteria_fungi
FASTP=/QRISdata/Q6837/edward/fastp
OUTDIR=/QRISdata/Q6636/ch4_reanalysis/kraken2

LABELS=(GFair PVair BOair Waterair Water)
R1S=(GF_air_R1_fastp.fastq.gz PV_air_R1_fastp.fastq.gz BO_air_R1_fastp.fastq.gz Oxyley_4_R1_fastp.fastq.gz Water_1_R1_fastp.fastq.gz)
R2S=(GF_air_R2_fastp.fastq.gz PV_air_R2_fastp.fastq.gz BO_air_R2_fastp.fastq.gz Oxyley_4_R2_fastp.fastq.gz Water_1_R2_fastp.fastq.gz)

LABEL=${LABELS[$((SLURM_ARRAY_TASK_ID-1))]}
R1=${R1S[$((SLURM_ARRAY_TASK_ID-1))]}
R2=${R2S[$((SLURM_ARRAY_TASK_ID-1))]}

mkdir -p ${OUTDIR}/${LABEL}

kraken2 \
    --db ${DB} \
    --paired \
    --threads 16 \
    --output ${OUTDIR}/${LABEL}/${LABEL}.kraken \
    --report ${OUTDIR}/${LABEL}/${LABEL}.kreport \
    --gzip-compressed \
    ${FASTP}/${R1} ${FASTP}/${R2}

bracken \
    -d ${DB} \
    -i ${OUTDIR}/${LABEL}/${LABEL}.kreport \
    -o ${OUTDIR}/${LABEL}/${LABEL}.bracken \
    -r 150 \
    -l S \
    -t 10

echo "=== ${LABEL} done ==="
