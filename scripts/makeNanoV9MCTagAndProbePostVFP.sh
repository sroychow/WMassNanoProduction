#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo "Requires at least one command line arguments!"
    echo "ex. "
    echo "    bash makeNanoV9MCTagAndPrbePostVFP <das_path> <name> <nthreads>"
    exit 1
fi

sample_name=$1
if [[ "$sample_name" != file:* ]]; then
    sample_name=dbs:$sample_name
fi

nevents=1000
name=${2}
nThreads=4
if [[ $# -gt 2 ]]; then
    nThreads=${3}
fi
if [[ $# -gt 3 ]]; then
    echo "Secondary files not expected for Nano V9!"
    exit 1
fi

config_name=configs/${name}_cfg.py
outfile=${name}.root

cmsDriver.py RECO --conditions 106X_mcRun2_asymptotic_v17 \
    --datatier NANOAODSIM --eventcontent NANOAODSIM \
    --era Run2_2016,run2_nanoAOD_106Xv2 \
    --geometry DB:Extended \
    --customise Configuration/DataProcessing/Utils.addMonitoring \
    --filein $sample_name --fileout file:$outfile --nThreads $nThreads --no_exec \
    --python_filename $config_name --mc \
    --scenario pp --step PAT,USERNANO:nanotpSequenceMC \
    --runUnscheduled -n $nevents 

