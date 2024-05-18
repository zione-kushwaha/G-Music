// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:glossy/glossy.dart';
import 'package:music/constants.dart';
import 'package:music/providers/SongProvider.dart';
import 'package:music/views/Individual_song.dart';
import 'package:music/widgets/home_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AudioPlayerss extends StatefulWidget {
  const AudioPlayerss({Key? key}) : super(key: key);

  static const routeName = '/audio_player';

  @override
  State<AudioPlayerss> createState() => _AudioPlayerssState();
}

class _AudioPlayerssState extends State<AudioPlayerss> {
  late Future<void> loadSongsFuture;

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<SongProvier>(context, listen: false);

    loadSongsFuture = provider.Load_songs();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SongProvier>(context, listen: false);

    return FutureBuilder(
      future: loadSongsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: ui_color,
          ));
        } else {
          return Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  
              
                    //    GlossyContainer(
                    // width: double.infinity,
                    // height: MediaQuery.of(context).size.height * 0.7,
                    // borderRadius: BorderRadius.circular(12),
                  Container(
                    height: 25,
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
                              Icon(Icons.shuffle, color: Colors.white),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.skip_previous, color: Colors.white),
                              Icon(Icons.skip_next, color: Colors.white),
                              Icon(Icons.check_circle_outline,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                 
                    height: MediaQuery.of(context).size.height * 0.6995,
                    child: list_builer_audio_player()),
                    
                    PlayerHome()
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class list_builer_audio_player extends StatelessWidget {
  const list_builer_audio_player({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SongProvier>(context, listen: false);

    return ListView.builder(
      // shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: provider.getSongs().length,
      itemBuilder: (context, index) {
        final song = provider.updatedSongs[index];
        final real = provider.getSongs()[index];
    
        return ListTile(
          onTap: () {
            provider.play_song(real);
    
            Navigator.pushNamed(context, Individual_song.namedRoute);
          },
          leading: QueryArtworkWidget(
            quality: 100,
            artworkBorder: BorderRadius.circular(25),
            artworkClipBehavior: Clip.antiAliasWithSaveLayer,
            artworkFit: BoxFit.cover,
            nullArtworkWidget: CircleAvatar(
              radius: 23,
              child: Icon(Icons.music_note, color: Colors.white, size: 40),
            ),
            id: song.id,
            type: ArtworkType.AUDIO,
          ),
          title: Consumer<SongProvier>(
            builder: (context, songProvider, child) {
              return Text(songProvider.updatedSongs[index].title,
                  maxLines: 1, style: TextStyle(color: Colors.white));
            },
          ),
          subtitle: Text('${song.artist}',
              maxLines: 1, style: TextStyle(color: Colors.grey)),
          trailing: IconButton(
              onPressed: () async {
                await provider.printTitleChangeHistory();
              },
              icon: Icon(Icons.more_vert,
                  color: Colors.white.withOpacity(0.7))),
        );
      },
    );
  }
}
