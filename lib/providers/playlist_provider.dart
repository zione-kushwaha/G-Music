//playlist proivder class
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class playlistProvider extends ChangeNotifier {
  List<PlaylistModel> _playlists = [];
  OnAudioQuery audioQuery = OnAudioQuery();

  List<PlaylistModel> get playlists => _playlists.reversed.toList();
// Function to create the playlist
  Future<void> createPlaylist(String name) async {
    try {
      if (!_playlists.any((element) => element.playlist == name)) {
        await audioQuery.createPlaylist(name);
        _playlists = await audioQuery.queryPlaylists();
        notifyListeners();
      } else {
        print('Playlist already exists');
      }
    } catch (e) {
      print('Failed to create playlist: $e');
    }
  }

  //function to add the song to the playlist
  void addSongToPlaylist(String playlistname, SongModel song) async {
    try {
      if (_playlists.any((element) => element.playlist == playlistname)) {
        audioQuery.addToPlaylist(
            _playlists
                .firstWhere((element) => element.playlist == playlistname)
                .id,
            song.id);
        _playlists = await audioQuery.queryPlaylists();
        notifyListeners();
      } else {
        await createPlaylist(playlistname);
        _playlists = await audioQuery.queryPlaylists(); // Refresh _playlists
        addSongToPlaylist(playlistname, song);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

// function to load the playlist
  void loadPlaylist() async {
    print('Loading the song of playlist ');
    _playlists = await audioQuery.queryPlaylists();

    print(_playlists);

    print('.............................................................');
    notifyListeners();
    print(_playlists.length);
    print('Loading the song of playlist ');
  }

// function to delete the playlist from it's name
  void deletePlaylist(String playlistname) async {
    if (_playlists.any((element) => element.playlist == playlistname)) {
      await audioQuery.removePlaylist(_playlists
          .firstWhere((element) => element.playlist == playlistname)
          .id);
      _playlists.removeWhere((element) => element.playlist == playlistname);
      _playlists = await audioQuery.queryPlaylists();
      notifyListeners();
    } else {
      print('Playlist does not exist');
    }
  }
}

