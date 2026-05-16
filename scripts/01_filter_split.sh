#!/bin/bash
# Filter contigs >=2kb and split into chunks for parallel IntegronFinder

for INFO in "GFair_filtered:GFair:60" "pvair_filtered:PVair:55" "BOair_filtered:BOair:30" "oxley4_filtered:Waterair:20" "water1_filtered:Water:75"; do
    SAMPLE=$(echo $INFO | cut -d: -f1)
    LABEL=$(echo $INFO | cut -d: -f2)
    NCHUNKS=$(echo $INFO | cut -d: -f3)

    python3 << PYEOF
import os
label = "${LABEL}"
n_chunks = ${NCHUNKS}
input_file = f"/QRISdata/Q6837/megahit_filtered2/${SAMPLE}.contigs.fa"
out_dir = f"/scratch/user/uqnzhai/ch4_reanalysis/split_{label}"
os.makedirs(out_dir, exist_ok=True)

records = []
with open(input_file) as f:
    header, seq = None, []
    for line in f:
        line = line.strip()
        if line.startswith(">"):
            if header and len("".join(seq)) >= 2000:
                records.append((header, "".join(seq)))
            header, seq = line, []
        else:
            seq.append(line)
    if header and len("".join(seq)) >= 2000:
        records.append((header, "".join(seq)))

chunk_size = len(records) // n_chunks + 1
for i in range(n_chunks):
    chunk = records[i*chunk_size:(i+1)*chunk_size]
    if not chunk:
        continue
    with open(f"{out_dir}/chunk_{i+1:03d}.fa", "w") as out:
        for h, s in chunk:
            out.write(f"{h}\n{s}\n")
print(f"{label}: {len(records)} contigs -> {n_chunks} chunks")
PYEOF
done
