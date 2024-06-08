import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tour/screens/utils/image_picker_class.dart';
import 'package:tour/translator/translator.dart';

class IndianLanguageOCR extends StatefulWidget {
  IndianLanguageOCR({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _IndianLanguageOCRState createState() => _IndianLanguageOCRState();
}

class _IndianLanguageOCRState extends State<IndianLanguageOCR> {
  String _ocrText = '';
  String _ocrHocr = '';
  var LangList = ["eng", "hin", "mar", "san", "urd"];
  var selectList = ["hin"];
  String path = "";
  bool bload = false;
  double _brightness = 0; // Initial brightness value
  bool bDownloadtessFile = false;
  CameraController? _cameraController;
  List<CameraDescription> cameras = [];
  bool _isCameraReady = false;
  double accuracy = 0.0;
  double loss = 0.0;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    initializeCamera();
    _cameraController;
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {
      _isCameraReady = true;
    });
  }

  Future<void> disposeCamera() async {
    await _cameraController?.dispose();
  }

  Future<void> runCamera() async {
    if (!_isCameraReady || _cameraController == null) {
      print('Camera not initialized.');
      return;
    }

    String imageFile = await pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      _ocr(imageFile);
    }
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path)
        .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void runFilePiker() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _ocr(pickedFile.path);
    }
  }

  void _ocr(url) async {
    if (selectList.length <= 0) {
      print("Please select language");
      return;
    }
    path = url;
    if (kIsWeb == false &&
        (url.indexOf("http://") == 0 || url.indexOf("https://") == 0)) {
      Directory tempDir = await getTemporaryDirectory();
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      String dir = tempDir.path;
      print('$dir/test.jpg');
      File file = new File('$dir/test.jpg');
      await file.writeAsBytes(bytes);
      url = file.path;
    }
    var langs = selectList.join("+");

    bload = true;
    setState(() {});

    _ocrText = await FlutterTesseractOcr.extractText(url, language: langs, args: {
      "preserve_interword_spaces": "1",
    });
    _ocrHocr = await FlutterTesseractOcr.extractHocr(url, language: langs, args: {
      "preserve_interword_spaces": "1",
    });
    print(_ocrText);

    // Translate the detected text if it's not empty
    if (_ocrText.isNotEmpty) {
      Translation translation =
          await Translator.translateDevnagariToEnglish(_ocrText);
      String translatedText = translation.text;

      // Update UI with detected and translated text
      setState(() {
        _ocrText = 'Detected Text: $_ocrText\n\nTranslated Text: $translatedText';
        bload = false;
      });

      // Save detected and translated text to Firestore
      postDetailsToFirestore(_ocrText, translatedText);
    } else {
      // If no text was detected, reset the UI
      setState(() {
        _ocrText = 'No text detected';
        bload = false;
      });
    }
  }

  void postDetailsToFirestore(String detectedText, String translatedText) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    await firebaseFirestore.collection("ocr_results").add({
      'uid': user?.uid,
      'detectedText': detectedText,
      'translatedText': translatedText,
      'timestamp': FieldValue.serverTimestamp(),
    });

    Fluttertoast.showToast(msg: "OCR result saved successfully");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0), // Adjust the radius for rounded corners
          ),
        ),
        title: Text("Indian Language OCR"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    ...LangList.map((e) {
                      return Row(children: [
                        Checkbox(
                            value: selectList.indexOf(e) >= 0,
                            onChanged: (v) async {
                              if (kIsWeb == false) {
                                Directory dir = Directory(
                                    await FlutterTesseractOcr.getTessdataPath());
                                if (!dir.existsSync()) {
                                  dir.create();
                                }
                                bool isInstalled = false;
                                dir.listSync().forEach((element) {
                                  String name = element.path.split('/').last;
                                  isInstalled |= name == '$e.traineddata';
                                });
                                if (!isInstalled) {
                                  bDownloadtessFile = true;
                                  setState(() {});
                                  HttpClient httpClient = new HttpClient();
                                  HttpClientRequest request = await httpClient.getUrl(Uri.parse(
                                      'https://github.com/tesseract-ocr/tessdata/raw/main/${e}.traineddata'));
                                  HttpClientResponse response = await request.close();
                                  Uint8List bytes = await consolidateHttpClientResponseBytes(response);
                                  String dir = await FlutterTesseractOcr.getTessdataPath();
                                  print('$dir/${e}.traineddata');
                                  File file = new File('$dir/${e}.traineddata');
                                  await file.writeAsBytes(bytes);
                                  bDownloadtessFile = false;
                                  setState(() {});
                                }
                                print(isInstalled);
                              }
                              if (selectList.indexOf(e) < 0) {
                                selectList.add(e);
                              } else {
                                selectList.remove(e);
                              }
                              setState(() {});
                            }),
                        Text(e)
                      ]);
                    }).toList(),
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: [
                      path.length <= 0
                          ? Container()
                          : path.indexOf("http") >= 0
                              ? Image.network(path)
                              : ColorFiltered(
                                  colorFilter: ColorFilter.matrix([
                                    _brightness,
                                    0,
                                    0,
                                    0,
                                    0, // Red channel
                                    0,
                                    _brightness,
                                    0,
                                    0,
                                    0, // Green channel
                                    0,
                                    0,
                                    _brightness,
                                    0,
                                    0, // Blue channel
                                    0,
                                    0,
                                    0,
                                    1,
                                    0, // Alpha channel
                                  ]),
                                  child: Image.file(File(path)),
                                ),
                      bload ? CircularProgressIndicator() : Text('$_ocrText'),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.black26,
            child: bDownloadtessFile
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator(), Text('Downloading Trained language files')],
                    ),
                  )
                : SizedBox(),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              runFilePiker();
            },
            tooltip: 'OCR',
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              runCamera();
            },
            tooltip: 'Take Picture',
            child: Icon(Icons.camera_alt),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              _showBrightnessDialog(context);
            },
            tooltip: 'Adjust Brightness',
            child: Icon(Icons.lightbulb),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              _ocr(path);
            },
            tooltip: 'Translate Language',
            child: Icon(Icons.translate),
          ),
        ],
      ),
    );
  }

  void _showBrightnessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adjust Brightness'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Brightness: ${(_brightness * 100).round()}%'),
              Slider(
                value: _brightness,
                min: -1.0,
                max: 1.0,
                onChanged: (value) {
                  setState(() {
                    _brightness = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class Translator {
  static Future<Translation> translateDevnagariToEnglish(String inputText) async {
    final translator = GoogleTranslator();
    return await translator.translate(inputText, to: 'en');
  }
}