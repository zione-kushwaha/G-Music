import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music/constants.dart';
import 'package:music/providers/SongProvider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  List<SongModel> _list_song = [];
  List<SongModel> _searchResult = [];

  Timer? _debounce;

  _SearchScreenState() {
    _searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      searchResultList();
    });
  }
  searchResultList() {
  List<SongModel> showResults = [];
  String searchText = _searchController.text.replaceAll(' ', '').toLowerCase();
  if (searchText != "") {
    for (var song in _list_song) {
     var title = song.title.toLowerCase();
var artist = song.artist!.toLowerCase();
var album = song.album!.toLowerCase();
      if (title.contains(searchText) ||
          artist.contains(searchText) ||
          album.contains(searchText)
          ) {
          
        showResults.add(song);
      }
    }
  } else {
    showResults = List.of(_list_song);
  }
  setState(() {
    _searchResult = showResults;
  });
}

  

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _list_song = Provider.of<SongProvier>(context, listen: false).getSongs();
    _searchResult = List.of(_list_song);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ui_color,
      appBar: AppBar(
  leading: IconButton(
    icon: Icon(Icons.arrow_back,color: white,),
    onPressed: () => Navigator.pop(context),
  ),
  automaticallyImplyLeading: false,
  centerTitle: true,
  backgroundColor: ui_color,
  title: Container(
  padding: EdgeInsets.symmetric(horizontal: 8),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(5), // Adjust as needed
  ),
  child: TextField(
    controller: _searchController,
    autofocus: true,
    decoration: InputDecoration(
      hintText: 'Search songs',
      border: InputBorder.none,
      icon: Icon(Icons.search),
       suffixIcon: IconButton(
        icon: Icon(Icons.clear,size: 20,),
        onPressed: (){
          if(!_searchController.text.isNotEmpty){return;}
          _searchController.clear();
          _onSearchChanged();
        },
        
      )
    ),
    onChanged: (value) {
      _onSearchChanged();
    },
    
    onSubmitted: (value) {
      _onSearchChanged();
    },
  ),
),

      ),
      body: Column(
        children: [
          Expanded(
            child:_searchResult.isEmpty
      ? Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text( ' 😒 Opps!! ',style: TextStyle(color: white),),
          Text( ' No Result Found ',style: TextStyle(color: white),),
        ],
      ))
      : ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, index) {
                var title = _searchResult[index].title;
                var artist = _searchResult[index].artist;
                var search = _searchController.text;
                var titleLower = title.toLowerCase();
                var searchLower = search.toLowerCase();

                if (titleLower.contains(searchLower)) {
                  var startIndex = titleLower.indexOf(searchLower);
                  var endIndex = startIndex + searchLower.length;
                  return ListTile(
                    leading: QueryArtworkWidget(
                      id: _searchResult[index].id,
                      type: ArtworkType.AUDIO,
                      artworkBorder: BorderRadius.circular(22),
                      artworkFit: BoxFit.cover,
                      nullArtworkWidget: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.grey,
                        ),
                        child: Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    title: RichText(
                      maxLines: 1,
                      text: TextSpan(
                        text: title.substring(0, startIndex),
                        style: TextStyle(color: Colors.white),
                        children: <TextSpan>[
                          TextSpan(
                            text: title.substring(startIndex, endIndex),
                            style: TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: title.substring(endIndex),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text(
                      '$artist',
                      maxLines: 1,
                      style: TextStyle(color: white.withOpacity(0.7)),
                    ),
                  );
                } else {
                  return ListTile(
                    leading: QueryArtworkWidget(
                      id: _searchResult[index].albumId!,
                      type: ArtworkType.ALBUM,
                      artworkBorder: BorderRadius.circular(22),
                      artworkFit: BoxFit.cover,
                      nullArtworkWidget: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.grey,
                        ),
                        child: Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    title: Text(title, style: TextStyle(color: Colors.white)),
                    subtitle: Text(
                      '$artist',
                      maxLines: 1,
                      style: TextStyle(color: white.withOpacity(0.7)),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}