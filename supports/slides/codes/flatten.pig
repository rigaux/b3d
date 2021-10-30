-- Take the 'authors' bag and flatten the nested set
flattened = foreach authors generate group, flatten($1);
