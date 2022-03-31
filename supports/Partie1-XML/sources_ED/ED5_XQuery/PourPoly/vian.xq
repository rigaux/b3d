for $b in doc("books.xml")//book
where every $a in $b/author satisfies (contains($a,'Vian') or contains($a,'Pestureau'))
return $b/title
