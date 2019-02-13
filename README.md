# CS744 Big Data Systems Assignment 1

## Group members
1. Mohan Rao Divate Kodandarama
2. Mohammed Danish Shaikh
3. Shreeshrita Patnaik

## Building and Running
```
> git clone https://github.com/danish778866/CS744-Assignment1.git
> cd CS744-Assignment1
```

### Running SortText
```
> cd CS744-Assignment1
> CS744-Assignment1/src/main/scala/part2_sortText/run.sh -h # Get help text
```

### Running PageRank
```
> cd CS744-Assignment1
> CS744-Assignment1/src/main/scala/part3_pagerank/run.sh -h # Get help text
```

## Problem
1. `Sorting`: Given an input CSV file, sort the file on the basis of a given column/s.
2. `PageRank`: The following four tasks need to be performed:
      * `Task 1`: Write a Scala/Python/Java Spark application that implements the PageRank algorithm.
      * `Task 2`: Add appropriate custom RDD partitioning and see what changes.
      * `Task 3`: Persist the appropriate RDD as in-memory objects and see what changes.
      * `Task 4`: Kill a Worker process and see the changes. You should trigger the failure to a desired worker VM when the application reaches 50% of its lifetime:

## Organization
The organization of this repository is as follows:
* `README.md`: This README file.
* `build.sbt`: The build file for building with `sbt`.
* `src/main/scala`: The main folder containing the following parts:
  - `part2_sortText`: The folder containing sort scala program and it's corresponding `run.sh`.
    + `sortText.scala`: The scala program for sorting a given input CSV file.
    + `run.sh`: Bash script for executing the program as a Spark application.
  - `part3_pagerank`: The folder containing pagerank tasks and it's corresponding `run.sh`.
    + `task1_pagerank_algo`: The folder containing the `PageRank.scala` Scala program for `Task1` and it's corresponding `README.txt`.
    + `task2_custom_rdd_partitioning`: The folder containing the `PageRankCustomPartition.scala` Scala program for `Task2` and it's corresponding `README.txt`.
    + `task3_caching`: The folder containing the `PageRankCache.scala` Scala program for `Task3` and it's corresponding `README.txt`.
    + `task4_kill_worker`: The folder containing the `PageRankKillWorker.scala` Scala program for `Task4` and it's corresponding `README.txt`.
