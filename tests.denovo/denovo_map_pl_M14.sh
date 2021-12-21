#!/bin/bash

#

#-------------------------------------------------------------

#running a shared memory (multithreaded) job over multiple CPUs

#-------------------------------------------------------------

#

#SBATCH --partition=defaultp

#SBATCH --job-name=parameters_stacks_M14

#SBATCH --output=parameters_stacks_M14_out

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

# runs stacks denovo_map for m from to 10, n=0 and M =2, and --max_locus_stacks 7
# it will process all the samples except for the outgroup 

for m in 1 2 3 4 5 6 7 8 9 10; do

        mkdir stacks45.m$m
        mkdir ./stacks45.m$m/populations.r80
        srun denovo_map.pl -m $m -o ./stacks45.m$m --popmap ../info/test_popmap.tsv --samples ../../Rutilus --threads 30 -M 2 -n 0 --paired -X "ustacks: --max_locus_stacks 7"
        srun populations --in-path ./stacks45.m$m --out-path ./stacks45.m$m/populations.r80 -r 0.80 &> populations.oe --threads 30

module load stacks

#run commands on SLURM's srun

# runs stacks denovo_map for M = n from 1 to 8, m = 2, and --max_locus_stacks 7

for M in 1 2 3 4; do

        mkdir stacks45.Mn$M
        mkdir ./stacks45.Mn$M/populations.r80
        srun denovo_map.pl -m 2 -o ./stacks45.Mn$M --popmap ../info/test_popmap.tsv --samples ../../Rutilus --threads 30 -M $M -n $M --paired -X "ustacks: --max_locus_stacks 7"
        srun populations -P ./stacks45.Mn$M  -O ./stacks45.Mn$M/populations.r80 -r 0.80 -t 30 --popmap ../info/test_popmap_onepop.tsv& > populations.oe
        echo "running populations for $M"
done