// i want to define some colors as constant


import 'package:flutter/material.dart';

 
const Color white = Color(0xFFFFFFFF);

// const Color ui_color =Color(0xff3f1b53); 
// const Color ui_dark_color =Color.fromARGB(255, 43, 32, 49) ;
//Color.fromARGB(255, 127, 27, 19),
// Color.fromARGB(255, 6, 6, 6)

// provider for the app ui color change
class Ui_changer extends ChangeNotifier {
   Color _ui_color=  Color(0xff3f1b53);
 Color _ui_dark_color= Color.fromARGB(255, 3, 77, 169);
 late Color temp;
 late int index_temp;
void someFunction(int index) {
   temp =  _Ui_colors[index];
    index_temp=index;
   notifyListeners();
}
void initalize(){
  temp=_ui_color;
  index_temp=_Ui_colors.indexOf(_ui_color);
  notifyListeners();
}
  List<Color> _Ui_colors = [Color.fromARGB(255, 1, 44, 56),Color(0xFF7209b7)
  ,Color.fromARGB(255, 128, 36, 87),Color(0xff403d39),
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
  List<Color> _ui_dark_colors=[Color.fromARGB(255, 3, 77, 169),Color(0xFF3a0ca3),Color.fromARGB(255, 213, 43, 199),
  Color(0xff252422),
  Color(0xffbe95c4),
  Color.fromARGB(255, 9, 44, 90),
  Color(0xff118ab2),
  Color(0xffdab785),
  Color(0xff003459),
  Color(0xff2d2e2e5),
  Color(0xfff0a7a0)
  ,Color.fromARGB(255, 55, 60, 47) ,
  Color.fromARGB(255, 102, 127, 72),
  Color.fromARGB(255, 54, 122, 85),
  Color.fromARGB(255, 43, 32, 49)
  ];
  Color get ui_color => _ui_color;
  Color get ui_dark_color => _ui_dark_color;
  
// function to change the color of _ui_color and _ui_dark_color on the basis of index given
  void changeColor(int index) {
    _ui_color = _Ui_colors[index];
    _ui_dark_color = _ui_dark_colors[index];
    notifyListeners();
  }

}

