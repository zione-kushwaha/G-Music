// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:music/constants.dart';
import 'package:music_visualizer/music_visualizer.dart';
import 'package:flutter/material.dart';

import 'package:music/widgets/song_detail.dart';
import 'package:music/widgets/sound_volume.dart';
import '../widgets/song_controller.dart';



class Individual_song extends StatelessWidget {
 Individual_song({
    super.key,
  });
  static const namedRoute = '/individual_song';

  var values = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
         gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ui_color, Colors.black.withOpacity(0.7)],  )
        ),
height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Container(
                //   margin: EdgeInsets.only(top: 30),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         width: 40,
                //         height: 35,
                        
                //         padding: EdgeInsets.all(10),
                //         decoration: BoxDecoration(
                //           color: const Color(0xFF023047),
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //         child: Center(
                //           child: SvgPicture.asset('assets/icons/back_page.svg'),
                //         ),
                //       ),
                //       Container(
                //         width: 40,
                //         height: 35,
                //         padding: EdgeInsets.all(10),
                //         decoration: BoxDecoration(
                //           color: const Color(0xFF023047),
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //         child: Center(
                //           child: SvgPicture.asset('assets/icons/setting.svg'),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 40,),
                soundVolume(),
                song_detail(),
                
                     Container(
                  height: 50,
                  width: double.infinity,
                  child:  MusicVisualizer(
                    barCount: 30,
                    colors: [
            Colors.white,
             
                    
              
            Colors.orange,
              Color.fromARGB(255, 69, 5, 208),
                    Colors.red,
            ],
                    duration: [900, 700, 600, 800, 500],
                ),
              ),
                    
                    
                songControllerBtn()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
