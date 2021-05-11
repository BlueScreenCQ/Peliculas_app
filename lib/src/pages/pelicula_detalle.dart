import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/equipo_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/genre_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {

  final peliProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {

    // para acceder a los argumentos de la ruta
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            _crearAppBar( pelicula, context ),
            SliverList(
              delegate: SliverChildListDelegate(
                  [
                    SizedBox( height: 10.0 ),
                    _posterTitulo( pelicula, context ),
                    _generos(pelicula, context),
                    _descripcion( pelicula, context ),
                    _textoReparto(context),
                    _crearCasting( pelicula, context),
                    _textoEquipo(context),
                    _crearEquipo( pelicula, context),
                  ]
              ),
            )
          ],
        )
    );
  }

  Widget _crearAppBar(Pelicula pelicula, BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: _screenSize.height*0.3,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
        background: FadeInImage(
          image: NetworkImage( pelicula.getBackgroundImg() ),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );


    // final _screenSize = MediaQuery.of(context).size;
    //
    // return SliverAppBar(
    //   elevation: 2.0,
    //   backgroundColor: Colors.indigoAccent,
    //   expandedHeight: _screenSize.height*0.3,
    //   floating: false,
    //   pinned: false,
    //   flexibleSpace: FlexibleSpaceBar(
    //     centerTitle: true,
    //     title: Text(pelicula.title, style: TextStyle(color: Colors.white, fontSize: 28.0),
    //     ),
    //     background: FadeInImage(
    //       image: NetworkImage(pelicula.getBackgroundImg()),
    //       placeholder: AssetImage('assets/img/loading.gif'),
    //       fadeInDuration: Duration(milliseconds: 150),
    //       fit: BoxFit.cover,
    //     ),
    //   ),
    // );
  }

  Widget _posterTitulo(Pelicula pelicula, BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
          children: [
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                  image: NetworkImage(pelicula.getPosterImg()),
                  height: 150.0,
                ),
              ),
            ),
            SizedBox(width: 20.0),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pelicula.title, style: Theme.of(context).textTheme.headline4, overflow: TextOverflow.ellipsis,),
                  Text(pelicula.originalTitle, style: Theme.of(context).textTheme.headline5, overflow: TextOverflow.ellipsis,),
                  Text(pelicula.releaseDate, style: Theme.of(context).textTheme.headline6),
                  Row(
                    children: [
                      Icon(Icons.star_border),
                      Text (pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.headline5,),
                    ],
                  ),
                ],
              ),
            ),
          ]
      ),
    );
  }

  Widget _generos(Pelicula pelicula, BuildContext context){

    return Container(
      padding: EdgeInsets.only(top:10.0),
      child: FutureBuilder(
        future: peliProvider.getGeneros(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot){
          if(snapshot.hasData) {
            return _crearTarjetasGeneros(pelicula, snapshot.data, context);
          }
          else{
            return Center(child:CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _crearTarjetasGeneros(Pelicula pelicula, List<Genero> generos, BuildContext context){

    List<Widget> _generos = [];

    for(int i=0;i<pelicula.genreIds.length;i++){
      for(int j=0;j<pelicula.genreIds.length;j++){
        if(generos[j].id==pelicula.genreIds[i]){
          final Text t= new Text('${generos[j].nombre}', style: Theme.of(context).textTheme.headline5);
          final Container c= new Container(child:t, color: Colors.black12, padding: EdgeInsets.all(5.0),);
          final ClipRRect cr= new ClipRRect(borderRadius: BorderRadius.circular(5.0), child: c);

          _generos.add(cr);
          _generos.add(new SizedBox(width:10.0));
        }
      }
    }

    return Container(
      child: Row(
        children: _generos,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  Widget _descripcion( Pelicula pelicula, BuildContext context ) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }

  Widget _textoReparto(BuildContext context){
    return Container(
        padding: EdgeInsets.only(left: 20.0),
        child: Column(
          children: [
            Text('Reparto',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 5.0),
          ],
        ),
    );
  }


  Widget _crearCasting(Pelicula pelicula, BuildContext context) {

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot){
        if(snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        }
        else{
          return Center(child:CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores){

    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorTarjeta(actores[i])

      )
    );
  }

  Widget _actorTarjeta(Actor actor) {

    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'),
              image: _cargarImagenActor(actor),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis
          ),
          Text(
              actor.character,
              overflow: TextOverflow.ellipsis
          ),
        ],
      ),
    );
  }

}

ImageProvider _cargarImagenActor(Actor actor) {

  final ruta = actor.getFoto();

  if (ruta != null){
    return NetworkImage(ruta);
  }
  else {
    return AssetImage('assets/img/no_avatar.jpg');
  }
}

//EQUIPO

Widget _textoEquipo(BuildContext context){
  return Container(
    padding: EdgeInsets.only(left: 20.0),
    child: Column(
      children: [
        Text('Equipo',
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
      ],
    ),
  );
}


Widget _crearEquipo(Pelicula pelicula, BuildContext context) {
  final peliProvider = new PeliculasProvider();

  return FutureBuilder(
    future: peliProvider.getCrew(pelicula.id.toString()),
    builder: (BuildContext context, AsyncSnapshot<List> snapshot){
      if(snapshot.hasData) {
        return _crearEquipoPageView(snapshot.data);
      }
      else{
        return Center(child:CircularProgressIndicator());
      }
    },
  );
}

Widget _crearEquipoPageView(List<Componente> componentes){

  return SizedBox(
      height: 200.0,
      child: PageView.builder(
          pageSnapping: false,
          controller: PageController(
              viewportFraction: 0.3,
              initialPage: 1
          ),
          itemCount: componentes.length,
          itemBuilder: (context, i) => _equipoTarjeta(componentes[i])

      )
  );
}

Widget _equipoTarjeta(Componente componente) {

  return Container(
    child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: FadeInImage(
            placeholder: AssetImage('assets/img/no-image.jpg'),
            image: _cargarImagenComponente(componente),
            height: 150.0,
            fit: BoxFit.cover,
          ),
        ),
        Text(
            componente.name,
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis
        ),
        Text(
            componente.job,
            overflow: TextOverflow.ellipsis
        ),
        Text("(${componente.knownForDepartament})",
            overflow: TextOverflow.ellipsis
        ),

      ],
    ),
  );
}

ImageProvider _cargarImagenComponente(Componente componente) {

  final ruta = componente.getFoto();

  if (ruta != null){
    return NetworkImage(ruta);
  }
  else {
    return AssetImage('assets/img/no_avatar.jpg');
  }
}