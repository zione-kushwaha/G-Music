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