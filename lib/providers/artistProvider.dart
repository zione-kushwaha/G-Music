import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtistProvider extends ChangeNotifier {
  final audioQuery = OnAudioQuery();
  final player = AudioPlayer();
  List<ArtistModel> _artists = [];
  late ArtistModel _currentArtist;



  // Load all artists
  void loadArtists() async {
    try {
      _artists = await audioQuery.queryArtists(
        sortType: ArtistSortType.ARTIST,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true
      );
      print(_artists);
      print('Artists loaded from the device');
      notifyListeners();
    } catch (e) {
      print('Error loading artists: $e');
    }
  }

  // Get the current artist
  ArtistModel? getCurrentArtist() {
    return _currentArtist;
  }

  // Get all artists
  List<ArtistModel> getArtists() {
    return _artists;
  }
}