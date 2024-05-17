import 'dart:io';
import 'package:music/views/track_cutter.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music/providers/SongProvider.dart';
import 'package:music/providers/playlist_provider.dart';
import 'package:music/views/equalizer_page.dart';

import 'package:provider/provider.dart';

class songControllerBtn extends StatelessWidget {
  const songControllerBtn({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SongProvier>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${provider.currentTime}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: Slider(
              value: provider.sliderValue,
              onChanged: (value) {
                provider.sliderValue = value;

                provider.change_duration(value);
              },
              min: 0,
              max: provider.sliderMaxVAlue,
            )),
            Text(
              provider.totalTime,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  provider.previous_song();
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: CircleAvatar(
                      radius: 30,
                      child: SvgPicture.asset(
                        'assets/icons/back.svg',
                        width: 25,
                      )),
                )),
            SizedBox(
              width: 25,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                provider.isplaying
                    ? provider.pause_Song()
                    : provider.resume_Song();
              },
              child: Container(
                  padding: EdgeInsets.all(11),
                  child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.red,
                      child: provider.isplaying
                          ? SvgPicture.asset(
                              'assets/icons/pause.svg',
                              width: 30,
                            )
                          : SvgPicture.asset(
                              'assets/icons/play.svg',
                              width: 30,
                            ))),
            ),
            SizedBox(
              width: 20,
            ),
            InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  provider.next_song();
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: CircleAvatar(
                      radius: 30,
                      child: SvgPicture.asset(
                        'assets/icons/next.svg',
                        width: 25,
                      )),
                )),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
                onTap: () {
                  provider.shuffle_song();
                },
                borderRadius: BorderRadius.circular(35),
                child: Container(
                    padding: EdgeInsets.all(3),
                    child: SvgPicture.asset(
                      'assets/icons/suffle.svg',
                      width: 30,
                      color: provider.is_shuffling ? Colors.red : Colors.white,
                    ))),
            InkWell(
              onTap: () {
                provider.loop_song();
              },
              borderRadius: BorderRadius.circular(35),
              child: Container(
                  padding: EdgeInsets.all(3),
                  child: SvgPicture.asset(
                    'assets/icons/repeat.svg',
                    width: 30,
                    color: provider.is_looping ? Colors.red : Colors.white,
                  )),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, equalizer_page.routeName);
                },
                icon: Icon(
                  Icons.equalizer,
                  color: Colors.white,
                  size: 34,
                )),
            InkWell(
                onTap: () {
                  Provider.of<playlistProvider>(context, listen: false)
                      .addSongToPlaylist('Favorite Song', provider.currentSong);
                },
                child: IconButton(
                    onPressed: () async {
                      //get the absolute path of the song from uri
                      final filePath =
                          await LecleFlutterAbsolutePath.getAbsolutePath(
                              uri: provider.currentSong.uri.toString());
                               
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                   AudioTrimmerView(file:File(filePath!))));
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 34,
                    ))),
          ],
        )
      ],
    );
  }
}
