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
    double baseWidth = 278;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    // double ffem = fem * 0.97;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffa2f271),
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
                      Container(
                        width: 200,
                        child: Container(
                          height: 200 * fem,
                          width: 200,
                          child: Image.asset(
                            'lib/image/Logo.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color(0xff40652e))),
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
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color(0xff40652e))),
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
