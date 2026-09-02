import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

  /**
   * La fonction de Reduce: obtient des paires  (auteur, <publications>)
   * et effectue le compte des publication
   */
  public  class AuthorsReducer extends
	  Reducer<Text, IntWritable, Text, IntWritable> {
	private IntWritable result = new IntWritable();

      @Override
	public void reduce(Text key, Iterable<IntWritable> values, 
			Context context)
		throws IOException, InterruptedException {
	  
	  int count = 0;
	  for (IntWritable val : values) {
		count += val.get();
	  }
	  result.set(count);
	  context.write(key, result);
	}
  }
