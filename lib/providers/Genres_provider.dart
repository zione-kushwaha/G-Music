import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GenresProvider extends ChangeNotifier {
  final audioQuery = OnAudioQuery();
  final player = AudioPlayer();
  List<GenreModel> _genres = [];
  late GenreModel _currentGenre;

  // Load all genres
  void loadGenres() async {
    try {
      _genres = await audioQuery.queryGenres(
        sortType: GenreSortType.GENRE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true
      );
      print(_genres[0]);
      print('Genres loaded from the device');
      notifyListeners();
    } catch (e) {
      print('Error loading genres: $e');
    }
  }

  // Get the current genre
  GenreModel? getCurrentGenre() {
    return _currentGenre;
  }

  // Get all genres
  List<GenreModel> getGenres() {
    return _genres;
  }
}