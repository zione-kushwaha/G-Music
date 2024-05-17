//create the widget for the recently played song it should keep track of which song is played and maximum 10 song it should store in the database

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:music/constants.dart';
import 'package:music/database/databaseHelper.dart';
import 'package:on_audio_query/on_audio_query.dart';

class recently_played_music extends StatefulWidget {
  recently_played_music({super.key});

  @override
  State<recently_played_music> createState() => _recently_played_musicState();
}

class _recently_played_musicState extends State<recently_played_music> {
  var dbhelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recently Played',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.17,
            child: FutureBuilder(
              future: dbhelper.queryAllRows(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var song_item = snapshot.data![index];
                      print(snapshot.data);
                      return Container(
                        margin: const EdgeInsets.only(right: 16),
                        width: 150,
                        child: song_item['title'] != null
                            ? Stack(
                                children: [
                                  Container(
                                    width: 150,
                                    height: MediaQuery.of(context).size.height *
                                        0.17,
                                    child: QueryArtworkWidget(
                                        quality: 100,
                                        artworkBorder:
                                            BorderRadius.circular(20),
                                        artworkClipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        artworkFit: BoxFit.cover,
                                        nullArtworkWidget: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.asset(
                                              'assets/images/cover.jpg'),
                                        ),
                                        id: song_item['albumId'] ?? 0,
                                        type: ArtworkType.ALBUM),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: recent_popup_menu_bottom(
                                      id: song_item['id'],
                                      ondelete: () {
                                        setState(() {});
                                      },
                                    ),
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
                                            song_item['title'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            song_item['artist'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    },
                  );
                }
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text('Not at all played song'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class recent_popup_menu_bottom extends StatelessWidget {
  final int id;

  final ui.VoidCallback ondelete;

  const recent_popup_menu_bottom(
      {Key? key, required this.id, required this.ondelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dbhelper = DatabaseHelper.instance;

    return PopupMenuButton<int>(
      onSelected: (value) async {
        if (value == 1) {
          await dbhelper.delete(id);
          ondelete();
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<int>(
            value: 1,
            child: Text('Delete'),
          ),
        ];
      },
    );
  }
}
