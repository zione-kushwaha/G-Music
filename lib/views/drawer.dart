// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import './equalizer_page.dart';
import 'package:music/constants.dart';
import 'package:music/views/track_cutter.dart';

class DrawerSection extends StatelessWidget {
  const DrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
    
      backgroundColor: ui_color,
      child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        decoration: BoxDecoration(
          color: ui_color,
        ),
        child: Text(
          'Audio Player',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
     
     ListTile(
             leading: Icon(Icons.home,color: white,),
             title: Text('Home',style: TextStyle(color: white),),
             onTap: () {
     
      Navigator.pop(context);
             },
           ),
           
           ListTile(
             leading: Icon(Icons.equalizer,color: white,),
             title: Text('Equalizer',style: TextStyle(color: white),),
             onTap: () {
              Navigator.pop(context);
       Navigator.pushNamed(context, equalizer_page.routeName);
      
             },
           ),
           ListTile(
             leading: Icon(Icons.timer,color: white,),
             title: Text('Sleep Timer',style: TextStyle(color: white),),
             onTap: () {
      // Update the state of the app
      // Then close the drawer
      Navigator.pop(context);
             },
           ),
           ListTile(
             leading: Icon(Icons.cut,color: white,),
             title: Text('Track Cutter',style: TextStyle(color: white),),
             onTap: () {
      // Update the state of the app
      // Then close the drawer
      Navigator.pop(context);
      Navigator.pushNamed(context, track_cutter.routeName);
             },
           ),
            ListTile(
             leading: Icon(Icons.star,color: white,),
             title: Text('Rate',style: TextStyle(color: white),),
             onTap: () {
      // Update the state of the app
      // Then close the drawer
      Navigator.pop(context);
             },
           ),
            ListTile(
             leading: Icon(Icons.info_outline,color: white,),
             title: Text('About',style: TextStyle(color: white),),
             onTap: () {
      // Update the state of the app
      // Then close the drawer
      Navigator.pop(context);
             },
           ),
      
           ListTile(
             leading: Icon(Icons.settings,  color: white,),
             title: Text('Settings',style: TextStyle(color: white),),
             onTap: () {
               openAppSettings();
      // Update the state of the app
      // Then close the drawer
      // Navigator.push(context, MaterialPageRoute(builder: (context){
      //   return IndividualMusic();
      // }));
      
             },
           )
    ],
      ),
    );
  }
}