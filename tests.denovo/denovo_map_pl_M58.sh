#!/bin/bash

#

#-------------------------------------------------------------

#running a shared memory (multithreaded) job over multiple CPUs

#-------------------------------------------------------------

#

#SBATCH --partition=defaultp

#SBATCH --job-name=parameters_stacks_M58

#SBATCH --output=parameters_stacks_M58_out

#

#Number of CPU cores to use within one node

#SBATCH -c 30

#SBATCH --cpus-per-task=30

#

#Define the number of hours the job should run.

#Maximum runtime is limited to 10 days, ie. 240 hours

#SBATCH --time=96:00:00

#

#Define the amount of RAM used by your job in GigaBytes

#In shared memory applications this is shared among multiple CPUs

#SBATCH --mem=90G

#

#Send emails when a job starts, it is finished or it exits

#SBATCH --mail-user=vera.emelianenko@ist.ac.at

#SBATCH --mail-type=ALL

#

#Do not requeue the job in the case it fails.

#SBATCH --no-requeue

#

#Do not export the local environment to the compute nodes

#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

#

#Set the number of threads to the SLURM internal variable

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

#

#run commands SLURM's srun

module load stacks

#run commands on SLURM's srun

# runs stacks denovo_map for M = n from 1 to 8, m = 2, and --max_locus_stacks 7

for M in 5 6 7 8; do

        mkdir stacks45.Mn$M
        mkdir ./stacks45.Mn$M/populations.r80
        srun denovo_map.pl -m 2 -o ./stacks45.Mn$M --popmap ../info/test_popmap.tsv --samples ../../Rutilus --threads 30 -M $M -n $M --paired -X "ustacks: --max_locus_stacks 7"
        srun populations -P ./stacks45.Mn$M  -O ./stacks45.Mn$M/populations.r80 -r 0.80 -t 30 --popmap ../info/test_popmap_onepop.tsv& > populations.oe
        echo "running populations for $M"
done