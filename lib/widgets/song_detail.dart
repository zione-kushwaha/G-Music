import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:music/constants.dart';
import 'package:music/providers/SongProvider.dart';
import 'package:music/providers/playlist_provider.dart';
import 'package:music/views/track_cutter.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class song_detail extends StatelessWidget {
  const song_detail({
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SongProvier>(context);
    return Card(
      color: white.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/icons/play_outline.svg'),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '120 Play',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(
                  provider.songTitle,
                  maxLines: 1,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
                IconButton(
                    onPressed: () {
                      buttomsheet(context, provider);
                    },
                    icon: Icon(Icons.more_vert))
              ],
            ),
            Row(
              children: [
                Text(
                  provider.songArtist,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void buttomsheet(BuildContext context, SongProvier provider) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [ui_color, Colors.black.withOpacity(0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28))),
            child: Container(
              //  color: Colors.transparent,
              width: double.infinity,
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QueryArtworkWidget(
                          id: provider.playingSongId, type: ArtworkType.ALBUM),
                      Flexible(
                        child: Container(
                            margin: EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: Text(
                              " ${provider.currentSong.title}",
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.info_outline,
                            size: 30,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.share_outlined,
                            size: 30,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.018),
                  Divider(
                    height: 1,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  ListTile(
                    onTap: () {
                      Provider.of<SongProvier>(context, listen: false)
                          .shuffle_song();
                      Navigator.pop(context);
                    },
                    leading: Icon(
                      Icons.shuffle,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Shuffle',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Provider.of<SongProvier>(context, listen: false)
                          .loop_song();
                      Navigator.pop(context);
                    },
                    leading: Icon(
                      Icons.repeat,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Loop',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      // code to add the song to playlist
                      Navigator.pop(context);
                      playlist_bottom_sheet(
                          Provider.of<playlistProvider>(context, listen: false),
                          context);
                    },
                    leading: Icon(
                      Icons.playlist_add,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Add to Playlist',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      // code for rename the song
                      renameSongPopup(context,provider.currentSong);
                    },
                    leading: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Rename',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      //code to cut the track
                      final filePath =
                          await LecleFlutterAbsolutePath.getAbsolutePath(
                              uri: provider.currentSong.uri.toString());

                      Navigator.pushNamed(context, AudioTrimmerView.routeName,
                          arguments: {'file': File(filePath!)});
                      ;
                    },
                    leading: Icon(
                      Icons.content_cut,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Cut track',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      //code to set the song as ringtone

                      setRingtonePopup(context, provider.currentSong);
                    },
                    leading: Icon(
                      Icons.vibration,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Set as ringtone',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      //code for delete the song from the device
                      
                      deleteSongPopup(context);
                    },
                    leading: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Delete from device',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // function to show the modalbottom sheet for adding item in the playlist
  void playlist_bottom_sheet(playlistProvider playlist, context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [ui_color, Colors.black.withOpacity(0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28))),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add to Playlist',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.018),
                  Divider(
                    height: 1,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  ListTile(
                    onTap: () {
                      createPlaylistPopup(context);
                    },
                    leading: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Create new playlist',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: playlist.playlists.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(left: 12),
                          child: ListTile(
                            onTap: () {
                              playlist.addSongToPlaylist(
                                  playlist.playlists[index].playlist,
                                  Provider.of<SongProvier>(context,
                                          listen: false)
                                      .currentSong);
                              Navigator.pop(context);
                            },
                            leading: SvgPicture.asset(
                              'assets/icons/heart.svg',
                              width: 25,
                            ),
                            title: Text(
                              playlist.playlists[index].playlist,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  // function to show the popup menu button for input of playlist name
  void createPlaylistPopup(BuildContext context) {
    TextEditingController controller = TextEditingController();
    final provider = Provider.of<SongProvier>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: ui_color,
          title: Text('Create new Playlist',
              style: TextStyle(fontSize: 20, color: white)),
          content: TextField(
            controller: controller,
            style: TextStyle(color: white),
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter the playlist name',
              hintStyle: TextStyle(color: white.withOpacity(0.7)),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: white),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // code to create the playlist

                if (!controller.text.isEmpty) {
                  Provider.of<playlistProvider>(
                    context,
                    listen: false,
                  ).addSongToPlaylist(controller.text, provider.currentSong);

                  Navigator.pop(context);
                } else {
                  return;
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

// function to show the the dialog for input of rename of song
  void renameSongPopup(BuildContext context,SongModel song) {
    TextEditingController controller=TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ui_color,
          title: Text(
            'Rename Song',
            style: TextStyle(color: white),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: TextStyle(color: white),
            decoration: InputDecoration(
                hintText: 'Enter the song name',
                hintStyle: TextStyle(color: white.withOpacity(0.7)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: white), // Change 'white' to 'Colors.red'
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: white), // Change 'white' to 'Colors.red'
                )),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // code to rename the song
                if(controller.text.isNotEmpty){
                  
                Provider.of<SongProvier>(context,listen: false).changeSongTitle(song, controller.text);
              }else{
                return;
              }
                Navigator.pop(context);},
              child: Text('Rename'),
            ),
          ],
        );
      },
    );
  }

// function to show the alert dialog for the delete the song
  void deleteSongPopup(BuildContext context) {
    final provider = Provider.of<SongProvier>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: ui_color,
          title: Text('Are you sure to Delete this Song?',
              style: TextStyle(fontSize: 20, color: white)),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // code to delete the song
                          
               
                 bool success = false;
                  try {
                     provider.delete_song(provider.currentSong);
                     success=true;
                  } on PlatformException {
                    success = false;
                  }
                  SnackBar snackBar;
                  if (success) {
                    snackBar = const SnackBar(
                      content: Text("Deleted successfully!"),
                    );
                  } else {
                    snackBar = const SnackBar(content: Text("Error"));
                  }
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.pop(context);
                  Navigator.pop(context);              
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  //function to show the alert dialog for set song as ringtone
  void setRingtonePopup(BuildContext context, SongModel song) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: ui_color,
          title: Text('Are you sure to set this as Ringtone?',
              style: TextStyle(fontSize: 20, color: white)),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // code to set the song as ringtone

                if (await Provider.of<SongProvier>(context, listen: false)
                    .write_permission()) {
                  bool success = false;
                  try {
                    success = await RingtoneSetter.setRingtone(song);
                  } on PlatformException {
                    success = false;
                  }
                  SnackBar snackBar;
                  if (success) {
                    snackBar = const SnackBar(
                      content: Text("Ringtone set successfully!"),
                    );
                  } else {
                    snackBar = const SnackBar(content: Text("Error"));
                  }
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  await Provider.of<SongProvier>(context, listen: false)
                      .write_permission();
                }
              },
              child: Text('Set'),
            ),
          ],
        );
      },
    );
  }
}

class RingtoneSetter {
  static const platform = const MethodChannel('com.example.myapp/ringtone');
  static Future<bool> setRingtone(SongModel song) async {
    try {
      print('Setting ringtone with URI: ${song.uri}');
      final bool success =
          await platform.invokeMethod('setRingtone', {'uri': song.uri});
      print('method called successfully');
      return success;
    } on PlatformException catch (e) {
      print("Failed to set ringtone: '${e.message}'.");
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
