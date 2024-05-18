import 'package:flutter/material.dart';
import 'package:music/constants.dart';
import 'package:music/providers/artistProvider.dart';
import 'package:music/views/artist_detail_page.dart';
import 'package:music/widgets/home_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class ArtistPage extends StatefulWidget {
 

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  @override
  Widget build(BuildContext context) {
    final ui = Provider.of<Ui_changer>(
      context,
    );
    final provider=Provider.of<ArtistProvider>(context);
    return  Container(
        color:ui. ui_color,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics:const BouncingScrollPhysics(),
                itemCount:  provider.getArtists().length,
                itemBuilder: (context, index) {
                  final song=provider.getArtists()[index];
                  return ListTile(
                    onTap: (){
                      
                    if(mounted){
                      setState(() {
                         Navigator.pushNamed(context, artist_detail_page.namedRoute,arguments: {'artist':song});
                              });
                    }
                    },
                          leading:  QueryArtworkWidget(
                                  quality: 100,
                                   artworkBorder: BorderRadius.circular(25),
                                   artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                                  artworkFit: BoxFit.cover,
                                  nullArtworkWidget: CircleAvatar(
                                    radius: 23,
                                    child: Icon(Icons.music_note,color: Colors.white,size: 40,)),
                                   
                                  id: song.id,
                                  type: ArtworkType.ARTIST,
                          ),
                    title: Text(
                      song.artist,
                      maxLines: 1,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${song.numberOfAlbums} Albums  |  ${song.numberOfTracks} Songs',
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(onPressed: (){

                    }, icon: Icon(Icons.more_vert,color: Colors.white.withOpacity(0.7),))
                  );
                },
              ),
            ),
            PlayerHome()
          ],
        ),
      );
  }
}