# Air-water: Ch4 Airborne ARG Reanalysis

Reanalysis pipeline for the published study:
> Zhai N et al. (2025) Evaluation of a Low-Cost Active Air Sampler for the Surveillance of Airborne Transmission of Antibiotic Resistance Genes. *ACS EST Engineering*, 5(9): 2260–2268.

## Samples

| Label | File | Location |
|-------|------|----------|
| GFair | GFair_filtered.contigs.fa | Biosolids area, 3D-printed + glass fiber |
| PVair | pvair_filtered.contigs.fa | Biosolids area, 3D-printed + PVDF |
| BOair | BOair_filtered.contigs.fa | Biosolids area, commercial Bobcat + PVDF |
| Waterair | oxley4_filtered.contigs.fa | Effluent discharge point |
| Water | water1_filtered.contigs.fa | Liquid wastewater |

## Data Paths (Bunya HPC)

| Data | Path |
|------|------|
| Assembly files | `/QRISdata/Q6837/megahit_filtered2/` |
| geNomad results | `/QRISdata/Q6636/ch4_reanalysis/genomad/` |
| IntegronFinder results | `/QRISdata/Q6636/ch4_reanalysis/*_integrons_merged.tsv` |
| RGI results | `/QRISdata/Q6636/ch4_reanalysis/rgi/` |
| Sourmash results | `/scratch/user/uqnzhai/ch4_reanalysis/compare_k31.csv` |

## Environment

| Tool | Version | Path |
|------|---------|------|
| RGI | 6.0.7 | `/QRISdata/Q6837/envs/rgi_venv` |
| CARD | 4.0.1 | loaded into rgi_venv |
| ARGs-OAP | 3.2.4 | `~/envs/ch4_tools` |
| IntegronFinder | 2.0.6 | `/QRISdata/Q6837/envs/integron_finder` |
| geNomad | — | `/QRISdata/Q6837/envs/genomad` |
| BLAST/samtools/bwa/diamond | latest | `~/envs/ch4_tools` |

## Pipeline Order

1. `scripts/01_filter_split.sh` — Filter contigs ≥2kb, split for parallelisation
2. `scripts/02_integron_finder.sbatch` — IntegronFinder array job
3. `scripts/03_integron_merge.sh` — Merge IntegronFinder results
4. `scripts/04_genomad.sbatch` — geNomad plasmid/virus annotation
5. `scripts/05_rgi.sbatch` — RGI contig ARG annotation
6. `scripts/06_argsoap.sbatch` — ARGs-OAP reads-based ARG quantification
