package part2_sortText
import org.apache.spark.sql.SparkSession
import org.apache.spark.SparkConf
import org.apache.spark.SparkContext

object sortText {
  def main(args: Array[String]){
    val spark = SparkSession.builder().appName("sortText")
                                     .config("spark.some.config.option", "some-value")
                                     .getOrCreate()
    val input_file = args(0)
    val output_file = args(1)
    import spark.implicits._
    val df = spark.read.option("header", true).option("delimiter", ",").csv(input_file)
    val sorted = df.sort($"cca2",$"timestamp")
    sorted.coalesce(1).write.format("csv").save(output_file)
  }
}
