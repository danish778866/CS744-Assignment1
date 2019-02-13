import org.apache.spark.sql.SparkSession
import org.apache.spark.SparkConf
import org.apache.spark.SparkContext

object sortText {
  def main(args: Array[String]){
// var conf = new SparkConf().setAppName("sortText").set("spark.driver.allowMultipleContexts", "true")
// var sc = new SparkContext(conf)
//val args = sc.getConf.get("spark.driver.args").split(" +")


val spark = SparkSession.builder()
              .appName("sortText")
                 .config("spark.some.config.option", "some-value")
                                                      .getOrCreate()
val input_file = args(0)
val output_file = args(1)

import spark.implicits._

//val df = spark.read.option("header", true).option("delimiter", ",").csv("hdfs://10.10.1.1:9000/export.csv")
val df = spark.read.option("header", true).option("delimiter", ",").csv(input_file)
val sorted = df.sort($"cca2",$"timestamp")
//sorted.coalesce(1).write.format("csv").save("hdfs://10.10.1.1:9000/result_G3_sortText")
sorted.coalesce(1).write.format("csv").save(output_file)
}

}