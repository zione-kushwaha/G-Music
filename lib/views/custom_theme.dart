import 'package:flutter/material.dart';
import 'package:glossy/glossy.dart';
import 'package:music/constants.dart';
import 'package:music/providers/album_provider.dart';

import 'package:neopop/utils/color_utils.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class CustomTheme extends StatefulWidget {
  CustomTheme({Key? key}) : super(key: key);
  static const String routeName = '/custom_theme';

  @override
  State<CustomTheme> createState() => _CustomThemeState();
}

class _CustomThemeState extends State<CustomTheme> {
  final List<Color> _uiColors = [
    Color.fromARGB(255, 1, 44, 56),
    Color(0xFF7209b7),
    Color.fromARGB(255, 128, 36, 87),
    Color(0xff403d39),
    Color.fromARGB(255, 145, 103, 200),
    Color.fromARGB(255, 8, 121, 202),
    Color.fromARGB(255, 23, 130, 102),
    Color.fromARGB(255, 99, 75, 41),
    Color(0xff00171f),
    Color(0xff0f0f0f),
    Color.fromARGB(255, 133, 52, 87),
    Color(0xff245501),
    Color.fromARGB(255, 80, 70, 10),
    Color.fromARGB(255, 4, 144, 154),
    Color(0xff3f1b53)
  ];

  @override
  Widget build(BuildContext context) {
    final ui = Provider.of<Ui_changer>(context);
    final provider = Provider.of<AlbumProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: ui.ui_color.withOpacity(0.5),
      appBar: AppBar(
        title: Text('Themes', style: TextStyle(color: Colors.white)),
        backgroundColor: ui.ui_color.withOpacity(0.8),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
  TextButton(
    onPressed: () {
       ui.changeColor(ui.index_temp);
          ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Theme changed successful!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.only(left: 40, right: 60, bottom: 65), // Adjust as needed
      ),
    );
              Navigator.pop(context);
    },
    child: Text('OK', style: TextStyle(color: Colors.white)),
  ),
],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
          child: SizedBox(
            width:MediaQuery.of(context).size.width * 0.9, 
            height: MediaQuery.of(context).size.height * 0.65,
            child: Stack(
              children: [
               
                Align(
                  alignment: Alignment.center,
                  child: GlossyContainer(
                    width: MediaQuery.of(context).size.width * 0.9, 
                    height: MediaQuery.of(context).size.height * 0.65,
                    borderRadius: BorderRadius.circular(12),
                    color: ui.temp,
                    child: Container(
      color: ui.temp,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: provider.getAlbums().length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // number of items per row
                    childAspectRatio: 1.0, // item width to height ratio,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (context, index) {
                  final album = provider.getAlbums()[index];
                  return AspectRatio(
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
                                      )),
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
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text('${album.artist}',
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: white.withOpacity(0.7),
                                    fontSize: 8,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          
        ],
      ),
    ),
                    ),
                  ),
                
              ],
            ),
          ),
        ),
          Spacer(),
          Container(
            height: 150,
           
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(20),
           
              itemCount: _uiColors.length,
             
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () {
                  // Update the theme here
                  // For example:
                  // Theme.of(context).copyWith(primaryColor: _uiColors[i]);
                },
                child: Container(
                     margin: const EdgeInsets.symmetric(horizontal: 15),
                  width: 170,
                  child: NeoPopButton(
                    color: _uiColors[i],
                    bottomShadowColor: ColorUtils.getVerticalShadow(white).toColor(),
                    rightShadowColor: ColorUtils.getHorizontalShadow(Colors.grey).toColor(),
                    animationDuration: Duration(milliseconds: 200),
                    depth: 8,
                    onTapUp: () {
                      // ui.changeColor(i);
                      // Navigator.pop(context);
                       ui.someFunction(ui.index_temp);
                      ui.someFunction(i);
                    },
                    border: Border.all(
                      color: ui.ui_dark_color,
                      width: 2,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}