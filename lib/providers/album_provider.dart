import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumProvider extends ChangeNotifier {
  final audioQuery = OnAudioQuery();
  List<AlbumModel> _albums = [];

  // Load all albums
  void loadAlbums() async {
    try {
      _albums = await audioQuery.queryAlbums(
        sortType: AlbumSortType.ALBUM,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true
      );
        print('......................................................................');
      print(_albums);
      print('Albums loaded from the device');
        print('......................................................................');
      notifyListeners();
    } catch (e) {
      print('Error loading albums: $e');
    }
  }

  // Get all albums
  List<AlbumModel> getAlbums() {
    return _albums;
  }

  //function to get list of the song if albummodel is given
 
}