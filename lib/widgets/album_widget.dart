import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music/constants.dart';
import 'package:music/providers/album_provider.dart';

import 'package:music/views/album_detail_page.dart';
import 'package:music/widgets/home_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AlbumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AlbumProvider>(context,listen: false);
    return Container(
      color: ui_color,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: provider.getAlbums().length,
                gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // number of items per row
                    childAspectRatio: 1.0, // item width to height ratio,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (context, index) {
                  final album = provider.getAlbums()[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AlbumDetailPage.namedRoute,
                        arguments: {'album': album},
                      );
                    },
                    child: AspectRatio(
                      aspectRatio: 1.5,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              width: 100,
                              child: GridTile(
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                                  child: QueryArtworkWidget(
                                                                    id: album.id, 
                                                                    type: ArtworkType.ALBUM,
                                                                    artworkFit: BoxFit.cover,
                                                                    nullArtworkWidget: CircleAvatar(
                                                                      radius: 23,
                                                                      child: Icon(
                                                                        Icons.music_note,
                                                                        color: Colors.white,
                                                                        size: 40,
                                                                      )
                                                                    ),
                                                                  ),
                                ),
                                
                              ),
                            ),
                          ),
                           

                          Container(
                            height: 40,
                            width: 100,
                            
                            child: Column(
                              children: [
                                Text('${album.album}',
                                maxLines: 1,
                                 style: TextStyle(color: white, fontSize: 10, fontWeight: FontWeight.bold, )),
                             Text('${album.artist}',
                                maxLines: 1,
                                 style: TextStyle(color: white.withOpacity(0.7), fontSize: 8,  )),
                             
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          PlayerHome()
        ],
      ),
    );
  }
}