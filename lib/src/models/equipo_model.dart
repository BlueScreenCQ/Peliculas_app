
class Crew {

  List<Componente> equipo = [];

  Crew.fromJsonList( List<dynamic> jsonList  ){

    if ( jsonList == null ) return;

    jsonList.forEach( (item) {
      final actor = Componente.fromJsonMap(item);
      equipo.add(actor);
    });
  }

}

class Componente {
  bool adult;
  int gender;
  int id;
  String knownForDepartament;
  String name;
  String originalname;
  String profilePath;
  String creditID;
  String departament;
  String job;


  Componente({
    this.adult,
    this.gender,
    this.id,
    this.knownForDepartament,
    this.name,
    this.originalname,
    this.profilePath,
    this.creditID,
    this.departament,
    this.job
  });


  Componente.fromJsonMap( Map<String, dynamic> json ) {

    adult                   = json['adult'];
    gender                  = json['gender'];
    id                      = json['id'];
    knownForDepartament     = json['known_for_department'];
    name                    = json['name'];
    originalname            = json['original_name'];
    profilePath             = json['profile_path'];
    creditID                = json['credit_id'];
    departament             = json['department'];
    job                     = json['job'];


  }

  getFoto() {

    if ( profilePath == null ) {
      return null;
    } else {
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }

}