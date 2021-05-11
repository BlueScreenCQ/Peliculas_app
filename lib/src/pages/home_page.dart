import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgents/card_swiper_widget.dart';
import 'package:peliculas/src/widgents/movie_horizontal.dart';

class HomePage extends StatelessWidget {

  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text('Películas en cines'),
          backgroundColor: Colors.indigoAccent,
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: DataSearch(),
                    //query: 'consulta por defecto',
                  );
                })
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _swiperTarjetas(),
              _footer(context),
            ],
          ),
        )

    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
        future: peliculasProvider.getEnCines(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if(snapshot.hasData) return CardSwiper(peliculas: snapshot.data);
          else return Container(
              height: 400.0,
              child: Center(
                  child: CircularProgressIndicator()
              )
          );
        }
    );
  }

  Widget _footer(BuildContext context) {
    return Container (
        width: double.infinity,
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('Las más populares', style: Theme.of(context).textTheme.headline6)),
            SizedBox(height: 5.0),

            StreamBuilder(
              stream: peliculasProvider.popularesStream,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if(snapshot.hasData) return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,  //Enviamos la llamada a la función que dispara cargar mas pelis
                );
                else return Center(child: CircularProgressIndicator());
              },
            )

            // Text('Populares', style: Theme.of(context).textTheme.headline6)
          ],
        )
    );
  }
}