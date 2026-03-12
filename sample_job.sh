#!/bin/bash
#SBATCH -J job_name                # name of the job
#SBATCH -p gpu                     # name of the partition: available options "gpu"
#SBATCH -N 1                       # no of Nodes
#SBATCH --gres=gpu:1               # request gpu card: it should be either 1 or 2
#SBATCH -t 36:00:00                # walltime in HH:MM:SS, max value 72:00:00
#SBATCH --output=~/jobout/%j.log
#SBATCH --mem=16000

# list of modules you want to use, for example
module load compiler/cuda/11.7
module load compiler/intel/2020.4.304
module load compiler/gcc/10.2.0

# export env variables
export PYTHONPATH=/scratch/21cs10083/decision-diffuser
export C_INCLUDE_PATH="/home/21cs10083/centos/usr/include/:/home/21cs10083/miniconda3/envs/decdiff/include/:/home/21cs10083/centos/usr/lib/gcc/x86_64-redhat-linux/4.8.2/include/:$C_LIBRARY_PATH"
export PATH="$HOME/centos/usr/sbin:$HOME/centos/usr/bin:$HOME/centos/bin:$PATH"
export MANPATH="$HOME/centos/usr/share/man:$MANPATH"
L='/lib:/lib64:/usr/lib:/usr/lib64'
export LD_LIBRARY_PATH="$HOME/centos/usr/lib:$HOME/centos/usr/lib64:$L:$LD_LIBRARY_PATH"

#run the application
python3 train.py


