#!/bin/bash
#SBATCH --partition=XXXXXXX
#SBATCH --nodes=XXXXXXX
#SBATCH --ntasks-per-node=20
#SBATCH -o logs/out.log
#SBATCH -e logs/err.log
#SBATCH --job-name=d4py
#sbatch --exclusive


#======================CONFIG  PARAMS=================================#
#
#
WORKDIR=                    #SET to current working directory
LIBCAPIO_POSIX_PRELOAD=     #SET to path of libcapio_posix.so
CAPIO_SERVER_DIR=           #SET to path of capio_server binary
CAPIO_CL_CONFIG_PATH=       #SET to realpath of capio-cross-corr.json
#
#
#===================END OF CONFIG PARAMS==============================#


nodes=($(scontrol show hostnames $SLURM_JOB_NODELIST))
NODE1=${nodes[0]}
NTASKSxNODE=$SLURM_TASKS_PER_NODE

echo Executing on nodes $SLURM_JOB_NODELIST
echo Executing with $(($SLURM_JOB_NUM_NODES*$NTASKSxNODE)) MPI tasks
echo ====================================


cd $WORKDIR

rm -rf $WORKDIR/OUTPUT
mkdir -p $WORKDIR/OUTPUT/DATA/
mkdir -p $WORKDIR/OUTPUT/XCORR/

export CAPIO_DIR=$WORKDIR/OUTPUT
export CAPIO_WORKFLOW_NAME=tc_cross_corr
export CAPIO_IGNORE_CHILD_THREADS=ON


srun --nodes=$SLURM_JOB_NUM_NODES                   \
     --ntasks-per-node=1                            \
     $CAPIO_SERVER_DIR/capio_server                 \
     -c $CAPIO_CL_CONFIG_PATH >> logs/server.log    &
SERVER_PID=$!

srun --exclude=$NODE1 --nodes=$(($SLURM_JOB_NUM_NODES-1))                                \
     --overlap --ntasks-per-node=20 --mpi=pmix                                           \
     --export=ALL,LD_PRELOAD=$LIBCAPIO_POSIX_PRELOAD,CAPIO_APP_NAME=xcorr                \
     dispel4py mpi realtime_xcorr.py -n $((($SLURM_JOB_NUM_NODES-1)*20)) >> logs/out.log &
XCORR_PID=$!

srun -w $NODE1 --nodes=1 --overlap                                                       \
     --ntasks-per-node=20 --mpi=pmix                                                     \
     --export=ALL,LD_PRELOAD=$LIBCAPIO_POSIX_PRELOAD,CAPIO_APP_NAME=prep                 \
     dispel4py mpi realtime_prep.py -f realtime_xcorr_input.jsn -n 20 >> logs/out.log 

wait $XCORR_PID
kill $SERVER_PID
echo "Done"