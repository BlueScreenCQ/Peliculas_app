
import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/equipo_model.dart';
import 'package:peliculas/src/models/genre_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {

  String _apiKey = 'd665f7ffb6e7edd5acde0d7eaf26f506';
  String _url ='api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage=0;
  bool _cargando = false; //Para controlar que no haga llamadas innecesaias consecutivas

  List<Pelicula> _popularesList = [];

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast(); //broadcast: muchos escuchan el mismo stream

  //GETTERS para añadir y escuchar del stream
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStresms() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }


  Future<List<Pelicula>> getEnCines() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'  : _apiKey,
      'language' : _language
    });

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {

    if (_cargando) return [];

    _cargando = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'  : _apiKey,
      'language' : _language,
      'page'     : _popularesPage.toString()
    });
    
    final resp =  await _procesarRespuesta(url);
    
    _popularesList.addAll(resp);

    popularesSink( _popularesList);

    _cargando =false;

    return resp; //devulvo la lista para no cambiar la signatura del método
  }

  Future <List<Actor>> getCast(String peliID) async {

    final url = Uri.https(_url, '3/movie/$peliID/credits', {
      'api_key'  : _apiKey,
      'language' : _language,
    });

    final respuesta = await http.get(url);
    final decodedData = json.decode(respuesta.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future <List<Componente>> getCrew(String peliID) async {

    final url = Uri.https(_url, '3/movie/$peliID/credits', {
      'api_key'  : _apiKey,
      'language' : _language,
    });

    final respuesta = await http.get(url);
    final decodedData = json.decode(respuesta.body);

    final crew = new Crew.fromJsonList(decodedData['crew']);

    return crew.equipo;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {

    final url = Uri.https(_url, '3/search/movie', {
      'api_key'  : _apiKey,
      'language' : _language,
      'query'    : query,
    });

    return await _procesarRespuesta(url);
  }

  Future<List<Genero>> getGeneros() async {

    final url = Uri.https(_url, '3/genre/movie/list', {
      'api_key'  : _apiKey,
      'language' : _language
    });

    final resp = await http.get(url);
    print(url.toString());
    final decodedData = json.decode(resp.body);

    final generos = new Generos.fromJsonList(decodedData['genres']);

    return generos.items;
  }

}

// API KEY d665f7ffb6e7edd5acde0d7eaf26f506
// IMAGEN PATH https://image.tmdb.org/t/p/w500/kqjL17yufvn9OVLyXYpvtyrFfak.jpg