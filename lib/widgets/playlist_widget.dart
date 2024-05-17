import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music/constants.dart';
import 'package:music/views/search_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';



class playlist_widget extends StatelessWidget {
  static const routeName = '/playlist';
    final OnAudioQuery audioQuery = OnAudioQuery();

  final PlaylistModel play;
  playlist_widget({super.key,required this.play});

  @override
  Widget build(BuildContext context) {
     return Scaffold( 

      body:Container(
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
                    child: QueryArtworkWidget(id: play.id, type: ArtworkType.PLAYLIST, artworkFit: BoxFit.cover),
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
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 135,
                  child: Text(play.playlist,style: TextStyle(color: white,fontSize: 20,fontWeight: FontWeight.bold),),
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
              ]
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
                   Text(play.numOfSongs.toString(),style: TextStyle(color: white.withOpacity(0.7),fontSize: 12,),),
                          
                       
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
            ),
            Expanded(child: FutureBuilder<List<SongModel>>(
        future: audioQuery.queryAudiosFrom(AudiosFromType.PLAYLIST, play.playlist,sortType: SongSortType.DATE_ADDED,orderType: OrderType.ASC_OR_SMALLER),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              physics:const BouncingScrollPhysics(),
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                SongModel song = snapshot.data![index];
                return ListTile(
                  onTap: () {
                    
                  },
                  leading: QueryArtworkWidget(
                    id: song.albumId!,
                    type: ArtworkType.ALBUM,
                    artworkFit: BoxFit.cover,
                    nullArtworkWidget: CircleAvatar(
                  radius: 23,
                  child: Icon(Icons.music_note,color: Colors.white,size: 40,)),
                  ),
                  title: Text(
                    song.title,
                    maxLines: 1,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '${song.artist}',
                    maxLines: 1,
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  trailing: IconButton(onPressed: (){}, icon: Icon(Icons.more_vert,color: Colors.white,)),
                );
              },
            );
          }
        },
      ))
          ],
        ),
      ),
    );
  }
}