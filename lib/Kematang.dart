import 'package:app_semangka/CameraPagematang.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Kematang extends StatefulWidget {
  const Kematang({super.key});

  @override
  State<Kematang> createState() => _KematangState();
}

class _KematangState extends State<Kematang> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kematangan Semangka"),
      ),
      body: SafeArea(
          child: Center(
        child: ElevatedButton(
          onPressed: () async {
            await availableCameras().then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CameraPageKematangan(cameras: value))));
          },
          child: const Text("Take a Picture"),
        ),
      )),
    );
  }
}
