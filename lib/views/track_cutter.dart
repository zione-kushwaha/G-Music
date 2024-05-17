import 'dart:io';
import 'package:easy_audio_trimmer/easy_audio_trimmer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


class track_cutter extends StatelessWidget {
  const track_cutter({super.key});
 static const routeName = '/track-cutter';
  @override
  Widget build(BuildContext context) {
    return const FileSelectorWidget();
    
    }
}

class FileSelectorWidget extends StatefulWidget {
  const FileSelectorWidget({super.key});

  @override
  State<FileSelectorWidget> createState() => _FileSelectorWidgetState();
}

class _FileSelectorWidgetState extends State<FileSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Trimmer"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.audio,
                allowCompression: false,
              );
              if (result != null) {
                File file = File(result.files.single.path!);
                // ignore: use_build_context_synchronously
                print("File path: ${file.path}");
                print('............................................');
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return AudioTrimmerView(file:  file);
                  }),
                );
              }
            },
            child: const Text("Select File")),
      ),
    );
  }
}

class AudioTrimmerView extends StatefulWidget {
  final File file;
  static const routeName = '/audio-trimmer';

  

  const AudioTrimmerView({super.key, required this.file});
  @override
  State<AudioTrimmerView> createState() => _AudioTrimmerViewState();
}

class _AudioTrimmerViewState extends State<AudioTrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _loadAudio();
  }

  void _loadAudio() async {
    setState(() {
      isLoading = true;
    });
    await _trimmer.loadAudio(audioFile: widget.file);
    setState(() {
      isLoading = false;
    });
  }

  _saveAudio() {
    setState(() {
      _progressVisibility = true;
    });

    _trimmer.saveTrimmedAudio(
      startValue: _startValue,
      endValue: _endValue,
      audioFileName: DateTime.now().millisecondsSinceEpoch.toString(),
      onSave: (outputPath) {
        setState(() {
          _progressVisibility = false;
        });
        debugPrint('OUTPUT PATH: $outputPath');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Audio Trimmer"),
        ),
        body: isLoading
            ? const CircularProgressIndicator()
            : Center(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Visibility(
                        visible: _progressVisibility,
                        child: LinearProgressIndicator(
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                        ),
                      ),
                      ElevatedButton(
                        onPressed:
                            _progressVisibility ? null : () => _saveAudio(),
                        child: const Text("SAVE"),
                      ),
                      // AudioViewer(trimmer: _trimmer),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TrimViewer(
                            trimmer: _trimmer,
                            viewerHeight: 100,
                            viewerWidth: MediaQuery.of(context).size.width,
                            durationStyle: DurationStyle.FORMAT_MM_SS,
                            backgroundColor: Theme.of(context).primaryColor,
                            barColor: Colors.white,
                            durationTextStyle: TextStyle(
                                color: Theme.of(context).primaryColor),
                            allowAudioSelection: true,
                            editorProperties: TrimEditorProperties(
                              circleSize: 10,
                              borderPaintColor: Colors.pink,
                              borderWidth: 4,
                              borderRadius: 5,
                              circlePaintColor: Colors.pink.shade800,
                            ),
                            areaProperties:
                                TrimAreaProperties.edgeBlur(blurEdges: true),
                            onChangeStart: (value) => _startValue = value,
                            onChangeEnd: (value) => _endValue = value,
                            onChangePlaybackState: (value) {
                              if (mounted) {
                                setState(() => _isPlaying = value);
                              }
                            },
                          ),
                        ),
                      ),
                      TextButton(
                        child: _isPlaying
                            ? Icon(
                                Icons.pause,
                                size: 80.0,
                                color: Theme.of(context).primaryColor,
                              )
                            : Icon(
                                Icons.play_arrow,
                                size: 80.0,
                                color: Theme.of(context).primaryColor,
                              ),
                        onPressed: () async {
                          bool playbackState =
                              await _trimmer.audioPlaybackControl(
                            startValue: _startValue,
                            endValue: _endValue,
                          );
                          setState(() => _isPlaying = playbackState);
                        },
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}