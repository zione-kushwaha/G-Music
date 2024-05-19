import 'package:flutter/material.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:music/constants.dart';
import 'package:music/providers/SongProvider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class recent_played_songs extends StatefulWidget {
  const recent_played_songs({super.key});
  static const routeName = '/recent_played_songs';

  @override
  State<recent_played_songs> createState() => _recent_played_songsState();
}

class _recent_played_songsState extends State<recent_played_songs> {
  @override
  Widget build(BuildContext context) {
    final ui = Provider.of<Ui_changer>(context);
    final future = Provider.of<SongProvier>(context, listen: false);
    final provider = Provider.of<SongProvier>(context, listen: false);
    final ValueNotifier<bool> playing = ValueNotifier(provider.isplaying);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recently Played Songs',
          style: TextStyle(color: white),
        ),
        backgroundColor: ui.ui_color,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: ui.ui_color,
      body: FutureBuilder(
          future: future.queryAllRows(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return ListTile(
                  leading: QueryArtworkWidget(
                    quality: 100,
                    keepOldArtwork: true,
                    artworkBorder: BorderRadius.circular(25),
                    artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                    artworkFit: BoxFit.cover,
                    nullArtworkWidget: CircleAvatar(
                      radius: 23,
                      child:
                          Icon(Icons.music_note, color: Colors.white, size: 40),
                    ),
                    id: item['albumId'],
                    type: ArtworkType.ALBUM,
                  ),
                  title: Consumer<SongProvier>(
                      builder: (context, provider, child) {
                    return Text('${item['title']}',
                        maxLines: 1, style: TextStyle(color: Colors.white));
                  }),
                  subtitle: Consumer<SongProvier>(
                      builder: (context, provider, child) {
                    return Text('${item['artist']}',
                        maxLines: 1, style: TextStyle(color: Colors.grey));
                  }),
                  trailing: Consumer<SongProvier>(
                      builder: (context, provider, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if ((provider.currentSong.albumId == item['albumId']) &&
                            (provider.currentSong.artist == item['artist']) &&
                            (provider.currentSong.title == item['title']))
                          ValueListenableBuilder<bool>(
                            valueListenable: playing,
                            builder:
                                (BuildContext context, value, Widget? child) {
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
                          onPressed: () {
                            setState(() {
                              provider.deleteAll();
                            });
                          },
                          icon: Icon(
                            Icons.more_vert,
                            color: white.withOpacity(0.7),
                          ),
                        )
                      ],
                    );
                  }),
                );
              },
            );
          }),
    );
  }
}
