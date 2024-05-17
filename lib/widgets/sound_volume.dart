import 'package:flutter/material.dart';
import 'package:music/providers/SongProvider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class soundVolume extends StatefulWidget {
  const soundVolume({super.key,});

  @override
  State<soundVolume> createState() => _soundVolumeState();
}

class _soundVolumeState extends State<soundVolume> {
  @override
  Widget build(BuildContext context) { 
    final provider = Provider.of<SongProvier>(context);
    return  SfRadialGauge(
          animationDuration: 1,
          enableLoadingAnimation: true,
          axes: [
            RadialAxis( 
              useRangeColorForAxis: true,
              startAngle: 280,
              endAngle: 150,
              canRotateLabels: false,
              interval: 0.1,
              isInversed: false,
              maximum: 1,
              minimum: 0,
              showAxisLine: true,
              showLabels: true,
              showTicks: true,
              labelFormat: '{value}',
              ranges: [
                GaugeRange(
                  startValue: 0,
                  endValue: provider.sound_volume,
                  color: Colors.red
                )
              ],
              pointers: [
                MarkerPointer(
                  color: Colors.red,
                  value: provider.sound_volume,
                  onValueChanged: (newValue) {
                    provider.change_volume(newValue);
                  },
                  enableAnimation: true,
                  enableDragging: true,
                  markerType: MarkerType.circle,
                  markerWidth: 20,
                  markerHeight: 20,
                ),
              ],
              annotations: [
                GaugeAnnotation(
                  horizontalAlignment: GaugeAlignment.center,
                  widget: NewWidget(provider: provider),
                )
              ],
            ),
          ],
        );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    required this.provider,
  });

  final SongProvier provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
      ),
      child:ClipRRect(
      borderRadius: BorderRadius.circular(200),
      child: QueryArtworkWidget(
        quality: 100,
    artworkQuality: FilterQuality.high,
    
        artworkBorder: BorderRadius.circular(8),
        artworkClipBehavior: Clip.antiAliasWithSaveLayer,
       
        artworkFit: BoxFit.cover,
        nullArtworkWidget: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: Image.asset('assets/images/cover.jpg', fit: BoxFit.cover),
        ),
        id:  provider.playingSongId,
       keepOldArtwork: true,
        type: ArtworkType.ALBUM,
      ),
    ),
    );
  }
}

