import 'package:flutter/material.dart';
import 'package:tour/src/google_translator.dart';
// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'devnagari to English Translator',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: TranslationPage(),
//     );
//   }
// }

class TranslationPage extends StatefulWidget {
  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final TextEditingController _controller = TextEditingController();
  String _translation = '';

  void _translateText() async {
    String inputText = _controller.text.trim();
    if (inputText.isNotEmpty) {
      final translator = GoogleTranslator();
      Translation translatedText = await translator.translate(inputText, to: 'en');
      setState(() {
        _translation = translatedText.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('devnagari to English Translator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter text in devnagari',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _translateText,
              child: Text('Translate'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Translated Text:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              _translation,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
