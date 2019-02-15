Please run this task using the provided run.sh as:
./run.sh -s "<Spark Installation Absolute Path>" -t 4 -i "<HDFS Input>" -o "<HDFS Output>" -m "<Spark Master REST URL>"

Please refer the help using the command "./run.sh -h" in case of any issues.
If the issue is not resolvable, please contact mshaikh4@wisc.edu.

Note: The script will just run the pagerank algorithm without custom partitioning and caching.
A worker would need to be manually killed after 50% of job completion.
