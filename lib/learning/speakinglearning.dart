import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tour/learning/Speaking.dart';

import '../translator/translator.dart';


class SpeakingLearning extends StatefulWidget {
  final String cat;
  final ColorScheme dync;

  SpeakingLearning({required this.cat, required this.dync});

  @override
  State<SpeakingLearning> createState() => _SpeakingLearningState();
}

class _SpeakingLearningState extends State<SpeakingLearning> {
  double progress = 0;
  List questions = [];
  FlutterTts flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = "";
  final TextEditingController _textController = TextEditingController();
  final translator = GoogleTranslator();
  int x = 0;
  bool islist = false;
  late String langCode;

  @override
  void initState() {
    super.initState();
    langCode = 'en-US'; // Set default language code
    questions = [
      ['Question 1', 'Answer 1'],
      ['Question 2', 'Answer 2'],
      // Add more questions and answers here
    ];

    listenForPermissions();
    if (!_speechEnabled) {
      _initSpeech();
    }
  }

  void listenForPermissions() async {
    final status = await Permission.microphone.status;
    switch (status) {
      case PermissionStatus.denied:
        print(status);
        requestForPermission();
        break;
      case PermissionStatus.granted:
        break;
      case PermissionStatus.limited:
        break;
      case PermissionStatus.permanentlyDenied:
        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.provisional:
        // Handle this case if needed
        print("default");
        break;
    }
  }

  Future<void> requestForPermission() async {
    await Permission.microphone.request();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  void _startListening() async {
    _speechToText.initialize();
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 10),
      localeId: langCode,
      cancelOnError: false,
      partialResults: false,
      listenMode: ListenMode.dictation,
    );
    print(_speechToText.isListening);
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() async {
      _lastWords = "$_lastWords${result.recognizedWords} ";
      print(_lastWords);
      print(questions[x][1]);
      bool aa = customCompare(questions[x][1], _lastWords);
      print(aa);
      if (aa) {
        print("valid");
        setState(() {
          print(progress);
          if (progress == 0.8) {
            // Logic to handle completion
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Speaking(
                dync: widget.dync,
              ),
            ));
          }
          x += 1;
          progress += 0.2;
          _lastWords = "";
        });
      } else {
        _textController.text = _lastWords;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.dync.primary,
        body: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back_ios_new_sharp)),
                    
                      Icon(Icons.report)
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  children: [
                    Text(
                      questions[x][0],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: widget.dync.onPrimary),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      questions[x][1],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: widget.dync.primaryContainer,
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
              Container(
                height: 150,
                color: widget.dync.primary,
                padding: EdgeInsets.all(16),
                child: TextField(
                  enabled: false,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, color: Colors.red),
                  controller: _textController,
                  minLines: 6,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: widget.dync.primary,
                  ),
                ),
              ),
              Container(
                child: Text(questions[x][0],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        flutterTts.setLanguage(langCode);
                        flutterTts.speak(questions[x][1]);
                      },
                      child: Container(
                        margin: EdgeInsets.all(15),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: widget.dync.primaryContainer,
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Icon(
                          Icons.speaker,
                          color: widget.dync.primary,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          islist = islist ? false : true;
                          if (!islist) {
                            _stopListening();
                          } else {
                            _textController.text = "";
                            _startListening();
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(15),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: widget.dync.primaryContainer,
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Icon(
                          islist ? Icons.cancel : Icons.mic,
                          color: widget.dync.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }
}

Map<String, String> trcode = {
  "hr": "hr-HR",
  "ko": "ko-KR",
  "mr": "mr-IN",
  "ru": "ru-RU",
  "zh": "zh-TW",
  "hu": "hu-HU",
  "sw": "sw-KE",
  "th": "th-TH",
  "en": "en-US",
  "hi": "hi-IN",
  "fr": "fr-FR",
  "ja": "ja-JP",
  "ta": "ta-IN",
  "ro": "ro-RO"
};

bool customCompare(String ques, String ans) {
  print("compare");
  int count = 0;
  print(ques);
  bool con = false;
  for (int i = 0; i < ans.length; i++) {
    if (ques.contains(ans[i])) {
      count++;
    }
    if (count > ques.length - 4) {
      con = true;
    }
  }
  return con;
}
