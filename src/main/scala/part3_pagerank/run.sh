#!/bin/bash

function install_dependencies {
    sbt_status=`which sbt`
    if [ $? -ne 0 ]
    then
      echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
      sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
      sudo apt-get -y -q update
      sudo apt-get install -y -q sbt
    else
      echo "sbt is already installed..."
    fi
    scala_status=`which scala`
    if [ $? -ne 0 ]
    then
      sudo apt-get install -y -q scala
    else
      echo "scala is already installed..."
    fi
}

SCRIPT=`basename ${BASH_SOURCE[0]}`
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
  echo "${REV}-s${NORM}  --Sets the Spark installation directory ${BOLD}s${NORM}. This should be an absolute path"
  echo "${REV}-t${NORM}  --Sets the task to be run ${BOLD}t${NORM}. This can be any of the values 1,2,3,4"
  echo "${REV}-i${NORM}  --Sets the HDFS input file ${BOLD}i${NORM}. This should be in the form hdfs://<MASTER-URL>:<PORT>/<PATH>"
  echo "${REV}-o${NORM}  --Sets the HDFS output file ${BOLD}o${NORM}. This should be in the form hdfs://<MASTER-URL>:<PORT>/<PATH>"
  echo "${REV}-m${NORM}  --Sets the Spark master REST URL ${BOLD}m${NORM}. This should be in the form spark://<MASTER-URL>:<PORT>"
  echo -e "${REV}-h${NORM}  --Displays this help message. No further functions are performed."\\n
  echo -e "Example: ${BOLD}$SCRIPT -s \"/home/foo/spark\" -t 1 -i \"hdfs://10.10.1.1:9000/input.txt\" -o \"hdfs://10.10.1.1:9000/output.txt\" -m \"c220g2-010826vm-1.wisc.cloudlab.us:6066\"${NORM}"\\n
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

while getopts :s:t:i:o:m:h FLAG; do
  case $FLAG in
    s)
      SPARK_DIR=$OPTARG
      echo "-s used: $OPTARG"
      ;;
    t)
      TASK=$OPTARG
      echo "-t used: $OPTARG"
      ;;
    i)
      HDFS_INPUT=$OPTARG
      echo "-i used: $OPTARG"
      ;;
    o)
      HDFS_OUTPUT=$OPTARG
      echo "-o used: $OPTARG"
      ;;
    m)
      MASTER_REST_URL=$OPTARG
      echo "-m used: $OPTARG"
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
install_dependencies

SPARK_SUBMIT="${SPARK_DIR}/bin/spark-submit"
PROJECT_ROOT_DIR=$(dirname $(dirname $(dirname $(dirname $(cd `dirname $0` && pwd)))))
JAR_FILE="${PROJECT_ROOT_DIR}/target/scala-2.11/pagerank_2.11-1.0.jar"
CLASSPATHS=("Dummy" "part3_pagerank.task1_pagerank_algo.PageRank" \
  "part3_pagerank.task2_custom_rdd_partitioning.PageRankCustomPartition" \
  "part3_pagerank.task3_caching.PageRankCache" \
  "part3_pagerank.task4_kill_worker.PageRankKillWorker")

pushd $PROJECT_ROOT_DIR
if [ ! -f "${JAR_FILE}" ]
then
    sbt package
fi
popd

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
