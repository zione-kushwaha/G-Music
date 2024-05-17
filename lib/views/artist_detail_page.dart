
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music/constants.dart';
import 'package:music/providers/SongProvider.dart';
import 'package:music/views/search_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import 'Individual_song.dart';

class artist_detail_page extends StatefulWidget {
  final ArtistModel artist;
  static const namedRoute='artist_detail_page';
  const artist_detail_page({Key? key, required this.artist}) : super(key: key);

  @override
  _artist_detail_pageState createState() => _artist_detail_pageState();
}

class _artist_detail_pageState extends State<artist_detail_page> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<SongProvier>(context,listen: false);
    return Scaffold(
    
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
         gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ui_color, Colors.black.withOpacity(0.7)],)
        ),
        child: Column(
          children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.045,),  
            Stack(
              children: [
                Positioned(
                  top: 10,
                  child: Container(
                    height: 190,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: QueryArtworkWidget(id: widget.artist.id, type: ArtworkType.ARTIST, artworkFit: BoxFit.cover),
                  ),
                ),
                
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.26,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(),
                        Text(
                         
                          widget.artist.artist,maxLines: 1,style: TextStyle(color: white,fontSize: 15,fontWeight: FontWeight.bold),),
                        Text(widget.artist.numberOfAlbums.toString(),maxLines: 1,style: TextStyle(color: white.withOpacity(0.7),fontSize: 12,),),
                        
                     SizedBox(height: 10,),
               ] ),
                    ),),
                  ),
                
               Positioned(
                right: 10,
                 child: IconButton(onPressed: (){
                   Navigator.pushNamed(context, SearchScreen.routeName);
                 }, icon: Icon(Icons.search,color: Colors.white,size: 30,)
                 ),
               )   ,
               Positioned(
                left: 10,
                child: IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,)))               
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Container(
                width: MediaQuery.of(context).size.width*0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                   Text(widget.artist.numberOfTracks.toString(),style: TextStyle(color: white.withOpacity(0.7),fontSize: 12,),),
                          
                       
                    Icon( Icons.shuffle,color: Colors.white,),
                  ],
                ),
              ),            Container(
                width: MediaQuery.of(context).size.width*0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.skip_previous,color: Colors.white,),
                    Icon(Icons.skip_next,color: Colors.white,),
                               
                    Icon(Icons.check_circle_outline,color: Colors.white,),
                  ],
                ),
              )
                          ],),
            )
        ,
        
            Expanded(
              child: ListView.builder(
                physics:const BouncingScrollPhysics(),
                itemBuilder: (context,index){
                
                final song=provider.getArtistSongs(widget.artist)[index];
                return ListTile(
                  onTap: () {
                    provider.play_song(song);
                    if (mounted) {
                      Navigator.pushNamed(context, Individual_song.namedRoute);
                    }
                  },
                  leading: QueryArtworkWidget(
                    quality: 100,
                    artworkBorder: BorderRadius.circular(25),
                    artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                    artworkFit: BoxFit.cover,
                    nullArtworkWidget: CircleAvatar(
                      radius: 23,
                      child: const Icon(Icons.music_note,color: Colors.white,size: 40,)),
                    id: song.albumId!,
                    type: ArtworkType.ALBUM,
                  ),
                  title: Text(
                    song.title,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(song.artist!, maxLines: 1,style: const TextStyle(color: Colors.grey),),
                  trailing: IconButton(onPressed: (){}, icon:  Icon(Icons.more_vert,color: Colors.white.withOpacity(0.7),),),
                );
              },
                itemCount: provider.getArtistSongs(widget.artist).length,
              
              ),
            ),
          ],
        ),
      ),
    );
  }
}