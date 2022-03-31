-- Load records from the webdam-books.txt file (tab separated)
books = load '../../data/dblp/webdam-books.txt' 
    as (year: int, title: chararray, author: chararray) ;
group_auth = group books by title;
authors = foreach group_auth generate group, books.author;
dump authors;