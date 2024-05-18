import 'package:flutter/material.dart';
import 'package:music/constants.dart';
import 'package:music/providers/SongProvider.dart';
import 'package:music/providers/playlist_provider.dart';
import 'package:music/views/Individual_song.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2.0;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
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
    return  GestureDetector(
        onTap: () {
         
        Navigator.push(context, PageRouteBuilder(pageBuilder:  (context, animation, secondaryAnimation) => Individual_song(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
      
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      }));
        },
        child: Column(
          children: [
            
            Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.zero,
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 0), // Remove overlay padding
            trackHeight: 10,
            trackShape:  RectangularSliderTrackShape(),
          ),
          child: Slider(
            value: provider.sliderValue,
            max:provider.sliderMaxVAlue,
            min: 0,
            inactiveColor: Colors.grey[500],
            activeColor:Colors.black, // Change this to your desired color
            onChanged: (value) {
               provider.sliderValue = value;
                                provider.change_duration(value);
            },
          ),
        ),
      ),
            
            Container(
              height: MediaQuery.of(context).size.height * 0.09,
              
              decoration: BoxDecoration(
                color: ui_color,
                borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                              Container(
                        height: 30,
                        width: 30,
                        child: CircleAvatar(
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
                      ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              
                                SizedBox(
                                  width:  MediaQuery.of(context).size.width*0.6,
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
                                  width:  MediaQuery.of(context).size.width*0.5,
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
                      IconButton(
                        icon:   Icon(
                          
                          provider.isplaying?Icons.pause:Icons.play_arrow, color: Colors.white, size: 30),
                          onPressed: (){
                            provider.isplaying?provider.pause_Song():provider.resume_Song();
                          },
                      ),
                    ],
                  ),
                 
                ],
              ),
            ),
          ],
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