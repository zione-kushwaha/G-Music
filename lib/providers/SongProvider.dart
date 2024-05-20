// ignore_for_file: unused_field, non_constant_identifier_names

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import '../database/databaseHelper.dart';

class song {
  final int id;
  String title;
  final String artist;
  final String album;
  final String genre;
  final int albumId;
  final String uri;

  song(
      {required this.id,
      required this.title,
      required this.genre,
      required this.artist,
      required this.album,
      required this.albumId,
      required this.uri});
}

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
  List<song> _updatedSongs = [];

  //initializing the current song to the first song in the list
  void initializing_updatedSongs() {
    _updatedSongs = _songs
        .map((e) => song(
            id: e.id,
            title: e.title,
            artist: e.artist ?? 'unknown',
            album: e.album ?? 'unknown',
            albumId: e.albumId!,
            genre: e.genre ?? 'unknown',
            uri: e.uri!))
        .toList();
  }

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
   await  updateSongTitleFromDatabaseById(song.id);
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
          next_song(song);
        }
      });

     
        notifyListeners();
     
    } catch (e) {
      print(e);
    }
  }

  //function to that give the song title from the database if i give the song id of song that title is changed
  Future<String> getSongTitleFromDatabaseByIds(int songId) async {
final List<Map<String, dynamic>> rows = await databasehelper.queryTitleChangeRow(songId);
 // If the song id is found in the database, update the songTitle variable
  if (rows.isNotEmpty) {
    songTitle =rows[0]['new_title'];
    
    notifyListeners();
     return songTitle;
     
  }else{
    songTitle=currentSong.title;
   
    notifyListeners();
    return songTitle;
  }
  }



 Future< void> updateSongTitleFromDatabaseById(int songId) async {
  // Query the database for the song id
  final List<Map<String, dynamic>> rows = await databasehelper.queryTitleChangeRow(songId);

  // If the song id is found in the database, update the songTitle variable
  if (rows.isNotEmpty) {
    songTitle =rows[0]['new_title'];
     WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
  }else{
    songTitle=currentSong.title;
     WidgetsBinding.instance.addPostFrameCallback((_) {
    notifyListeners();
  });
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
  void next_song(SongModel song) async {
    try {
      if (is_shuffling) {
        // If shuffling is enabled, play a random song from the list
        int randomIndex = Random().nextInt(_songs.length-1);
        play_song(_songs[randomIndex]);
        playingSongId = _songs[randomIndex].albumId!;
    await    getSongTitleFromDatabaseByIds(currentSong.id);
  
      } else {
        
        // If shuffling is not enabled, play the next song in the original order
        int currentIndex =
            _songs.indexWhere((element) => element.title == song.title);
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
  void previous_song(SongModel song) async {
    try {
      if (is_shuffling) {
        // If shuffling is enabled, play a random song from the list
        int randomIndex = Random().nextInt(_songs.length - 1);
        play_song(_songs[randomIndex]);
        playingSongId = _songs[randomIndex].albumId!;
        songTitle = await    getSongTitleFromDatabaseByIds(currentSong.id);
      } else {
        // If shuffling is not enabled, play the previous song in the original order
        int currentIndex =
            _songs.indexWhere((element) => element.title == song.title);
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

  }

//funcation to load the song when application starts
  Future<void> Load_songs() async {
    _songs = await audioQuery.querySongs(
      sortType: SongSortType.ALBUM,
      orderType: OrderType.ASC_OR_SMALLER,
      ignoreCase: true,
      uriType: UriType.EXTERNAL,
    );
 initializing_updatedSongs();
    
    if (_songs.isNotEmpty) {
      final albumId = _songs[0].albumId; // Get the album id from the first song

      await audioQuery.queryArtwork(albumId!, ArtworkType.ALBUM);
      // ...
      await modifyUpdatedSongs();
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
      } else if (permission.isPermanentlyDenied) {
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
      final bool success =
          await platform.invokeMethod('deleteSong', {'uri': song.uri});
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

 Future<void> changeSongTitle(SongModel song, String newTitle) async {
    // Update the song's title in the database
    print('changeing song title');
    final Map<String, dynamic> row = {
      'song_id': song.id,
      'new_title': newTitle,
      'old_title': song.title
    };
    await databasehelper.insertTitleChange(row);
  await  modifyUpdatedSongs();
 WidgetsBinding.instance.addPostFrameCallback((_) {
    notifyListeners();
  });
  }

// getter to get the song mode list
  List<song> get updatedSongs => _updatedSongs;

//function to modify the updated song list if any title is changed that changed title will be get from the database
  Future<void> modifyUpdatedSongs() async {
    final List<Map<String, dynamic>> titleChangeRows =
        await databasehelper.queryAllTitleChangeRows();
    for (final Map<String, dynamic> row in titleChangeRows) {
      final int songId = row['song_id'];
      final String newTitle = row['new_title'];
      final int index =
          _updatedSongs.indexWhere((element) => element.id == songId);
      if (index != -1) {
        _updatedSongs[index].title = newTitle;
      }
    }
     WidgetsBinding.instance.addPostFrameCallback((_) {
    notifyListeners();
  });
   
  }
  //function to print recod of the song title change history
  Future<void> printTitleChangeHistory() async {
    print('hellow');
   try{
     final List<Map<String, dynamic>> titleChangeRows =
        await databasehelper.queryAllTitleChangeRows();
    for (final Map<String, dynamic> row in titleChangeRows) {
      print('........................data of song title change history..................');
      print(row);
    }
   }catch(e){
    print('$e error in printing the title change history');
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

  //function to get all the row of the recently played songs
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await databasehelper.queryAllRows();
  }
  //funtion to delete all the row of the recently played songs
  Future<void> deleteAll() async {
    await databasehelper.deleteAll();
    notifyListeners();
  }
  //funtion to get the no of row in the recently played songs
  Future<int?> getRowCount() async {
    return await databasehelper.getRowCount();
  }
}
