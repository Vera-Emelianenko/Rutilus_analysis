#!/bin/bash

#

#-------------------------------------------------------------

#running a shared memory (multithreaded) job over multiple CPUs

#-------------------------------------------------------------

#

#SBATCH --partition=defaultp

#SBATCH --job-name=count_reads

#SBATCH --output=count_reads_output

#

#Number of CPU cores to use within one node

#SBATCH -c 2

#SBATCH --cpus-per-task=2

#

#Define the number of hours the job should run.

#Maximum runtime is limited to 10 days, ie. 240 hours

#SBATCH --time=96:00:00

#

#Define the amount of RAM used by your job in GigaBytes

#In shared memory applications this is shared among multiple CPUs

#SBATCH --mem=10G

#

#Send emails when a job starts, it is finished or it exits

#SBATCH --mail-user=emelianenko.vera@gmail.com

#SBATCH --mail-type=ALL

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

srun python count_reads.py