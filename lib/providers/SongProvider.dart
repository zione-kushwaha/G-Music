// ignore_for_file: unused_field

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:just_audio/just_audio.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';



import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import '../database/databaseHelper.dart';

class SongProvier extends ChangeNotifier {
  final audioQuery = OnAudioQuery();
  final databasehelper = DatabaseHelper.instance;
  final player = AudioPlayer();

  late bool _isplaying = false;
  bool get isplaying => _isplaying;
  String currentTime = '0';
  String totalTime = '0';
  double sliderValue = 0.0;
  double sliderMaxVAlue = 0.0;
  String songTitle = '';
  String songArtist = '';
  int playingSongId = 0;
  bool is_looping = false;
  bool is_shuffling = false;

  //empty list of songs
  List<SongModel> _songs = [];

  late SongModel currentSong = _songs[0];
  // double sound_volume = 0.2;-------------------

  double _sound_volume = 0.4;
  final _semaphore = Future<void>.value();

  double get sound_volume => _sound_volume;

  void change_volume(double newVolume) async {
    try {
      _sound_volume = newVolume;
      await player.setVolume(newVolume);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // function to play the song and pause the song
  void play_song(SongModel song) async {
    try {
      currentSong = song;
      songTitle = song.title;
      playingSongId = song.albumId!;
      songArtist = song.artist ?? 'unknown';
      await player.setAudioSource(AudioSource.uri(Uri.parse(song.uri!)));

      player.play();
      Map<String, dynamic> row = {
        'title': song.title,
        'artist': song.artist,
        'album': song.album,
        'albumId': song.albumId,
      };

      await databasehelper.insert(row);

      update_time();
      _isplaying = true;
      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          next_song();
        }
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  //function to stop the song
  void stop_Song() async {
    try {
      _isplaying = false;
      player.stop();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

//function to pause the song
  void pause_Song() async {
    try {
      _isplaying = false;
      player.pause();

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // function to resume the song
  void resume_Song() async {
    try {
      print('resuming the music ');
      _isplaying = true;
      player.play();

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // function to update the time of the song
  void update_time() {
    try {
      player.durationStream.listen((event) {
        totalTime = event.toString().split(".")[0];
        sliderMaxVAlue = event!.inSeconds.toDouble();
        notifyListeners();
      });
      player.positionStream.listen((event) {
        currentTime = event.toString().split(".")[0];
        sliderValue = event.inSeconds.toDouble();
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  // function to change duration of song playing
  void change_duration(double value) {
    player.seek(Duration(seconds: value.toInt()));
  }

// function to play the next song
  void next_song() async {
    try {
      if (is_shuffling) {
        // If shuffling is enabled, play a random song from the list
        int randomIndex = Random().nextInt(_songs.length - 1);
        play_song(_songs[randomIndex]);
        playingSongId = _songs[randomIndex].albumId!;
      } else {
        // If shuffling is not enabled, play the next song in the original order
        int currentIndex =
            _songs.indexWhere((element) => element.title == songTitle);
        if (currentIndex < _songs.length - 1) {
          play_song(_songs[currentIndex + 1]);
          playingSongId = _songs[currentIndex + 1].albumId!;
        } else {
          play_song(_songs[0]);
          playingSongId = _songs[0].albumId!;
        }
      }
    } catch (e) {
      print(e);
    }
  }

// function to play the previous song
  void previous_song() async {
    try {
      if (is_shuffling) {
        // If shuffling is enabled, play a random song from the list
        int randomIndex = Random().nextInt(_songs.length - 1);
        play_song(_songs[randomIndex]);
        playingSongId = _songs[randomIndex].albumId!;
      } else {
        // If shuffling is not enabled, play the previous song in the original order
        int currentIndex =
            _songs.indexWhere((element) => element.title == songTitle);
        if (currentIndex > 0) {
          play_song(_songs[currentIndex - 1]);
          playingSongId = _songs[currentIndex - 1].albumId!;
        } else {
          play_song(_songs[_songs.length - 1]);
          playingSongId = _songs[_songs.length - 1].albumId!;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  //function to implement the looping song functionality
  void loop_song() async {
    try {
      if (is_looping) {
        player.setLoopMode(LoopMode.off);
        is_looping = false;
      } else {
        player.setLoopMode(LoopMode.one);
        is_looping = true;
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

//function to implement the shuffle song functionality
  void shuffle_song() async {
    try {
      if (is_shuffling) {
        player.setShuffleModeEnabled(false);
        is_shuffling = false;
      } else {
        player.setShuffleModeEnabled(true);
        is_shuffling = true;
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }

    //function to rename the title of the song of the device
    // void rename_song(String newTitle) async {
    //   try {
    //     await audioQuery.removeFromPlaylist(playlistId, audioId);
    //   } catch (e) {
    //     print(e);
    // }

    // //function to delete the song from the device
    // void delete_song() async {
    //   try {
    //     await audioQuery.removeFromPlaylist(playlistId, audioId);
    //   } catch (e) {
    //     print(e);
    //   }
  }

//funcation to load the song when application starts
  Future<void> Load_songs() async {
    _songs = await audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      ignoreCase: true,
      uriType: UriType.EXTERNAL,
    );
    if (_songs.isNotEmpty) {
      final albumId = _songs[0].albumId; // Get the album id from the first song

      await audioQuery.queryArtwork(albumId!, ArtworkType.ALBUM);
      // ...
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  //function to get the list of songs
  List<SongModel> getSongs() {
    return _songs;
  }


// for ringtone setting
  static const MethodChannel _channel =
      MethodChannel('com.example.myapp/ringtone');

  Future<void> requestWriteSettingsPermission() async {
    try {
      await _channel.invokeMethod('requestWriteSettingsPermission');
    } on PlatformException catch (e) {
      print("Failed to request write settings permission: '${e.message}'.");
    }
  }

Future<void> storagePermission() async {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    var permission = await Permission.storage.request();

    if (permission.isGranted) {
      Load_songs();
    }else if (permission.isPermanentlyDenied) {
      openAppSettings();
    } else {
      await storagePermission();
    }
  });
}

  // write settings permission
  Future<bool> write_permission() async {
    var write = await Permission.manageExternalStorage.request();
    if (write.isGranted) {
      return true;
    } else {
      if (write.isDenied) {
        print("Permission denied, please grant the necessary permissions.");
        return false;
      } else if (write.isPermanentlyDenied) {
        openAppSettings();
        return false;
      }
      await requestWriteSettingsPermission();
      return false;
    }
  }



  




void delete_song(SongModel song) async {
  print('deleting the song ..............................................');
  try {
    const platform = const MethodChannel('com.example.myapp/ringtone');
    final bool success = await platform.invokeMethod('deleteSong', {'uri': song.uri});
    if (success) {
     //refreshing _song list
      _songs.remove(song);
     
      
      notifyListeners();
      print('song deleted successfully');
    } else {
      print('failed to delete song');
    }
  } on PlatformException catch (e) {
    print('Failed to delete song: ${e.message}');
  }
}

// function to change the name 
void changeSongTitle(SongModel song, String newTitle) async {
  try {
    const platform = MethodChannel('com.example.myapp/ringtone');
    
    final bool success = await platform.invokeMethod('changeSongTitle', {'uri': song.uri, 'newTitle': newTitle});
    if (success) {
      print('Successfully changed song title');
    } else {
      print('Failed to change song title');
    }
  } on PlatformException catch (e) {
    print('Failed to change song title: ${e.message}');
  }
}


  // function that gives list of song model when i give the album model
  List<SongModel> getAlbumSongs(AlbumModel album) {
    return _songs.where((element) => element.album == album.album).toList();
  }

// function that give list of song model when i give artist model
  List<SongModel> getArtistSongs(ArtistModel artist) {
    return _songs.where((element) => element.artist == artist.artist).toList();
  }

// function that give list of song model when i give genre model
  List<SongModel> getGenreSongs(GenreModel genre) {
    return _songs.where((element) => element.genre == genre.genre).toList();
  }
}





