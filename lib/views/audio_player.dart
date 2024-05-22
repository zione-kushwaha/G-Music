// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:music/constants.dart';
import 'package:music/providers/SongProvider.dart';
import 'package:music/views/Individual_song.dart';
import 'package:music/widgets/home_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AudioPlayerss extends StatefulWidget {
  const AudioPlayerss({Key? key}) : super(key: key);

  static const routeName = '/audio_player';

  @override
  State<AudioPlayerss> createState() => _AudioPlayerssState();
}

class _AudioPlayerssState extends State<AudioPlayerss> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(microseconds: 1), () async {
      var status = await Permission.storage.request();

      if (status.isGranted) {
        await Provider.of<SongProvier>(context, listen: false).Load_songs();
        setState(() {});
      } else {
        print('permission denied');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SongProvier>(context, listen: false);

    return Column(
      children: [
        Container(
                    height: MediaQuery.of(context).size.height * 0.025,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('${provider.getSongs().length}',
                                  style: TextStyle(color: Colors.white)),
                              Consumer<SongProvier>(
                                builder: (context,provider,child) {
                                  return InkWell(
                                    onTap: (){
                                      provider.shuffle_song();
                                    },
                                    child: Icon(
                                      provider.is_shuffling?Icons.shuffle:Icons.double_arrow, color: Colors.white));
                                }
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: (){
                                  provider.previous_song( provider.currentSong);
                                },
                                child: Icon(Icons.skip_previous, color: Colors.white)),
                              InkWell(
                                onTap: (){
                                  provider.next_song(provider.currentSong);
                                },
                                child: Icon(Icons.skip_next, color: Colors.white)),
                              Icon(Icons.check_circle_outline,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
        Expanded(
          child: ListView.builder(
            itemCount: provider.getSongs().length,
            itemBuilder: (context, index) {
              final song = provider.updatedSongs[index];
              final real = provider.getSongs()[index];
          
              return ListTile(
                onTap: () {
                  if(provider.currentSong.id!=song.id){
                    print('.............................................................');
                    print(song.uri);
                    print('.............................................................')  ;
                    provider.play_song(real);
                    Navigator.pushNamed(context, Individual_song.namedRoute);
                  }
                  else{
                    Navigator.pushNamed(context, Individual_song.namedRoute);
                  }
                },
                leading: QueryArtworkWidget(
                  quality: 100,
                  artworkBorder: BorderRadius.circular(25),
                  artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                  keepOldArtwork: true,
                  artworkFit: BoxFit.cover,
                  nullArtworkWidget: CircleAvatar(
                    radius: 23,
                    child: Icon(Icons.music_note, color: Colors.white, size: 40),
                  ),
                  id: song.albumId,
                  type: ArtworkType.ALBUM,
                ),
                title: Text(provider.updatedSongs[index].title,
                    maxLines: 1, style: TextStyle(color: Colors.white)),
                subtitle: Text('${song.artist}',
                    maxLines: 1, style: TextStyle(color: Colors.grey)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (provider.currentSong.id == song.id)
                      ValueListenableBuilder<bool>(
                        valueListenable: ValueNotifier(provider.isplaying),
                        builder: (BuildContext context, value, Widget? child) {
                          return MiniMusicVisualizer(
                            color: white,
                            width: 4,
                            height: 18,
                            radius: 2,
                            animate: value,
                          );
                        },
                      ),
                    IconButton(
                      onPressed: () {},
                      icon:  Icon(Icons.more_vert,color: white.withOpacity(0.7),),
                    )
                  ],
                ),
              );
            }
          ),
        ),
          PlayerHome()
      ],
    );
  }
}