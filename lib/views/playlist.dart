import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music/constants.dart';
import 'package:music/providers/SongProvider.dart';
import 'package:music/providers/playlist_provider.dart';
import 'package:music/widgets/home_widget.dart';
import 'package:music/widgets/playlist_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class playlist_page extends StatefulWidget {
  const playlist_page({super.key});

  @override
  State<playlist_page> createState() => _playlist_pageState();
}

class _playlist_pageState extends State<playlist_page> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<playlistProvider>(context);
    return Column(
      children: [
              ListTile(
              title: Text(
                'Playlist (${provider.playlists.length+4})',
                style: TextStyle(
                  color: white,
                ),
              ),
              trailing: IconButton(
                  onPressed: () {
                    // code to create the playlist
                   createPlaylistPopup(context);
                  },
                  icon: Icon(
                    Icons.add,
                    color: white.withOpacity(0.7),
                  )),
            ),
        Flexible(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: provider.playlists.length + 4,
            itemBuilder: (context, index) {
              if (index < 4) {
                // return your static ListTile widgets based on the index
                return _buildStaticListTile(index);
              } else {
                var item = provider.playlists[index - 4];
                return ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        //navigate to the playlist detail page
                        Navigator.pushNamed(context, playlist_widget.routeName,
                            arguments: {'playlist': item});
                      });
                    }
                  },
                  leading: QueryArtworkWidget(
                      quality: 100,
                      artworkBorder: BorderRadius.circular(20),
                      artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                      artworkFit: BoxFit.cover,
                      nullArtworkWidget: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset('assets/images/cover.jpg'),
                      ),
                      id: item.id,
                      type: ArtworkType.PLAYLIST),
                  title: Text(
                    item.playlist,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    item.numOfSongs.toString() + ' songs',
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: popup_menu_bottom(
                    playlistName: item.playlist,
                  ),
                );
              }
            },
          ),
        ),
        PlayerHome()
      ],
    );
  }

  ListTile _buildStaticListTile(int index) {
  String title;
  IconData icon;
  switch (index) {
    case 2:
      title = 'Recently Added';
      icon = Icons.playlist_add;
      break;
    case 1:
      title = 'Recently Played';
      icon = Icons.history;
      break;
    case 3:
      title = 'My Top Track';
      icon = Icons.grade;
      break;
    case 0:
      title = 'Favourite';
      icon = Icons.favorite;
      break;
    default:
      return ListTile(); // Return an empty ListTile for invalid index
  }

  return ListTile(
    leading: Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.2),
      ),
      child: Icon(
        icon,
        color: Colors.white.withOpacity(0.7),
      ),
    ),
    subtitle: Text(
      '4 songs',
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
      ),
    ),
    title: Text(
      title,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    trailing: IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.more_vert,
        color: Colors.white.withOpacity(0.7),
      ),
    ),
  );
}

  // function to show the popup menu button for input of playlist name
  void createPlaylistPopup(BuildContext context) {
    TextEditingController controller = TextEditingController();
   final ui = Provider.of<Ui_changer>(
      context,
      listen: false,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: ui.ui_color,
          title: Text('Create new Playlist',
              style: TextStyle(fontSize: 20, color: white)),
          content: TextField(
            controller: controller,
            style: TextStyle(color: white),
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter the playlist name',
              hintStyle: TextStyle(color: white.withOpacity(0.7)),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: white),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // code to create the playlist

                if (!controller.text.isEmpty) {
                  Provider.of<playlistProvider>(
                    context,
                    listen: false
                  ).createPlaylist(controller.text);

                  Navigator.pop(context);
                  
                } else {
                  return;
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}

class popup_menu_bottom extends StatelessWidget {
  final String playlistName;
  const popup_menu_bottom({super.key, required this.playlistName});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert, color: Colors.white.withOpacity(0.7)),
      color: white,
      onSelected: (value) {
        if (value == 1) {
        } else if (value == 2) {
          Provider.of<playlistProvider>(context, listen: false)
              .deletePlaylist(playlistName);
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
  }
}