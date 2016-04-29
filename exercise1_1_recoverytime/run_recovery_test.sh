#!/bin/bash

for i in "$@"
do
case $i in
    -h=*|--host=*)
    HOST="${i#*=}"
    ;;

     -r=*|--rate=*)
    RATE="${i#*=}"
    ;;

     -d=*|--duplicates=*)
    REPLICAS="${i#*=}"
    ;;
    *)
            # unknown option
    ;;
esac
done


if [ -z "$HOST" ]
  then
    echo "One argument required. Examples:"
  else
    duration=180s
    filename="rep_${REPLICAS}_rate_${RATE}"
    NOW=$(date "+%y-%m-%d_%H-%M-%S")
    DIR=${filename}_${NOW}
    mkdir $DIR

	echo
	echo 
	echo Test is Starting
    echo "##############"
    echo 
    echo This test will run for 180 seconds.
    echo 
    echo Start your stopwatch now and
    echo pull the plug after 30 seconds.
    echo 
    echo Make sure that you only pull the plug of a slave. Do not pull the plug of the MASTER "(top node)".
    echo Use kubectl to find the a node where only one application is scheduled.
    echo Run the test with replicas=1, replicas=2, and replicas=5. 
    echo and Rates of 100 and 200. 

  	echo "GET http://"$HOST"" | ../vegeta attack -rate="$RATE" -duration="${duration}" -output=$DIR/$filename.bin 
    mkdir $DIR/files
    ../vegeta report -inputs=$DIR/$filename.bin 
    ../vegeta report -inputs=$DIR/$filename.bin -reporter=json > $DIR/files/metrics.json
    ../vegeta report -inputs=$DIR/$filename.bin -reporter=text > $DIR/files/metrics.txt
    ../vegeta report -inputs=$DIR/$filename.bin -reporter=plot > $DIR/files/plot.html
    ../vegeta report -inputs=$DIR/$filename.bin -reporter="hist[0,100ms,200ms,300ms]" > $DIR/files/hist.txt
    ../vegeta dump -inputs=$DIR/$filename.bin -dumper=json > $DIR/files/dump.json
    ../vegeta dump -inputs=$DIR/$filename.bin -dumper=csv > $DIR/files/dump.csv
		

fi


