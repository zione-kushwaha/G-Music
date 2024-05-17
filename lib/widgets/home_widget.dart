import 'package:flutter/material.dart';
import 'package:music/providers/SongProvider.dart';
import 'package:music/providers/playlist_provider.dart';
import 'package:music/views/Individual_song.dart';
import 'package:music/widgets/playlist_widget.dart';
import 'package:music/widgets/recently_played_song.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class homeWidget extends StatefulWidget {
  const homeWidget({super.key});

  @override
  State<homeWidget> createState() => _homeWidgetState();
}

class _homeWidgetState extends State<homeWidget> {
  
  @override
  Widget build(BuildContext context) {
    
    final provider=Provider.of<playlistProvider>(context);
    return Container(
      color: const Color.fromARGB(255, 0, 0, 0),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good Morning',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Welcome to the Music App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          recently_played_music(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Playlists',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.17,
                  child: ListView.builder(
                      itemCount: provider.playlists.length,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        var item=provider.playlists[index];
                        return InkWell(
                          onTap: () {
                            if (mounted) {
                            
                              Navigator.pushNamed(
                  context,
                  playlist_widget.routeName,
                  arguments: {'playlist': item},
                );
                            }
                          },
                          child: Container(
                            width: 150,
                            height: MediaQuery.of(context).size.height * 0.17,
                            margin: const EdgeInsets.only(right: 16), 
                            child: Stack(
                              children: [
                                Container(
                                  width: 150,
                                  height: MediaQuery.of(context).size.height *
                                      0.17,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20)
                                      ),
                                  child: QueryArtworkWidget(
                                      quality: 100,
                                      artworkBorder: BorderRadius.circular(20),
                                      artworkClipBehavior:
                                          Clip.antiAliasWithSaveLayer,
                                      artworkFit: BoxFit.cover,
                                      nullArtworkWidget: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(50),
                                        child: Image.asset(
                                            'assets/images/cover.jpg'),
                                      ),
                                      id: item.id,
                                      type: ArtworkType.ALBUM),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: popup_menu_bottom(playlistName: item.playlist,)
                                  ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.playlist,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        
                                      ],
                                    )
                                  ),
                                ),
                              ],
                            ),
                          
                        ));
                      }),
                ),
              ],
            ),
          ),
          Spacer(),
          PlayerHome()
        ],
      ),
    );
  }
}

class PlayerHome extends StatefulWidget {
  const PlayerHome({Key? key}) : super(key: key);

  @override
  _PlayerHomeState createState() => _PlayerHomeState();
}

class _PlayerHomeState extends State<PlayerHome> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SongProvier>(
      context,
    );
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, _, __) => Individual_song(),
          ),
        );
      },
      child: Container(
        height: 110,
        
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
        ),
        child: Container(
         decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.withOpacity(0.9),
              Colors.black.withOpacity(0),
            ],
          ),
         ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        CircleAvatar(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: Selector<SongProvier, int>(
                              selector: (_, provider) => provider.playingSongId,
                              builder: (_, playingSongId, __) {
                                return Container(
                                  width: 230,
                                  height: 230,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(200),
                                  ),
                                  
                                  child:
                                      ArtworkWidget(playingSongId: playingSongId),
                                );
                              },
                            ),
                          ),
                          radius: 30,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 175,
                              child: Text(
                                provider.songTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: Text(
                                provider.songArtist,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.pause, color: Colors.white, size: 30),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.skip_next_outlined,
                          color: Colors.white, size: 30),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${provider.currentTime.length > 2 ? provider.currentTime.substring(2) : provider.currentTime}',
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4),
                        trackShape: RectangularSliderTrackShape(),
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: provider.sliderValue,
                        max: provider.sliderMaxVAlue,
                        min: 0,
                        inactiveColor: Colors.grey[500],
                        activeColor: Colors.white,
                        onChanged: (value) {
                          provider.sliderValue = value;
                          provider.change_duration(value);
                        },
                      ),
                    ),
                  ),
                  Text(
                    '${provider.totalTime.length > 2 ? provider.totalTime.substring(2) : provider.totalTime}',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArtworkWidget extends StatelessWidget {
  final int playingSongId;

  ArtworkWidget({required this.playingSongId});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(200),
      child: QueryArtworkWidget(
        quality: 100,
        keepOldArtwork: true,
        artworkBorder: BorderRadius.circular(8),
        artworkClipBehavior: Clip.antiAliasWithSaveLayer,
        artworkFit: BoxFit.cover,
        nullArtworkWidget: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: Image.asset('assets/images/cover.jpg', fit: BoxFit.cover),
        ),
        id: playingSongId,
        type: ArtworkType.ALBUM,
      ),
    );
  }
}


class popup_menu_bottom extends StatelessWidget {
  
final String playlistName;
  const popup_menu_bottom({super.key,required this.playlistName});

  @override
  Widget build(BuildContext context) {
    
    return PopupMenuButton<int>(
      onSelected: (value) {
        if (value == 1) {
         
        } else if (value == 2) {
          Provider.of<playlistProvider>(context,listen: false).deletePlaylist(playlistName);
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<int>(
            value: 1,
            child: Text('Rename'),
          ),
          const PopupMenuItem<int>(
            value: 2,
            child: Text('Delete'),
          ),
        ];
      },
    );
  }}