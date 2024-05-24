import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:music/constants.dart';
import 'package:provider/provider.dart';

class equalizer_page extends StatefulWidget {
  const equalizer_page({Key? key}) : super(key: key);
static const String routeName = '/equalizer_page';
  @override
  State<equalizer_page> createState() => _equalizer_pageState();
}

class _equalizer_pageState extends State<equalizer_page> {
  bool enableCustomEQ = false;


  @override
  Widget build(BuildContext context) {
    final ui=Provider.of<Ui_changer>(context);
    return Scaffold(
      
      body: Container(
       color: ui.ui_color,
        child: ListView(
          children: [
            
            
            
            Container(
              color: Colors.grey.withOpacity(0.1),
              child: SwitchListTile(
                activeColor: white,
                inactiveTrackColor: Colors.grey,
                title: Text('Custom Equalizer',style: TextStyle(color: white),),
                value: enableCustomEQ,
                onChanged: (value) {
                  EqualizerFlutter.setEnabled(value);
                  setState(() {
                    enableCustomEQ = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder<List<int>>(
              future: EqualizerFlutter.getBandLevelRange(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CustomEQ(enableCustomEQ, snapshot.data!);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            Center(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                
                ),
                child: Builder(
                  builder: (context) {
                    return InkWell(
                      child: Text(
                        'Choose Sound Technology',

                        style: TextStyle(color: ui.ui_color,fontSize: 16,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      
                    
                      onTap: () async {
                        try {
                          await EqualizerFlutter.open(0);
                        } on PlatformException catch (e) {
                          final snackBar = SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text('${e.message}\n${e.details}'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            //speaker animation
          
          ],
        ),
      ),
    );
  }
}

class CustomEQ extends StatefulWidget {
  const CustomEQ(this.enabled, this.bandLevelRange);

  final bool enabled;
  final List<int> bandLevelRange;

  @override
  _CustomEQState createState() => _CustomEQState();
}

class _CustomEQState extends State<CustomEQ> {
  late double min, max;
  String? _selectedValue;
  late Future<List<String>> fetchPresets;

  @override
  void initState() {
    super.initState();
    min = widget.bandLevelRange[0].toDouble();
    max = widget.bandLevelRange[1].toDouble();
    fetchPresets = EqualizerFlutter.getPresetNames();
  }

  @override
  Widget build(BuildContext context) {
  
    return FutureBuilder<List<int>>(
      future: EqualizerFlutter.getCenterBandFreqs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!.asMap().entries.map((entry) {
                  int bandId = entry.key;
                  int freq = entry.value;
                  return _buildSliderBand(freq, bandId);
                }).toList(),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: _buildPresets(context),
              ),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

Widget _buildSliderBand(int freq, int bandId) {
  
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.31,
          child: FutureBuilder<int>(
            future: EqualizerFlutter.getBandLevel(bandId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!.toDouble();
                return RotatedBox(
                  quarterTurns: 1,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                        trackHeight: 1, trackShape: SliderCustomTrackShape()),
                    child: Center(
                      child: Slider(
                        activeColor: white,
                        inactiveColor: Colors.grey,
                        min: min,
                        max: max,
                        value: data,
                        onChanged: widget.enabled // Check if custom equalizer is enabled
                            ? (lowerValue) {
                                setState(() {
                                  EqualizerFlutter.setBandLevel(
                                      bandId, lowerValue.toInt());
                                });
                              }
                            : null, // If not enabled, do not change the slider value
                      ),
                    ),
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        Text('${freq ~/ 1000} Hz', style: TextStyle(color: Colors.white)),
      ],
    ),
  );
}

  Widget _buildPresets(BuildContext context) {
    final ui=Provider.of<Ui_changer>(context);
    return FutureBuilder<List<String>>(
      future: fetchPresets,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final presets = snapshot.data;
          if (presets!.isEmpty) return Text('No presets available!');
          return DropdownButtonFormField(
dropdownColor: ui.ui_color,
            decoration: InputDecoration(

              labelText: 'Available Presets',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
            ),
            value: _selectedValue,
            onChanged: widget.enabled
                ? (String? value) {
                    EqualizerFlutter.setPreset(value!);
                    setState(() {
                      _selectedValue = value;
                    });
                  }
                : null,
            items: presets.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
          );
        } else if (snapshot.hasError)
          return Text(snapshot.error.toString());
        else
          return CircularProgressIndicator();
      },
    );
  }
}

class SliderCustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = (parentBox.size.height) / 2;
    final double trackWidth = 230;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight!);
  }
}
