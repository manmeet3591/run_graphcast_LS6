#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Lonestar6 AMD Milan nodes
#
#   *** Serial Job in Normal Queue***
# 
# Last revised: October 22, 2021
#
# Notes:
#
#  -- Copy/edit this script as desired.  Launch by executing
#     "sbatch milan.serial.slurm" on a Lonestar6 login node.
#
#  -- Serial codes run on a single node (upper case N = 1).
#       A serial code ignores the value of lower case n,
#       but slurm needs a plausible value to schedule the job.
#
#  -- Use TACC's launcher utility to run multiple serial 
#       executables at the same time, execute "module load launcher" 
#       followed by "module help launcher".
#----------------------------------------------------

#SBATCH -J graphcast           # Job name
#SBATCH -o graphcast.o%j       # Name of stdout output file
#SBATCH -e graphcast.e%j       # Name of stderr error file
#SBATCH -p gpu-h100          # Queue (partition) name
#SBATCH -N 1               # Total # of nodes (must be 1 for serial)
#SBATCH -n 96               # Total # of mpi tasks (should be 1 for serial)
#SBATCH -t 48:00:00        # Run time (hh:mm:ss)
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A your project       # Project/Allocation name (req'd if you have more than 1)
#SBATCH --mail-user= your mail id

# Any other commands must follow all #SBATCH directives...
module list
pwd
date

# Launch serial code...
./run_graphcast.sh       # Do not use ibrun or any other MPI launcher
~                                                                                