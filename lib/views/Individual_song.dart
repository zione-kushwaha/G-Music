// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:music/constants.dart';
import 'package:music_visualizer/music_visualizer.dart';
import 'package:flutter/material.dart';

import 'package:music/widgets/song_detail.dart';
import 'package:music/widgets/sound_volume.dart';
import 'package:provider/provider.dart';
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
    final ui = Provider.of<Ui_changer>(
      context,
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
         gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            
  colors: [
    Color(0xFF9F6A50), 
   
  ui.ui_color, // Fully transparent
    ui.ui_color.withOpacity(0.9), // Fully opaque
    
  ],
             )
        ),
height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
               
                SizedBox(height: 40,),
                soundVolume(),
                 SizedBox(height: 15),
                song_detail(),
                
                   
                    
                    
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}
