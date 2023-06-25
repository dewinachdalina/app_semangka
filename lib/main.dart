import 'package:app_semangka/Kematang.dart';
import 'package:app_semangka/KlasJen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Applikasi Semangka',
    home: MainPage(),
  ));
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Aplikasi Semangka'),
        ),
        body: ListView(
          children: [
            Column(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage("lib/image/Watermelon Apps.png"),
                              fit: BoxFit.fitWidth,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(1),
                        child: const Text(
                          'Selamat Datang! Silahkan Pilih Sesuai Kebutuhan.',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: ElevatedButton(
                              child: const Text('Klasifikasi Jenis Semangka'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const KlasJen()),
                                );
                              },
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: ElevatedButton(
                              child: const Text('Kematangan Semangka'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Kematang()),
                                );
                              },
                            ),
                          ))
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }
}
