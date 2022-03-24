-- Load records from the webdam-books.txt file (tab separated)
books = load '../../data/dblp/webdam-books.txt' 
    as (year: int, title: chararray, author: chararray) ;
publishers = load '../../data/dblp/webdam-publishers.txt' 
    as (title: chararray, publisher: chararray) ;
group_auth = group books by title;
authors = foreach group_auth generate group, books.author;
flattened = foreach authors generate group, flatten (author);
cogrouped = cogroup flattened by group, publishers by title;
dump cogrouped;
