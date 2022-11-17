package nfe204 

/**
  Exemple de programme Flink - Cours NFE204: http://b3d.bdpedia.fr
 */

import org.apache.flink.streaming.api.scala._
import org.apache.flink.streaming.api.windowing.time.Time;


object ExFlink {

    def main(args: Array[String]) : Unit = {

      // Environnement de streaming
      val env: StreamExecutionEnvironment = StreamExecutionEnvironment.getExecutionEnvironment
      
      // Connexion a la socket localhost:9000
      val stream = env.socketTextStream("localhost", 9000, '\n')
      
      // Workflow
      val w = stream.map ( { x => Tuple1(x.toInt) } )
      
      // Affichage sur la sortie standard
      w.print()

      env.execute("Exemple de programme Flink - NFE204")
    }
}

