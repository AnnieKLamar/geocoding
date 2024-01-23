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
chmod +x geocode.sh
corpus_directory=$(ls /scratch/users/$USER/testCorpus/*.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)
./geocode.sh -in corpus_directory
