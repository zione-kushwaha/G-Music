// i want to define some colors as constant

import 'package:flutter/material.dart';
import 'package:music/providers/SongProvider.dart';

const Color white = Color(0xFFFFFFFF);
const Color ui_color=Color.fromARGB(255, 127, 27, 19);
//Color.fromARGB(255, 127, 27, 19)

class  loads {
  SongProvier songProvider = SongProvier();
  load()async{
    songProvider.addListener(() {
  print(songProvider.updatedSongs);
});
await songProvider.Load_songs();
  }

}
