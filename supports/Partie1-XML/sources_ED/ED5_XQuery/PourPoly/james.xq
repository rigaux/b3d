for $b in doc("books.xml")//book
where some $a in $b/author satisfies (contains($a,'James'))
return $b/title
