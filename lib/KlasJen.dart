import 'package:app_semangka/CameraPagejenis.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: Color(0xffa2f271),
        title: const Text("Klasifikasi Jenis Semangka"),
      ),
      body: SafeArea(
          child: Center(
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Color(0xff40652e))),
          onPressed: () async {
            await availableCameras().then((value) => Navigator.push(
                context, MaterialPageRoute(builder: (_) => jenis())));
          },
          child: const Text("Take a Picture"),
        ),
      )),
    );
  }
}
