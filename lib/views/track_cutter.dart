import 'dart:io';
import 'package:easy_audio_trimmer/easy_audio_trimmer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_trimmer/flutter_audio_trimmer.dart';
import 'package:music/constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';


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


_saveAudio() async {
  setState(() {
    _progressVisibility = true;
  });

  // Generate a unique filename
  String fileName = '${DateTime.now().millisecondsSinceEpoch}.mp3';

  _trimmer.saveTrimmedAudio(
    startValue: _startValue,
    endValue: _endValue,
    // Provide only the filename, not the path
    audioFileName: fileName,
    onSave: (outputPath) async {
      setState(() {
        _progressVisibility = false;
      });

      // Save the file to the Music directory
      bool isSaved = await saveTrimmedAudio(outputPath.toString(), fileName);

      if (isSaved) {
        print('Audio successfully saved');
        // Show a confirmation to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Audio saved successfully!')),
        );
      } else {
        print('Failed to save audio');
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save audio')),
        );
      }

      // Delete the original file
      await File(outputPath.toString()).delete();
    },
  );
}

Future<bool> saveTrimmedAudio(String path, String fileName) async {
  try {
    // Request storage permissions
    if (await _requestPermission(Permission.storage)) {
      final musicDirectoryPath = await _getMusicDirectoryPath();

      // Ensure the directory exists
      final directory = Directory(musicDirectoryPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Define the new path for the audio file
      final newPath = '$musicDirectoryPath/$fileName';
      print('New path for trimmed audio: $newPath');

      // Copy the trimmed audio file to the new path
      final file = await File(path).copy(newPath);
      print('Saved trimmed audio to: ${file.path}');

      // Confirm the file exists
      if (await File(newPath).exists()) {
        return true;
      } else {
        return false;
      }
    } else {
      print('Storage permission denied');
      return false;
    }
  } catch (e) {
    print('Error saving trimmed audio: $e');
    return false;
  }
}

Future<bool> _requestPermission(Permission permission) async {
  final status = await permission.request();
  print('Permission status: $status');
  return status == PermissionStatus.granted;
}

Future<String> _getMusicDirectoryPath() async {
  if (Platform.isAndroid) {
    if (await _isAndroid10OrAbove()) {
      return await _getScopedStoragePath();
    } else {
      return await _getLegacyExternalStoragePath();
    }
  } else {
    throw UnsupportedError('This platform is not supported');
  }
}

Future<String> _getLegacyExternalStoragePath() async {
  final directory = Directory('/storage/emulated/0/Music');
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
  return directory.path;
}

Future<String> _getScopedStoragePath() async {
  final directory = await getExternalStorageDirectory();
  final scopedPath = directory!.parent!.parent!.parent!.path + '/Music';
  print('Scoped storage path: $scopedPath');
  return scopedPath;
}

Future<bool> _isAndroid10OrAbove() async {
  return Platform.isAndroid && (await _getAndroidVersion()) >= 29;
}

Future<int> _getAndroidVersion() async {
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  final sdkInt = androidInfo.version.sdkInt;
  print('Android SDK version: $sdkInt');
  return sdkInt;
}



// Future<void> saveToMusicDirectory(String path, String fileName) async {
//   final byteData = await File(path).readAsBytes();

//   final externalDir = await getExternalStoragePublicDirectory()
//   final musicDirPath = '${externalDir!.path}/Music';

//   // Ensure the directory exists
//   final musicDir = Directory(musicDirPath);
//   if (!await musicDir.exists()) {
//     await musicDir.create(recursive: true);
//   }

//   final fullPath = '$musicDirPath/$fileName';

//   final file = File(fullPath);
//   await file.writeAsBytes(byteData, flush: true);

//   debugPrint('Saved to Music directory: $fullPath');
// }


  File? _outputFile;
  Future<void> _onTrimAudioFile(BuildContext context) async {
    try {
      if (widget.file != null) {
        Directory directory = await getExternalStorageDirectories(type: StorageDirectory.music).then((value) => value!.first);

        File? trimmedAudioFile = await FlutterAudioTrimmer.trim(
          inputFile: widget.file,
          outputDirectory: directory,
          fileName: DateTime.now().millisecondsSinceEpoch.toString(),
          fileType: Platform.isAndroid ? AudioFileType.mp3 : AudioFileType.m4a,
          time: AudioTrimTime(
            start: const Duration(seconds: 50),
            end: const Duration(seconds: 100),
          ),
        );
        setState(() {
          _outputFile = trimmedAudioFile;
        });
      } else {
        _showSnackBar('Select audio file for trim',context);
      }
    } on AudioTrimmerException catch (e) {
      _showSnackBar(e.message,context);
    } catch (e) {
      _showSnackBar(e.toString(),context);
    }
  }

  void _showSnackBar(String message,BuildContext context) {
    SnackBar snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
      final ui=Provider.of<Ui_changer>(context,listen: false);
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: ui.ui_color,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text("Audio Trimmer",style: TextStyle(color: Colors.white),),
          backgroundColor: ui.ui_color,
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
                            _progressVisibility ? null : () async =>await _saveAudio(),
                          // onPressed: _progressVisibility ? null : () => _saveAudio(), 
                          // onPressed: ()async{
                          //  
                          // },
                        
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
                              borderPaintColor: ui.ui_dark_color,
                              borderWidth: 4,
                              borderRadius: 5,
                              circlePaintColor: ui.ui_dark_color.withOpacity(0.8),
                            ),
                            areaProperties:
                                TrimAreaProperties.edgeBlur(blurEdges: true),
                            onChangeStart: (value) => _startValue = value,
                            onChangeEnd: (value) => _endValue = value,
                            onChangePlaybackState: (value) {
                              if (mounted) {
                                setState(() {
                                   _isPlaying =value;
                                   });
                              }
                            },
                          )
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