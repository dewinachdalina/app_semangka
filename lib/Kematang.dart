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
        backgroundColor: Color(0xffa2f271),
        title: const Text("Kematangan Semangka"),
      ),
      body: SafeArea(
          child: Center(
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Color(0xff40652e))),
          onPressed: () async {
            WidgetsFlutterBinding.ensureInitialized();
            await availableCameras().then((cameras) => Navigator.push(
                context, MaterialPageRoute(builder: (_) => kematangan())));
          },
          child: const Text("Take a Picture"),
        ),
      )),
    );
  }
}
