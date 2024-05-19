// // provider for favourite song 
// import 'package:flutter/material.dart';
// import 'package:music/database/databaseHelper.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// class Favourite_songs with ChangeNotifier {
//   DatabaseHelper databaseHelper = DatabaseHelper.instance;
//   List<SongModel> _favourite_songs = [];

//   List<SongModel> get favourite_songs {
//     return [..._favourite_songs];
//   }
//   //function to load the favourite songs from the database
//   Future<void> load_favourite_songs() async {
   
//     List<SongModel> temp = [];
//     List<Map<String, dynamic>> rows = await databaseHelper.queryAllFavouriteRows();
//     for (var row in rows) {
//       SongModel song = SongModel(
//         id: row['id'],
//         title: row['title'],
//         artist: row['artist'],
//         album: row['album'],
//         albumId: row['albumId'],
//       );
//       temp.add(song);
//     }
//     _favourite_songs = temp;
//     notifyListeners();
//   }

//   void add_favourite_song(SongModel song)async {
//       Map<String, dynamic> row = {
//         'title': song.title,
//         'artist': song.artist,
//         'album': song.album,
//         'albumId': song.albumId,
//       };
// await databaseHelper.insertFavourite(row);
//     _favourite_songs.add(song);
//     notifyListeners();
//   }
//   //function to query all the rows in the table favourite songs
//   Future<void> queryAllFavouriteRows() async {
//     List<SongModel> temp=[];
//     temp=await OnAudioQuery().querySongs();
//     List<Map<String, dynamic>> rows = await databaseHelper.queryAllFavouriteRows();
//     List<SongModel> temp = [];
//     for (var row in rows) {
     
//     }
//     _favourite_songs = temp;
//     notifyListeners();
//   }

//   void remove_favourite_song(SongModel song) {
//     _favourite_songs.remove(song);
//     notifyListeners();
//   }
// }