--- Load records from the webdam-publishers.txt file
publishers = load 'publishers.txt' 
    as (title: chararray, publisher: chararray) ;
cogrouped = cogroup flattened by group, publishers by title;