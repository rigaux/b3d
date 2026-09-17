
var film =
"""{
"_id": "movie:10",
"title": "Blade Runner",
"year": 1982,
"genre": "Action",
"summary": "En 2019, lors de la décadence de Los Angeles, des êtres synthétiques, sans pensée, sans émotions, suffisent aux différents travaux d'entretien. Leur durée de vie n'excède pas 4 années. Un jour, ces ombres humaines se révoltent et on charge les tueurs, appelés Blade Runner, de les abattre... ",
"country": "USA",
"director": {
"_id": "artist:4",
"last_name": "Scott",
"first_name": "Ridley",
"birth_date": "1937"
},
"actors": [
{
"_id": "artist:24",
"first_name": "Harrison",
"last_name": "Ford",
"birth_date": "1942",
"role": "Deckard"
},
{
"_id": "artist:25",
"first_name": "Rutger",
"last_name": "Hauer",
"birth_date": "1944",
"role": "Batty"
}
]
}"""

case class Artiste(nom: String, prenom: String, annee_naissance: Double)

case class Film(titre: String,
         resume: String,
         annee: Double,
         genre: String,
         pays: String,
         realisateur: Artiste,
         acteurs: List[Artiste]
)

def parseFilm (jsonString: String) : Film = {
   import scala.util.parsing.json.JSON

   // On parse
   val jsonMap = JSON.parseFull(jsonString).getOrElse("").asInstanceOf[Map[String, Any]]

   // On extrait
   val titre = jsonMap.get("title").get.asInstanceOf[String]
   val resume = jsonMap.get("summary").get.asInstanceOf[String]
   val annee = jsonMap.get("year").get.asInstanceOf[Double]
   val genre = jsonMap.get("genre").get.asInstanceOf[String]
   val pays = jsonMap.get("country").get.asInstanceOf[String]

   // Le metteur en scène
   val director_json  = jsonMap.get("director").getOrElse("").asInstanceOf[Map[String, Any]]
   val nom = ""
    val prenom = ""
   if (director_json != "") {
     val nom = director_json.get("last_name").get.asInstanceOf[String]
     val prenom = director_json.get("first_name").get.asInstanceOf[String]
    }
    
   val director = Artiste (nom, prenom, 0)
 
   // Et voici le film
   return Film(titre, resume, annee, genre, pays, director, List())
}

 
    val stream = senv.socketTextStream("localhost", 9000, '\n')
    val w = stream.print()   
     senv.execute("Ma gestion de fenêtres ")

    val stream = senv.socketTextStream("localhost", 9000, '\n')
   val w = stream.map ( { x => parseFilm (x) } ).map ( { film => film.titre } ).print()
     senv.execute("Ma gestion de fenêtres ")
  
    case class CompteurFilm(realisateur: String, compteur: Int)
    val stream = senv.socketTextStream("localhost", 9000, '\n')
    val w = stream.map ( { x => parseFilm (x) } )
                .map ( {f => CompteurFilm(f.realisateur.nom, 1) } )
                .keyBy ( { "realisateur" } )
                .sum("compteur")
                .print()
    senv.execute("Ma gestion de fen�tres ")


