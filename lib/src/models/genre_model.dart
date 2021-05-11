
class Generos {

  List<Genero> items = [];

  Generos.fromJsonList( List<dynamic> jsonList  ){

    if ( jsonList == null ) return;

    jsonList.forEach( (item) {
      final genero = Genero.fromJsonMap(item);
      items.add(genero);
    });
  }
}

class Genero {
  int id;
  String nombre;

  Genero({
    this.id,
    this.nombre
  });

  Genero.fromJsonMap( Map<String, dynamic> json ) {

    id      = json['id'];
    nombre   = json['name'];

  }
}
