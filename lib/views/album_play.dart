// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:music/constants.dart';
import 'package:music_visualizer/music_visualizer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:music/views/equalizer_page.dart';
import 'package:flutter_svg/svg.dart';

import 'package:music/providers/SongProvider.dart';
import 'package:music/providers/playlist_provider.dart';
import 'package:music/views/track_cutter.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


class album_song extends StatelessWidget {
 album_song({
    super.key,
  });
  static const namedRoute = '/album_song';

  var values = 0.0;
  bool do_state_state=false;

  @override
  Widget build(BuildContext context) {
    final ui = Provider.of<Ui_changer>(
      context,
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
         gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ui.ui_color, Colors.black.withOpacity(0.7)],  )
        ),
height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
               
                SizedBox(height: 40,),
                album_sound_volume(),
                album_play_detail(),
                
                   
                    
                    
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class album_sound_volume extends StatefulWidget {
  const album_sound_volume({super.key,});

  @override
  State<album_sound_volume> createState() => _album_sound_volumeState();
}

class _album_sound_volumeState extends State<album_sound_volume> {
  @override
  Widget build(BuildContext context) { 
    final provider = Provider.of<SongProvier>(context);
    return  SfRadialGauge(
          animationDuration: 1,
          enableLoadingAnimation: true,
          axes: [
            RadialAxis( 
              useRangeColorForAxis: true,
              startAngle: 280,
              endAngle: 150,
              canRotateLabels: false,
              interval: 0.1,
              isInversed: false,
              maximum: 1,
              minimum: 0,
              showAxisLine: true,
              showLabels: true,
              showTicks: true,
              labelFormat: '{value}',
              ranges: [
                GaugeRange(
                  startValue: 0,
                  endValue: provider.sound_volume,
                  color: Colors.red
                )
              ],
              pointers: [
                MarkerPointer(
                  color: Colors.red,
                  value: provider.sound_volume,
                  onValueChanged: (newValue) {
                    provider.change_volume(newValue);
                  },
                  enableAnimation: true,
                  enableDragging: true,
                  markerType: MarkerType.circle,
                  markerWidth: 20,
                  markerHeight: 20,
                ),
              ],
              annotations: [
                GaugeAnnotation(
                  horizontalAlignment: GaugeAlignment.center,
                  widget: NewWidget(provider: provider),
                )
              ],
            ),
          ],
        );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    required this.provider,
  });

  final SongProvier provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
      ),
      child:ClipRRect(
      borderRadius: BorderRadius.circular(200),
      child: QueryArtworkWidget(
        quality: 100,
    artworkQuality: FilterQuality.high,
    
        artworkBorder: BorderRadius.circular(8),
        artworkClipBehavior: Clip.antiAliasWithSaveLayer,
       
        artworkFit: BoxFit.cover,
        nullArtworkWidget: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: Image.asset('assets/images/cover.jpg', fit: BoxFit.cover),
        ),
        id:  provider.playingSongId,
       keepOldArtwork: true,
        type: ArtworkType.ALBUM,
      ),
    ),
    );
  }
}





class album_play_detail extends StatefulWidget {
  
  const album_play_detail({
    super.key,
  });

  @override
  State<album_play_detail> createState() => _album_play_detailState();
}

class _album_play_detailState extends State<album_play_detail> {
 
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SongProvier>(context,listen: false);
    return Column(
      children: [
        Card(
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
                        child: FutureBuilder<String>(
          future: provider.getSongTitleFromDatabaseByIds(provider.currentSong.id), // replace with your method
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        } else {
          if (snapshot.hasError)
            return Text('Error: ${snapshot.error}');
          else{
           
            return Text(
              snapshot.data.toString(), // song title
              maxLines: 1,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            );}
        }
          },
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
                    Flexible(
                      child: Text(
                        provider.songArtist,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),



        //play control
         Consumer<SongProvier>(
           builder: (context,Provider,child) {
             return Column(
                   children: [
              provider.isplaying?        Container(
                  height: 50,
                  width: double.infinity,
                  child:  MusicVisualizer(
                    barCount: 30,
                    colors: [
            Colors.white,
             
                    
              
            Colors.orange,
              Color.fromARGB(255, 69, 5, 208),
                    Colors.red,
            ],
                    duration: [900, 700, 600, 800, 500],
                ),
              ):Container(height: 50,),
                     Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${provider.currentTime}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: Slider(
                  value: provider.sliderValue,
                  onChanged: (value) {
                    provider.sliderValue = value;
             
                    provider.change_duration(value);
                  },
                  min: 0,
                  max: provider.sliderMaxVAlue,
                )),
                Text(
                  provider.totalTime,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
                     ),
                     Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      setState(() {
                          provider.previous_song(provider.currentSong);
                      });
                    
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: CircleAvatar(
                          radius: 30,
                          child: SvgPicture.asset(
                            'assets/icons/back.svg',
                            width: 25,
                          )),
                    )),
                SizedBox(
                  width: 25,
                ),
               InkWell(
                 borderRadius: BorderRadius.circular(50),
                 onTap: () {
                   provider.isplaying
                       ? provider.pause_Song()
                       : provider.resume_Song();
                 },
                 child: Container(
                   padding: EdgeInsets.all(11),
                   child: CircleAvatar(
                     radius: 32,
                     backgroundColor: Colors.red,
                     child: provider.isplaying
                         ? SvgPicture.asset(
                             'assets/icons/pause.svg',
                             width: 30,
                           )
                         : SvgPicture.asset(
                             'assets/icons/play.svg',
                             width: 30,
                           ),
                   ),
                 ),
               ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      setState(() {
                        provider.next_song(provider.currentSong);
                      });
             
                    },                  
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: CircleAvatar(
                          radius: 30,
                          child: SvgPicture.asset(
                            'assets/icons/next.svg',
                            width: 25,
                          )),
                    )),
              ],
                     ),
                     SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
                     ),
                     Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                    onTap: () {
                      provider.shuffle_song();
                    },
                    borderRadius: BorderRadius.circular(35),
                    child: Container(
                        padding: EdgeInsets.all(3),
                        child: SvgPicture.asset(
                          'assets/icons/suffle.svg',
                          width: 30,
                          color: provider.is_shuffling ? Colors.red : Colors.white,
                        ))),
                InkWell(
                  onTap: () {
                    provider.loop_song();
                  },
                  borderRadius: BorderRadius.circular(35),
                  child: Container(
                      padding: EdgeInsets.all(3),
                      child: SvgPicture.asset(
                        'assets/icons/repeat.svg',
                        width: 30,
                        color: provider.is_looping ? Colors.red : Colors.white,
                      )),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, equalizer_page.routeName);
                    },
                    icon: Icon(
                      Icons.equalizer,
                      color: Colors.white,
                      size: 34,
                    )),
                InkWell(
                    
                    child: IconButton(
                        onPressed: () async {
                          //get the absolute path of the song from uri
                          final filePath =
                              await LecleFlutterAbsolutePath.getAbsolutePath(
                                  uri: provider.currentSong.uri.toString());
                                   
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                       AudioTrimmerView(file:File(filePath!))));
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 34,
                        ))),
              ],
                     )
                   ],
                 );
           }
         )
      ],
    );
  }

  void buttomsheet(BuildContext context, SongProvier provider) {
     final ui = Provider.of<Ui_changer>(context,listen: false);
      
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [ui.ui_color, Colors.black.withOpacity(0.6)],
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
                      provider.stop_Song();
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
     final ui = Provider.of<Ui_changer>(context,listen: false );
      
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [ui.ui_color, Colors.black.withOpacity(0.6)],
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
     final ui = Provider.of<Ui_changer>(context,listen: false);
      
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor:ui.ui_color,
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
     final ui = Provider.of<Ui_changer>(context,listen: false);
      
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:ui.ui_color,
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
              onPressed: () {
                // code to rename the song
                if(controller.text.isNotEmpty){
                  
                Provider.of<SongProvier>(context,listen: false).changeSongTitle(song, controller.text);
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Song renamed successfully!')));
                 Navigator.pop(context);
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
     final ui = Provider.of<Ui_changer>(context,listen: false);
      
    showDialog(
      context: context,
      builder: (context) {
        
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor:ui. ui_color,
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
     final ui = Provider.of<Ui_changer>(context,listen: false);
      
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor:ui. ui_color,
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
