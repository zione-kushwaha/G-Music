// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:music/constants.dart';

import 'package:music/providers/SongProvider.dart';

import 'package:music/views/Individual_song.dart';

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
          return Center(child: CircularProgressIndicator(
            color: ui_color,
          ));
        } else {
          return Container(
            width: double.infinity,
            child: Column(
              children: [
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
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: list_builer_audio_player(),
                ),
              ],
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
      physics: const BouncingScrollPhysics(),
      itemCount: provider.getSongs().length,
      itemBuilder: (context, index) {
        final song = provider.getSongs()[index];

        return ListTile(
          onTap: () {
            provider.play_song(song);

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
          title: Text('${song.title}',
              maxLines: 1, style: TextStyle(color: Colors.white)),
          subtitle: Text('${song.artist}',
              maxLines: 1, style: TextStyle(color: Colors.grey)),
          trailing: Icon(Icons.more_vert, color: Colors.white.withOpacity(0.7)),
        );
      },
    );
  }
}
