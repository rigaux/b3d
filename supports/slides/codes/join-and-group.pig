-- Chargement de books.txt
books = load 'books.txt' 
    as (year: int, title: chararray, author: chararray) ;
-- On prend les livres de Victor Vianu
vianu = filter books by author == 'Vianu';
--- Chargement de publishers.txt
publishers = load 'publishers.txt' 
    as (title: chararray, publisher: chararray) ;
-- Jointure sur le titre
joined = join vianu by title, publishers by title;
-- Groupement sur le nom de l'auteur
grouped = group joined by vianu::author;
-- Maintenant, comptons les editeurs (exercice: supprimer les doublons!)
count = foreach grouped generate group, COUNT(joined.publisher);