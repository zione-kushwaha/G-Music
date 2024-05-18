import 'package:flutter/material.dart';
import 'package:glossy/glossy.dart';
import 'package:music/constants.dart';
import 'package:provider/provider.dart';


class test_screen extends StatelessWidget {
  const test_screen({super.key});
  static const namedRoute = '/test_screen';

  @override
  Widget build(BuildContext context) {
    final ui = Provider.of<Ui_changer>(
      context,
    );
    return  Scaffold(
        backgroundColor:ui. ui_color.withOpacity(0.4),
        appBar: AppBar(
          title: const Text('Glass Morphism Example'),
        ),
        body: Center(
          child: SizedBox(
            width: 600,
            height: 600,
            child: Stack(
              children: [
                Container(
                  height: 140,
                  width: 140,
                  decoration: (BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(70))),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: (BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(70))),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: GlossyContainer(
                    width: 300,
                    height: 500,
                    borderRadius: BorderRadius.circular(12),
                    child: const Center(
                      child: Text(
                        'Glass Morphism',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}