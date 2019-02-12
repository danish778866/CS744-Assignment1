/*
CS744 Big Data Systems Assignment 1

Group members:
Mohan Rao Divate Kodandarama
Mohammed Danish Shaikh
Shreeshrita Patnaik
*/
import org.apache.spark.SparkContext
import org.apache.spark.SparkConf
import org.apache.spark.HashPartitioner

object PageRankFinal {
  def main(args: Array[String]) {
    var conf = new SparkConf().setAppName("PageRank")
    var sc = new SparkContext(conf)
    val initialFile = sc.textFile("hdfs://10.10.1.1:9000/enwiki-pages")
    var lowercaseFile = initialFile.map(x => x.toLowerCase)
    var filteredFile = lowercaseFile.filter(x => !(x contains ":") || (x contains "category:"))
    var filteredFile2 = filteredFile.filter{_.split("\t").size >= 2}
    var rankTemp = filteredFile2.map{x => (x.split("\t")(0), 1.0)}
    var ranks = rankTemp.distinct()
    var links = filteredFile2.map(x => (x.split("\t")(0), x.split("\t")(1)))
    var linksCombine = links.groupByKey().cache()
    for(a <- 1 to 10) {
        val contribs = linksCombine.join(ranks).values.flatMap{
          case(urls, rank) => val size_t = urls.size
          urls.map(url => (url,rank/size_t))
        }.reduceByKey{case(x,y) => x+y}
        ranks = contribs.map{case(x,y) => (x,0.15 + 0.85 * y)}
    }
    ranks.coalesce(1).saveAsTextFile("hdfs://10.10.1.1:9000/g3_results/PageRank.txt")
  }
}