for $x at $i in doc("books.xml")/bookstore/book/title
return <book>{$i}. {data($x)}</book>
