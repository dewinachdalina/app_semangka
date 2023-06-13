//import 'package:app_semangka/PreviewPage.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class CameraPageJenis extends StatefulWidget {
  const CameraPageJenis({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  State<CameraPageJenis> createState() => _CameraPageJenisState();
}

class _CameraPageJenisState extends State<CameraPageJenis> {
  String result = "";
  CameraController? _cameraController;
  late CameraImage _cameraImage;
  bool isWorking = false;
  bool _isRearCameraSelected = true;

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/jenisbest-fp16.tflite',
      labels: 'assets/jenis.txt',
    );
  }

  initCamera(CameraDescription cameraDescription) async {
    _cameraController?.dispose(); // Dispose the previous controller if exists

    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.low);

    try {
      await _cameraController!.initialize();
      setState(() {});
      _cameraController!.startImageStream((imageFromStream) {
        if (!isWorking) {
          isWorking = true;
          _cameraImage = imageFromStream;
          runModelOnStreamFrames();
        }
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  runModelOnStreamFrames() async {
    if (_cameraImage.planes.isNotEmpty) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: _cameraImage.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: _cameraImage.height,
        imageWidth: _cameraImage.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );

      result = "";
      recognitions?.forEach((response) {
        result += response["label"] +
            " " +
            (response["confidence"] as double).toStringAsFixed(2) +
            "\n\n";
      });
      setState(() {
        result;
      });
      isWorking = false;
    }
  }

  @override
  void initState() {
    super.initState();
    loadModel();
    if (widget.cameras.isNotEmpty) {
      initCamera(widget.cameras[0]);
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await _cameraController?.dispose();
    await Tflite.close();
  }

  // Future<void> takePicture() async {
  //   if (_cameraController == null || !_cameraController!.value.isInitialized) {
  //     return null;
  //   }
  //   if (_cameraController!.value.isTakingPicture) {
  //     return null;
  //   }
  //   try {
  //     await _cameraController!.setFlashMode(FlashMode.off);
  //     final XFile picture = await _cameraController!.takePicture();
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PreviewPage(
  //           picture: picture,
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     debugPrint('Error occurred while taking a picture: $e');
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _cameraController != null && _cameraController!.value.isInitialized
                ? CameraPreview(_cameraController!)
                : Container(
                    color: Colors.black,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  color: Colors.black,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 30,
                        icon: Icon(
                          _isRearCameraSelected
                              ? CupertinoIcons.switch_camera
                              : CupertinoIcons.switch_camera_solid,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          setState(() {
                            _isRearCameraSelected = !_isRearCameraSelected;
                          });
                          await initCamera(
                              widget.cameras[_isRearCameraSelected ? 0 : 1]);
                        },
                      ),
                    ),
                    // Expanded(
                    //   child: IconButton(
                    //     onPressed: takePicture,
                    //     iconSize: 50,
                    //     padding: EdgeInsets.zero,
                    //     constraints: const BoxConstraints(),
                    //     icon: const Icon(Icons.circle, color: Colors.white),
                    //   ),
                    // ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// //cobacoba
// late List<CameraDescription> cameras;

// class YoloVideo extends StatefulWidget {
//   YoloVideo({Key? key}) : super(key: key);

//   @override
//   State<YoloVideo> createState() => _YoloVideoState();
// }

// class _YoloVideoState extends State<YoloVideo> {
//   late CameraController controller;
//   late FlutterVision vision;
//   late List<Map<String, dynamic>> yoloResults;
//   CameraImage? cameraImage;
//   bool isLoaded = false;
//   bool isDetecting = false;

//   @override
//   void initState() {
//     super.initState();
//     init();
//   }

//   init() async {
//     cameras = await availableCameras();
//     vision = FlutterVision();
//     controller = CameraController(cameras[0], ResolutionPreset.low);
//     controller.initialize().then((value) {
//       loadYoloModel().then((value) {
//         setState(() {
//           isLoaded = true;
//           isDetecting = false;
//           yoloResults = [];
//         });
//       });
//     });
//   }

//   @override
//   void dispose() async {
//     super.dispose();
//     controller.dispose();
//     await vision.closeYoloModel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     if (!isLoaded) {
//       return const Scaffold(
//         body: Center(
//           child: Text("Model not loaded, waiting for it"),
//         ),
//       );
//     }
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         AspectRatio(
//           aspectRatio: controller.value.aspectRatio,
//           child: CameraPreview(
//             controller,
//           ),
//         ),
//         ...displayBoxesAroundRecognizedObjects(size),
//         Positioned(
//           bottom: 75,
//           width: MediaQuery.of(context).size.width,
//           child: Container(
//             height: 80,
//             width: 80,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(
//                   width: 5, color: Colors.white, style: BorderStyle.solid),
//             ),
//             child: isDetecting
//                 ? IconButton(
//                     onPressed: () async {
//                       stopDetection();
//                     },
//                     icon: const Icon(
//                       Icons.stop,
//                       color: Colors.red,
//                     ),
//                     iconSize: 50,
//                   )
//                 : IconButton(
//                     onPressed: () async {
//                       await startDetection();
//                     },
//                     icon: const Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                     ),
//                     iconSize: 50,
//                   ),
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> loadYoloModel() async {
//     await vision.loadYoloModel(
//         labels: 'assets/jenis.txt',
//         modelPath: 'assets/jenisbest-fp16.tflite',
//         modelVersion: "yolov5",
//         numThreads: 2,
//         useGpu: true);
//     setState(() {
//       isLoaded = true;
//     });
//   }

//   Future<void> yoloOnFrame(CameraImage cameraImage) async {
//     final result = await vision.yoloOnFrame(
//         bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
//         imageHeight: cameraImage.height,
//         imageWidth: cameraImage.width,
//         iouThreshold: 0.4,
//         confThreshold: 0.4,
//         classThreshold: 0.5);
//     if (result.isNotEmpty) {
//       setState(() {
//         yoloResults = result;
//       });
//     }
//   }

//   Future<void> startDetection() async {
//     setState(() {
//       isDetecting = true;
//     });
//     if (controller.value.isStreamingImages) {
//       return;
//     }
//     await controller.startImageStream((image) async {
//       if (isDetecting) {
//         cameraImage = image;
//         yoloOnFrame(image);
//       }
//     });
//   }

//   Future<void> stopDetection() async {
//     setState(() {
//       isDetecting = false;
//       yoloResults.clear();
//     });
//   }

//   List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
//     if (yoloResults.isEmpty) return [];
//     double factorX = screen.width / (cameraImage?.height ?? 1);
//     double factorY = screen.height / (cameraImage?.width ?? 1);

//     Color colorPick = const Color.fromARGB(255, 50, 233, 30);

//     return yoloResults.map((result) {
//       return Positioned(
//         left: result["box"][0] * factorX,
//         top: result["box"][1] * factorY,
//         width: (result["box"][2] - result["box"][0]) * factorX,
//         height: (result["box"][3] - result["box"][1]) * factorY,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//             border: Border.all(color: Colors.pink, width: 2.0),
//           ),
//           child: Text(
//             "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
//             style: TextStyle(
//               background: Paint()..color = colorPick,
//               color: Colors.white,
//               fontSize: 18.0,
//             ),
//           ),
//         ),
//       );
//     }).toList();
//   }
// }
