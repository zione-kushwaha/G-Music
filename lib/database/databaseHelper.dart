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

 //creation of table for storing the song title change history
    await db.execute('''

  CREATE TABLE IF NOT EXISTS song_title_change_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    old_title TEXT,
    new_title TEXT,
    song_id INTEGER
  )
  ''');

  // creation of the table for storing the facvourite song in the dataabase
  await db.execute('''
  CREATE TABLE IF NOT EXISTS favourite_songs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    artist TEXT,
    album TEXT,
    albumId INTEGER
  )''');

    
  }

  //function to insert in the table favourite songs
  Future<int> insertFavourite(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert('favourite_songs', row);
  }
  //function to query all the rows in the table favourite songs
  Future<List<Map<String, dynamic>>> queryAllFavouriteRows() async {
    Database? db = await instance.database;
    return await db!.query('favourite_songs', orderBy: 'id DESC');
  }
  //function to delete a row in the table favourite songs
  Future<int> deleteFavourite(int id) async {
    Database? db = await instance.database;
    return await db!.delete('favourite_songs', where: 'id = ?', whereArgs: [id]);
  }

//function to insert in the table recently played songs
 //function to insert in the table recently played songs
Future<int> insert(Map<String, dynamic> row) async {
  Database? db = await instance.database;
  
  // Check if the song already exists
  var existingSong = await db!.query('recent_played_songs', where: 'title = ? AND artist = ? AND album = ?', whereArgs: [row['title'], row['artist'], row['album']]);
  if (existingSong.isNotEmpty) {
    // If the song exists, delete it
    await db.delete('recent_played_songs', where: 'id = ?', whereArgs: [existingSong.first['id']]);
  }

  // Insert the new song
  int result = await db.insert('recent_played_songs', row);

  // Check the total number of songs
  var count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM recent_played_songs'));
  if (count != null && count > 30) {
    // If the total number of songs exceeds 30, delete the oldest song
    var oldestSong = await db.query('recent_played_songs', orderBy: 'id ASC', limit: 1);
    await db.delete('recent_played_songs', where: 'id = ?', whereArgs: [oldestSong.first['id']]);
  }

  return result;
}

//funtion to delete all the rows in the table recently played songs
Future<int> deleteAll() async {
  Database? db = await instance.database;
  return await db!.delete('recent_played_songs');
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

  //function to get the no of row in the table recently played songs
  Future<int?> getRowCount() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM recent_played_songs'));
  }


 //function to check if the song title is already in the table
Future<int?> checkTitleChange(int songId) async {
  Database? db = await instance.database;
  var result = await db!.query('song_title_change_history', where: 'song_id = ?', whereArgs: [songId]);
  return result.isNotEmpty ? (result.first['id'] as int?) : null;
}

//function to insert in the table song title change history
Future<int> insertTitleChange(Map<String, dynamic> row) async {
  // checking if the song title is already in the table
  int? existingId = await checkTitleChange(row['song_id']);
  if (existingId != null) {
    row['id'] = existingId; // add the id to the row
    updateTitleChange(row);
    return 0;
  } else {
    Database? db = await instance.database;
    return await db!.insert('song_title_change_history', row);
  }
}
  

  //function to query all the rows in the table song title change history
  Future<List<Map<String, dynamic>>> queryAllTitleChangeRows() async {
    Database? db = await instance.database;
    return await db!.query('song_title_change_history', orderBy: 'id DESC');
  }
  //function to delete a row in the table song title change history
  Future<int> deleteTitleChange(int id) async {
    Database? db = await instance.database;
    return await db!.delete('song_title_change_history', where: 'id = ?', whereArgs: [id]);
  }
  //function to query a row with the song id in the table song title change history
  Future<List<Map<String, dynamic>>> queryTitleChangeRow(int songId) async {
    Database? db = await instance.database;
    return await db!.query('song_title_change_history', where: 'song_id = ?', whereArgs: [songId]);
  }

  //function to update a row in the table song title change history
  Future<int> updateTitleChange(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.update('song_title_change_history', row, where: 'id = ?', whereArgs: [row['id']]);
  }

}