#!/bin/bash

dataPath=/data/shifts/runs/
workfold=$PWD


runID=$1

if [ ! -d ${dataPath}/${runID} ]
then
    echo "ERROR: ${dataPath}/${runID} not a directory, please check!"
    exit 1
fi

if [ -f ${dataPath}/${runID}/FakeHitRate.log ]
then
    runType=0
    echo "Processing ${runID} as FakeHitRate"
elif [ -f ${dataPath}/${runID}/ThresholdScan.log ]
then
    runType=1
    echo "Processing ${runID} as ThresholdScan"
else
    runType=-1
    echo "ERROR: Unknown file type, run log not found in ${dataPath}/${runID}"
    exit 2
fi

if [ $runType -eq 0 ] || [ $runType -eq 1 ]; then 

#    rm -rf /home/its/zshi/workdir/infiles/${runID}
    mkdir ${workfold}/infiles/${runID}
    rm ${workfold}/Config/RunType.dat
    echo $runType >& ${workfold}/Config/RunType.dat

    for f in $(ls -1 ${dataPath}/${runID}/*.lz4)
    do
	echo "i = " $i
	echo "Working on " $f
	filename=$(basename $f)
	echo "File Only" $filename
	pipename="${filename%.*}"
	echo "Pipe Name" $pipename
   	mkfifo ${workfold}/infiles/${runID}/$pipename
	lz4 -d -c -f $f >  ${workfold}/infiles/${runID}/$pipename &
    done 

    echo "QC started, check the progress in online GUI: http://cern.ch/go/qr8S"
else
    echo "ERROR: WRONG RUN TYPE - PLEASE RE-ENTER THE RUN TYPE"
fi


