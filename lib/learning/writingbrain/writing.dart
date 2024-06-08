import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:tour/learning/writingbrain/writingbrain.dart';
import 'dart:ui' as ui;

class Writing extends StatefulWidget {
  final ColorScheme dync;
  Writing({required this.dync, Key? key}) : super(key: key);

  @override
  State<Writing> createState() => _WritingState();
}

class _WritingState extends State<Writing> {
  String headingcheck = "🐧🐧🐧🐧🐧";
  final WritingBrain _writingBrain = WritingBrain();
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  String translatedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dync.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            color: widget.dync.primary,
            child: Center(
              child: Text(
                headingcheck,
                style: TextStyle(fontSize: 20),
              ),
            ),
            height: MediaQuery.of(context).size.height / 10,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.dync.primaryContainer,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: SfSignaturePad(
                minimumStrokeWidth: 2,
                maximumStrokeWidth: 5,
                strokeColor: widget.dync.onPrimary,
                key: _signaturePadKey,
                backgroundColor: Colors.black,
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: () async {
          //     await _saveAndTranslateSignature();
          //   },
          //   child: Container(
          //     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //     height: MediaQuery.of(context).size.height / 11,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(50)),
          //       color: widget.dync.inversePrimary,
          //     ),
          //     child: Center(
          //       child: Text(
          //         "Translate",
          //         style: TextStyle(color: Colors.white, fontSize: 20),
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height / 11,
              decoration: BoxDecoration(
                color: widget.dync.onPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                translatedText,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _signaturePadKey.currentState!.clear();
              setState(() {
                translatedText = '';
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: MediaQuery.of(context).size.height / 11,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: widget.dync.inversePrimary,
              ),
              child: Center(
                child: Text(
                  "Clear",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAndTranslateSignature() async {
    final signatureImage = await _signaturePadKey.currentState?.toImage();
    final ByteData? byteData =
        await signatureImage?.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List? signatureBytes = byteData?.buffer.asUint8List();

    if (signatureBytes != null) {
      // Save the signature image to the device's local storage
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/signature.png';
      final File file = File(filePath);
      await file.writeAsBytes(signatureBytes);

      // Extract text from the image (hypothetical method)
      // String extractedText = await _writingBrain.extractTextFromImage(filePath);

      // // Translate the extracted text (hypothetical method)
      // String translation = await _writingBrain.translateText(extractedText);

      // setState(() {
      //   translatedText = translation;
      // });
    }
  }
}
