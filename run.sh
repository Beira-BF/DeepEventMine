#!/bin/bash

CORPUS_NAME=$1 # cg, ge11, pc, etc
TASK=$2 # predict, eval
DEV_TEST=$3 # predict for dev, test sets

experiment_dir="experiments/$CORPUS_NAME"
log_dir="$experiment_dir/logs"
mkdir -p $log_dir

# predict
if [ "$TASK" = "predict" ]; then
    echo "Predict:"

    GOLD_E2E=$5 # gold, e2e
    DEV_TEST=$4

    # predict
    nohup python -u predict.py --yaml $experiment_dir/configs/$TASK-$GOLD_E2E-$DEV_TEST.yaml >> $log_dir/$TASK-$GOLD_E2E-$DEV_TEST.log &

# evaluate
elif [ "$TASK" = "eval" ]; then

    echo "Evaluate:"

    GOLD_E2E=$5 # gold, e2e
    DEV_TEST=$4

    # paths
    REFDIR="data/corpora/$CORPUS_NAME/$DEV_TEST/" # reference gold data
    PREDDIR="$experiment_dir/predict-$GOLD_E2E-$DEV_TEST/ev-last/ev-ann/"
    ZIPDIR="$experiment_dir/predict-$GOLD_E2E-$DEV_TEST/ev-last/" # retrieve the original offsets

    # retrieve the original offsets and create zip format for online evaluation
    python scripts/postprocess.py --corpusdir $REFDIR --indir $PREDDIR --outdir $ZIPDIR --corpus_name $CORPUS_NAME --dev_test $DEV_TEST

fi

echo "Done!"