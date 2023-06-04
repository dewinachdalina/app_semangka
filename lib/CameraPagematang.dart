import 'package:app_semangka/PreviewPage.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class CameraPageKematangan extends StatefulWidget {
  const CameraPageKematangan({Key? key, required this.cameras})
      : super(key: key);

  final List<CameraDescription> cameras;

  @override
  State<CameraPageKematangan> createState() => _CameraPageKematanganState();
}

class _CameraPageKematanganState extends State<CameraPageKematangan> {
  String result = "";
  late CameraController _cameraController;
  late CameraImage _cameraImage;
  bool isWorking = false;
  bool _isRearCameraSelected = true;

  loadModel() async {
    await Tflite.loadModel(
      model: "kematangbest-fp16.tflite",
      labels: "kematang.txt",
    );
  }

  initCamera(CameraDescription cameraDescription) {
    _cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.high);
    _cameraController.initialize().then((cameras) {
      if (!mounted) {
        return;
      }
      setState(() {
        _cameraController.startImageStream((imageFromStream) => {
              if (!isWorking)
                {
                  isWorking = true,
                  _cameraImage = imageFromStream,
                  runModelOnStreamFrames(),
                }
            });
      });
    });
  }

  runModelOnStreamFrames() async {
    // ignore: unnecessary_null_comparison
    if (_cameraImage != null) {
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
            (response["cofidence"] as double).toStringAsFixed(2) +
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
  }

  @override
  void dispose() async {
    super.dispose();
    await Tflite.close();
    _cameraController.dispose();
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewPage(
                    picture: picture,
                  )));
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        (_cameraController.value.isInitialized)
            ? CameraPreview(_cameraController)
            : Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator())),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  color: Colors.black),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                    child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 30,
                  icon: Icon(
                      _isRearCameraSelected
                          ? CupertinoIcons.switch_camera
                          : CupertinoIcons.switch_camera_solid,
                      color: Colors.white),
                  onPressed: () {
                    setState(
                        () => _isRearCameraSelected = !_isRearCameraSelected);
                    initCamera(widget.cameras[_isRearCameraSelected ? 0 : 1]);
                  },
                )),
                Expanded(
                    child: IconButton(
                  onPressed: takePicture,
                  iconSize: 50,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.circle, color: Colors.white),
                )),
                const Spacer(),
              ]),
            )),
      ]),
    ));
  }
}
