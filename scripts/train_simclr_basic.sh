#!/bin/bash
#BSUB -n 2
#BSUB -q general
#BSUB -G compute-crponce
#BSUB -J 'simclr_train[1-2]'
#BSUB -gpu "num=1:gmodel=TeslaV100_SXM2_32GB"
#BSUB -R 'gpuhost'
#BSUB -R 'select[mem>32G]'
#BSUB -R 'rusage[mem=32GB]'
#BSUB -M 32G
#BSUB -u binxu.wang@wustl.edu
#BSUB -o  /scratch1/fs1/crponce/simclr_train.%J.%I
#BSUB -a 'docker(pytorchlightning/pytorch_lightning:base-cuda-py3.9-torch1.9)'

echo "$LSB_JOBINDEX"

param_list=\
'--resnet resnet18  --model_path $SCRATCH1/simclr_save/log --batch_size 256 --projection_dim 64 --optimizer Adam
--resnet resnet18  --model_path $SCRATCH1/simclr_save/log2 --batch_size 256 --projection_dim 128 --optimizer Adam
'

export extra_param="$(echo "$param_list" | head -n $LSB_JOBINDEX | tail -1)"
echo "$extra_param"

cd ~/SimCLR/
python main.py $extra_param --dataset STL10  --dataset_dir $SCRATCH1/Datasets  --workers 12  