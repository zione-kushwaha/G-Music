// building a flutter music app with a custom music player
import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music/constants.dart';
import 'package:music/providers/Genres_provider.dart';
import 'package:music/providers/SongProvider.dart';
import 'package:music/providers/album_provider.dart';
import 'package:music/providers/artistProvider.dart';
import 'package:music/providers/playlist_provider.dart';
import 'package:music/views/GeneresPage_detail.dart';
import 'package:music/views/Individual_song.dart';
import 'package:music/views/album_detail_page.dart';
import 'package:music/views/artist_detail_page.dart';
import 'package:music/views/audio_player.dart';
import 'package:music/views/equalizer_page.dart';
import 'package:music/views/search_screen.dart';
import 'package:music/views/track_cutter.dart';
import 'package:music/widgets/playlist_widget.dart';
import 'package:provider/provider.dart';
import './views/HomeScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor:
        Colors.red.withOpacity(0.0), // Change this to your desired color
    statusBarIconBrightness:
        Brightness.light, // Change this for the color of the icons
  ));

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => SongProvier()),
    ChangeNotifierProvider(create: (_) => playlistProvider()),
    ChangeNotifierProvider(create: (_) => ArtistProvider()),
    ChangeNotifierProvider(create: (_) => GenresProvider()),
    ChangeNotifierProvider(create: (_) => AlbumProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    @override
  void initState() {
    super.initState();
    EqualizerFlutter.init(0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SongProvier>(context, listen: false).storagePermission();
      Provider.of<ArtistProvider>(context, listen: false).loadArtists();
      Provider.of<GenresProvider>(context, listen: false).loadGenres();
      Provider.of<AlbumProvider>(context, listen: false).loadAlbums();
      Provider.of<playlistProvider>(context, listen: false).loadPlaylist();
    });
  }
  @override
  void dispose() {
    EqualizerFlutter.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Music Player',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          cardTheme: CardTheme(
            color: Colors.white, // Set the color you want
          ),
          primarySwatch: MaterialColor(ui_color.value, {
            50: ui_color.withOpacity(0.1),
            100: ui_color.withOpacity(0.2),
            200: ui_color.withOpacity(0.3),
            300: ui_color.withOpacity(0.4),
            400: ui_color.withOpacity(0.5),
            500: ui_color.withOpacity(0.6),
            600: ui_color.withOpacity(0.7),
            700: ui_color.withOpacity(0.8),
            800: ui_color.withOpacity(0.9),
            900: ui_color.withOpacity(1),
          }),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return createRoute(const HomeScreen());

            case AudioPlayerss.routeName:
              return createRoute(const AudioPlayerss());

            case Individual_song.namedRoute:
              return createRoute(Individual_song());

            case AlbumDetailPage.namedRoute:
              var args = settings.arguments as Map;
              var album = args['album'];
              return createRoute(AlbumDetailPage(album: album));

            // Add more cases as needed for each route

            case playlist_widget.routeName:
              var args = settings.arguments as Map;
              var playlist = args['playlist'];
              return createRoute(playlist_widget(play: playlist));

            case equalizer_page.routeName:
              return createRoute(const equalizer_page());

            case AudioTrimmerView.routeName:
              var args = settings.arguments as Map;
              var file = args['file'];
              return createRoute(AudioTrimmerView(file: file));

            case track_cutter.routeName:
              return createRoute(const track_cutter());

            case artist_detail_page.namedRoute:
              var args = settings.arguments as Map;
              var artist = args['artist'];
              return createRoute(artist_detail_page(artist: artist));

            case GenresPageDetail.namedRoute:
              var args = settings.arguments as Map;
              var genre = args['genre'];
              return createRoute(GenresPageDetail(genre: genre));

            case SearchScreen.routeName:
              return createRoute(SearchScreen());
            default:
              return null;
          }
        });
  }
}

// Routing Animation
PageRouteBuilder createRoute(Widget destination) {
  return PageRouteBuilder(
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return destination;
    },
    transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-1.0, 0.0),
          ).animate(secondaryAnimation),
          child: child,
        ),
      );
    },
  );
}
