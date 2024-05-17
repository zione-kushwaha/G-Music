//create a table for storing the recently played 10 songs

import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseHelper {
  static const _databaseName = "user_db";
  static const _databaseVersion = 2;
  //creating the private constructor
  DatabaseHelper._privateconstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateconstructor();

  static Database? _database;
  //creating the getter to get the database
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDb();
      return _database;
    }
  }

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: oncreate);
  }

  Future oncreate(Database db, int version) async {
    //creation of the recently played song in the database


  
await db.execute('''
  CREATE TABLE IF NOT EXISTS recent_played_songs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    artist TEXT,
    album TEXT,
    albumId INTEGER
  )
''');

   //cretion of the playlist table in the database
    await db.execute('''
    CREATE TABLE IF NOT EXISTS playlist (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      playlist_name TEXT,
      song_name TEXT,
      is_favorite INTEGER,
      artist_name TEXT,
      albumId INTEGER
    )'''
    );

    
  }

//function to insert in the table recently played songs
 Future<int> insert(Map<String, dynamic> row) async {
  Database? db = await instance.database;
  var count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM recent_played_songs'));
  if (count != null && count > 10) {
    await db.delete('recent_played_songs', where: 'id = ?', whereArgs: [1]);
  }
  return await db.insert('recent_played_songs', row);
}

  //function to query all the rows in the table recently played songs
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query('recent_played_songs', orderBy: 'id DESC');
  }

  //function to delete a row in the table recently played songs
  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete('recent_played_songs', where: 'id = ?', whereArgs: [id]);
  }

  // function to insert in the table playlist
  Future<int> insertPlaylist(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert('playlist', row);
  }

  //function to query all the rows in the table playlist
  Future<List<Map<String, dynamic>>> queryAllPlaylist() async {
    Database? db = await instance.database;
    return await db!.query('playlist');
  }

  //function to delete a row in the table playlist
  Future<int> deletePlaylist(int id) async {
    Database? db = await instance.database;
    return await db!.delete('playlist', where: 'id = ?', whereArgs: [id]);
  }

  //function to get list of all the song if name of playlist is given
  Future<List<Map<String, dynamic>>> queryAllPlaylists(String playlistName) async {
    Database? db = await instance.database;
    return await db!.query('playlist', where: 'playlist_name = ?', whereArgs: [playlistName]);
  }

  //function to get the last row album id if the name of the playlist is given
  Future<int> queryAlbumId(String playlistName) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> albumId = await db!.query('playlist', where: 'playlist_name = ?', whereArgs: [playlistName]);
    return albumId[albumId.length - 1]['albumId'];
  }

  //function to get the list of different playlist only with the last song ablumid and playlist name
  Future<List<Map<String, dynamic>>> queryAllPlaylistName() async {
    Database? db = await instance.database;
    return await db!.query('playlist', columns: ['playlist_name', 'albumId'], distinct: true);
  }
}