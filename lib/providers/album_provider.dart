import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumProvider extends ChangeNotifier {
  final audioQuery = OnAudioQuery();
  List<AlbumModel> _albums = [];
 final player = AudioPlayer();
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
// funtion to play album
// Function to play album starting from a specific song
void playAlbum(AlbumModel album, SongModel startSong) async {
  try {
    // Fetch all songs from the album
    List<SongModel> songs = await audioQuery.queryAudiosFrom(
      AudiosFromType.ALBUM,
      album.album,
    );

    // Find the index of the start song in the list
    int startIndex = songs.indexWhere((song) => song.id == startSong.id);

    // Create a list of AudioSource objects from the songs
    List<AudioSource> audioSources = songs.map(
      (song) => AudioSource.uri(Uri.parse(song.uri!)),
    ).toList();

    // Create a ConcatenatingAudioSource with the list of songs
    var albumSource = ConcatenatingAudioSource(children: audioSources);

    // Set the audio source in the player
    await player.setAudioSource(albumSource);

    // Seek to the start song and play the album
    player.seek(Duration.zero, index: startIndex);
    player.play();
  } catch (e) {
    print('Error playing album: $e');
  }
}
   
 // Fetch all songs from the album

// Function to play the next song in the album
void nextSong() {
  try {
    player.seekToNext();
  } catch (e) {
    print('Error playing next song: $e');
  }
}

// Function to play the previous song in the album
void previousSong() {
  try {
    player.seekToPrevious();
  } catch (e) {
    print('Error playing previous song: $e');
  }
}

// Function to pause the album
void pauseAlbum() {
  try {
    player.pause();
  } catch (e) {
    print('Error pausing album: $e');
  }}

// Function to resume the album
void resumeAlbum() {
  try {
    player.play();
  } catch (e) {
    print('Error resuming album: $e');
  }}

// Function to stop the album
void stopAlbum() {
  try {
    player.stop();
  } catch (e) {
    print('Error stopping album: $e');
  }}

// Function to seek to a specific position in the album
void seekTo(Duration position) {
  try {
    player.seek(position);
  } catch (e) {
    print('Error seeking to position: $e');
  }}

// Function to get the current playback position

 
}