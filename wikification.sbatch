#!/bin/bash

#SBATCH --job-name=wikification
#SBATCH --output=/home/users/%u/out/wikification.%j.out
#SBATCH --error=/home/users/%u/err/wikification.%j.err
#SBATCH -p hns
#SBATCH --mem=16GB
#SBATCH -c 4
#SBATCH --array=0-1

ml purge
ml java
chmod +x wikification.sh
file=$(ls /scratch/users/$USER/testCorpus/*.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)
./wikification.sh -in $file
