import 'package:flutter/material.dart';
import 'package:music/constants.dart';


import 'package:music/views/audio_player.dart';
import 'package:music/views/playlist.dart';
import 'package:music/views/search_screen.dart';
import 'package:music/widgets/album_widget.dart';
import 'package:music/widgets/artist_widget.dart';
import 'package:music/widgets/genres_widget.dart';
import '../views/drawer.dart';
import 'package:flutter_custom_tab_bar/library.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  TabController? _tabController;

  final List<Widget> _children = [
    
    AudioPlayerss(), 
       
  const  playlist_page(),
    AlbumPage(),
    ArtistPage(), 
  GenresPage(),
 
    
    
  ];

 

     @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _children.length, vsync: this);
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ui_color,
      appBar: AppBar(
         iconTheme: IconThemeData(
        color: Colors.white,
        size: 20.0
      ),
      elevation: 0,
    
      actions: [IconButton(onPressed: (){

      Navigator.pushNamed(context, SearchScreen.routeName);
      }, icon: Icon(Icons.search,color: Colors.white.withOpacity(0.7),size: 25,))],
        title: const Text('Scanning...',style: TextStyle(color: Colors.white,fontSize: 20),),
        backgroundColor: ui_color,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: AnimatedBuilder(
            animation: _tabController!,
            builder: (BuildContext context, Widget? child) {
              return CustomTabBar(
                pinned: false,
                direction: Axis.horizontal,
                height: 40.0,
                itemCount: _children.length,
                pageController: _pageController,
                builder: (context, index) {
                  return Tab(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.transparent
                          ),
                          child: Text(
                            ['SONGS', 'PLAYLIST', 'ALBUMS', 'ARTISTS', 'GENRES'][index],
                            style:  TextStyle(
                              color: _tabController!.index == index ? Color(0xFF845EC2) : Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                              fontSize: 12
                            ),
                          ),
                        ),
                         // code to show a line under the selected tab
                          if (_tabController!.index == index)
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 5.0,left: 3),
                              height: 2.0,
                              width: 50.0,
                              color: Color.fromARGB(255, 112, 69, 182),
                         
                            ),
                            
                      ],
                    ),
                  );
                },
                onTapItem: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
              );
            },
          ),
        ),
      ),
      drawer: DrawerSection(),
      body: PageView(
        controller: _pageController,
        children: _children,
        onPageChanged: (index) {
          _tabController!.animateTo(index);
        },
      ),
    );
  }
}