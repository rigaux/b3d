
/**
 * Programme de soumision d'un traitement MapReduce
 */

import org.apache.hadoop.conf.*;

import org.apache.hadoop.util.*;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class AuthorsJob {

  public static void main(String[] args) throws Exception {

	/* Il nous faut le chemin d'acces au fichier a traiter
             et le chemin d'acces au resultat du reduce */

	if (args.length != 2) {
	  System.err.println("Usage: AuthorsJob <in> <out>");
	  System.exit(2);
	}

	/* Definition du job */
  	Job job = Job.getInstance(new Configuration());

	/* Definition du Mapper et du Reducer */
	job.setMapperClass(AuthorsMapper.class);
	job.setReducerClass(AuthorsReducer.class);

	/* Definition du type du resultat  */
	job.setOutputKeyClass(Text.class);
	job.setOutputValueClass(IntWritable.class);

	/* On indique l'entree et la sortie */
	FileInputFormat.addInputPath(job, new Path(args[0]));
	FileOutputFormat.setOutputPath(job, new Path(args[1]));

        /* Soumission */
 	job.setJarByClass(AuthorsJob.class);
 	job.submit();
  }
}
