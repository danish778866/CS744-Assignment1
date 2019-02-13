# CS744 Big Data Systems Assignment 1

## Group members:
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
> CS744-Assignment1/src/main/scala/part2\_sortText/run.sh -h # Get help text
```

### Running PageRank
```
> cd CS744-Assignment1
> CS744-Assignment1/src/main/scala/part3\_pagerank/run.sh -h # Get help text
```

## Organization
The organization of this repository is as follows:
* `README.md`: This README file.
* `build.sbt`: The build file for building with `sbt`.
* `src/main/scala`: The main folder containing the following parts:
  - `part2_sortText`: The folder containing sort scala program and it's corresponding `run.sh`
    + `sortText.scala`: The scala program for sorting a given input CSV file.
    + `run.sh`: Bash script for executing the program as a Spark application.
