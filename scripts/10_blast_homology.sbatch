#!/bin/bash
#SBATCH --job-name=blast_homology
#SBATCH --array=1-10
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --account=a_obrien
#SBATCH --output=/scratch/user/uqnzhai/ch4_reanalysis/logs/blast_hom_%a.out
#SBATCH --error=/scratch/user/uqnzhai/ch4_reanalysis/logs/blast_hom_%a.err

export PATH=/home/uqnzhai/envs/ch4_tools/bin:$PATH

BASE=/QRISdata/Q6636/ch4_reanalysis/homology
LABELS=(GFair PVair BOair Waterair Water)

# 10 pairwise comparisons: GF-PV GF-BO GF-WA GF-W PV-BO PV-WA PV-W BO-WA BO-W WA-W
QUERIES=(0 0 0 0 1 1 1 2 2 3)
SUBJECTS=(1 2 3 4 2 3 4 3 4 4)

Q=${LABELS[${QUERIES[$((SLURM_ARRAY_TASK_ID-1))]}]}
S=${LABELS[${SUBJECTS[$((SLURM_ARRAY_TASK_ID-1))]}]}

# 建 BLAST 数据库
makeblastdb -in ${BASE}/${S}_ARG_contigs.fa -dbtype nucl \
    -out ${BASE}/db_${S} 2>/dev/null

# 运行 BLAST
blastn \
    -query ${BASE}/${Q}_ARG_contigs.fa \
    -db ${BASE}/db_${S} \
    -out ${BASE}/${Q}_vs_${S}.txt \
    -outfmt "6 qseqid sseqid pident length qlen slen evalue bitscore" \
    -perc_identity 90 \
    -evalue 1e-5 \
    -num_threads 8

echo "=== ${Q} vs ${S} done ==="
