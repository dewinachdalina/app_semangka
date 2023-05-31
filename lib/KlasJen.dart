import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:app_semangka/CameraPage.dart';

class KlasJen extends StatefulWidget {
  const KlasJen({super.key});

  @override
  State<KlasJen> createState() => _KlasJenState();
}

class _KlasJenState extends State<KlasJen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Klasifikasi Jenis Semangka"),
      ),
      body: SafeArea(
          child: Center(
        child: ElevatedButton(
          onPressed: () async {
            await availableCameras().then((value) => Navigator.push(context,
                MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
          },
          child: const Text("Take a Picture"),
        ),
      )),
    );
  }
}
