import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music/constants.dart';
import 'package:music/providers/Genres_provider.dart';
import 'package:music/views/GeneresPage_detail.dart';
import 'package:music/widgets/home_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';


class GenresPage extends StatefulWidget {
  @override
  State<GenresPage> createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage> {
  @override
  Widget build(BuildContext context) {
    return  Consumer<GenresProvider>(
        builder: (context, genresProvider, child) {
          List<GenreModel> genres = genresProvider.getGenres();
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                   physics:const BouncingScrollPhysics(),
                  itemCount: genres.length,
                  itemBuilder: (context, index) {
                    
                    return Column(
                      children: [
                          
                          
                              
                        ListTile(
                          onTap: (){
                            //navigate to the genre detail page
                        if(mounted){
                          setState(() {
                            Navigator.pushNamed(context, GenresPageDetail.namedRoute,arguments: {'genre':genres[index]});
                             
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
                     
                    id: genres[index].id,
                    type: ArtworkType.GENRE,
                      ),
                          
                          title: Text(
                            genres[index].genre,
                            style: TextStyle(color: Colors.white),
                            
                          ),
                          subtitle: Text(genres[index].numOfSongs.toString()+' songs',style: TextStyle(color: Colors.grey)),
                          trailing: IconButton(onPressed: (){}, icon: Icon(Icons.more_vert,color: Colors.white,)),
                        ),
                        
                      ],
                    );
                    
                  },
                ),
              ),
              PlayerHome()
            ],
          );
        },
    
    );
  }
}