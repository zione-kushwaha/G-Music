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
  bool do_state_state=false;

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
                
                   
                    
                    
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}
