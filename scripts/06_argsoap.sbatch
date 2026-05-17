#!/bin/bash
#SBATCH --job-name=argsoap_ch4
#SBATCH --array=1-5
#SBATCH --cpus-per-task=16
#SBATCH --mem=128G
#SBATCH --time=24:00:00
#SBATCH --account=a_obrien
#SBATCH --output=/scratch/user/uqnzhai/ch4_reanalysis/logs/argsoap_%a.out
#SBATCH --error=/scratch/user/uqnzhai/ch4_reanalysis/logs/argsoap_%a.err
export PATH=/home/uqnzhai/envs/ch4_tools/bin:$PATH

FASTP=/QRISdata/Q6837/edward/fastp
OUTBASE=/QRISdata/Q6636/ch4_reanalysis/argsoap

LABELS=(GFair PVair BOair Waterair Water)
R1S=(GF_air_R1_fastp.fastq.gz PV_air_R1_fastp.fastq.gz BO_air_R1_fastp.fastq.gz Oxyley_4_R1_fastp.fastq.gz Water_1_R1_fastp.fastq.gz)
R2S=(GF_air_R2_fastp.fastq.gz PV_air_R2_fastp.fastq.gz BO_air_R2_fastp.fastq.gz Oxyley_4_R2_fastp.fastq.gz Water_1_R2_fastp.fastq.gz)

LABEL=${LABELS[$((SLURM_ARRAY_TASK_ID-1))]}
R1=${R1S[$((SLURM_ARRAY_TASK_ID-1))]}
R2=${R2S[$((SLURM_ARRAY_TASK_ID-1))]}

INDIR=/scratch/user/uqnzhai/ch4_reanalysis/argsoap_input/${LABEL}
OUTDIR=${OUTBASE}/${LABEL}
mkdir -p ${INDIR} ${OUTDIR}

# ARGs-OAP 需要 reads 在独立目录下
ln -sf ${FASTP}/${R1} ${INDIR}/${LABEL}_1.fastq.gz
ln -sf ${FASTP}/${R2} ${INDIR}/${LABEL}_2.fastq.gz

/home/uqnzhai/envs/ch4_tools/bin/args_oap stage_one \
    -i ${INDIR} \
    -o ${OUTDIR} \
    -f fastq.gz \
    -t 16

/home/uqnzhai/envs/ch4_tools/bin/args_oap stage_two \
    -i ${OUTDIR} \
    -t 16

echo "=== ${LABEL} done ==="
