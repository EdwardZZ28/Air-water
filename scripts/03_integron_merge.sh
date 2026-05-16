#!/bin/bash
# Merge IntegronFinder results across all chunks for each sample

OUTBASE=/QRISdata/Q6636/ch4_reanalysis

for LABEL in GFair PVair BOair Waterair Water; do
    find /scratch/user/uqnzhai/ch4_reanalysis/integron_out/${LABEL}/ \
        -name "*.integrons" | sort | \
        xargs awk 'FNR==1 && NR!=1 {next} {print}' \
        > ${OUTBASE}/${LABEL}_integrons_merged.tsv

    N=$(grep -v "^#" ${OUTBASE}/${LABEL}_integrons_merged.tsv | \
        grep -v "^ID_integron" | grep -v "^$" | wc -l)
    echo "${LABEL}: ${N} integron records"
done
