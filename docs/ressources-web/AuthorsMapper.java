
/**
 * Les imports indispensables
 */

import java.io.IOException;
import java.util.Scanner;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

/**
 * Exemple d'une fonction de map: on prend un fichier texte contenant
 * des auteurs et on extrait le nom
 */
  public class AuthorsMapper extends
	  Mapper<Object, Text, Text, IntWritable> {

	private final static IntWritable one = new IntWritable(1);
	private Text author = new Text();

       /* la fonction de Map */
        @Override
	public void map(Object key, Text value, Context context)
		throws IOException, InterruptedException {

	  /* Utilitaire java pour scanner une ligne  */
	  Scanner line = new Scanner(value.toString());
	  line.useDelimiter("\t");
	  author.set(line.next());
	  context.write(author, one);
	}
  }
