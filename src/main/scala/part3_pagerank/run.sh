#!/bin/bash

SCRIPT=`basename ${BASH_SOURCE[0]}`
HADOOP_DIR=""
SPARK_DIR=""
TASK=1
HDFS_INPUT=""
HDFS_OUTPUT=""

# Set fonts for Help.
NORM=`tput sgr0`
BOLD=`tput bold`
REV=`tput smso`

# Help function
function HELP {
  echo -e \\n"Help documentation for ${BOLD}${SCRIPT}.${NORM}"\\n
  echo -e "${REV}Basic usage:${NORM} ${BOLD}$SCRIPT -d <hadoop path> -s <spark path> -t <task number>${NORM}"\\n
  echo "Command line switches are optional. The following switches are recognized."
  echo "${REV}-d${NORM}  --Sets the Hadoop installation directory ${BOLD}d${NORM}. This should be an absolute path"
  echo "${REV}-s${NORM}  --Sets the Spark installation directory ${BOLD}s${NORM}. This should be an absolute path"
  echo "${REV}-t${NORM}  --Sets the task to be run ${BOLD}t${NORM}. This can be any of the values 1,2,3,4"
  echo "${REV}-i${NORM}  --Sets the HDFS input file ${BOLD}i${NORM}. This should be in the form hdfs://<MASTER-URL>:<PORT>/<PATH>"
  echo "${REV}-o${NORM}  --Sets the HDFS output file ${BOLD}o${NORM}. This should be in the form hdfs://<MASTER-URL>:<PORT>/<PATH>"
  echo "${REV}-m${NORM}  --Sets the Spark master REST URL ${BOLD}m${NORM}. This should be in the form spark://<MASTER-URL>:<PORT>"
  echo -e "${REV}-h${NORM}  --Displays this help message. No further functions are performed."\\n
  echo -e "Example: ${BOLD}$SCRIPT -d /home/foo/hadoop -s /home/foo/spark -t 1${NORM}"\\n
  exit 1
}

# Check the number of arguments. If none are passed, print help and exit.
NUMARGS=$#
echo -e \\n"Number of arguments: $NUMARGS"
if [ $NUMARGS -eq 0 ]; then
  HELP
fi

### Start getopts code ###

#Parse command line flags
#If an option should be followed by an argument, it should be followed by a ":".
#Notice there is no ":" after "h". The leading ":" suppresses error messages from
#getopts. This is required to get my unrecognized option code to work.

while getopts :d:s:t:i:o:m:h FLAG; do
  case $FLAG in
    d)  #set option "i"
      HADOOP_DIR=$OPTARG
      echo "-i used: $OPTARG"
      ;;
    s)  #set option "j"
      SPARK_DIR=$OPTARG
      echo "-j used: $OPTARG"
      ;;
    t)  #set option "c"
      TASK=$OPTARG
      echo "-c used: $OPTARG"
      ;;
    i)  #set option "c"
      HDFS_INPUT=$OPTARG
      echo "-c used: $OPTARG"
      ;;
    o)  #set option "c"
      HDFS_OUTPUT=$OPTARG
      echo "-c used: $OPTARG"
      ;;
    m)  #set option "c"
      MASTER_REST_URL=$OPTARG
      echo "-c used: $OPTARG"
      ;;
    h)  #show help
      HELP
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
      HELP
      ;;
  esac
done

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.

### End getopts code ###

SPARK_SUBMIT="${SPARK_DIR}/sbin/spark-submit"
PROJECT_ROOT_DIR=$(dirname $(dirname $(dirname $(dirname $(cd `dirname $0` && pwd)))))
JAR_FILE="${PROJECT_ROOT_DIR}/target/scala-2.11/pagerank_2.11-1.0.jar"
CLASSPATHS=("Dummy" "part3_pagerank.task1_pagerank_algo.PageRank" \
  "part3_pagerank.task2_custom_rdd_partitioning.PageRankCustomPartition" \
  "part3_pagerank.task3_caching.PageRankCache" \
  "part3_pagerank.task4_kill_worker.PageRankKillWorker")
if [ $TASK -ge 1 -a $TASK -le 4 ]
then
    ${SPARK_SUBMIT} --class ${CLASSPATHS[$TASK]} \
      --executor-memory 8g --driver-memory 8g --executor-cores 5 \
      --master ${MASTER_REST_URL} --deploy-mode cluster \
      ${JAR_FILE} ${HDFS_INPUT} ${HDFS_OUTPUT}

else
    HELP
fi

exit 0
