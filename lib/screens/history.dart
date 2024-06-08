import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OCRResultsPage extends StatefulWidget {
  @override
  _OCRResultsPageState createState() => _OCRResultsPageState();
}

class _OCRResultsPageState extends State<OCRResultsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR Results'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('ocr_results')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final results = snapshot.data!.docs;
          List<Card> resultCards = results.map((result) {
            var data = result.data() as Map<String, dynamic>;
            var detectedText = data['detectedText'] ?? '';
            var translatedText = data['translatedText'] ?? '';
            var timestamp = (data['timestamp'] as Timestamp).toDate();

            return Card(
              margin: EdgeInsets.all(10.0),
              child: ListTile(
                title: Text('Detected Text: $detectedText'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Translated Text: $translatedText'),
                    Text('Timestamp: ${timestamp.toString()}' ,style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            );
          }).toList();

          return ListView(
            children: resultCards,
          );
        },
      ),
    );
  }
}
