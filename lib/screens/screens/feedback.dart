import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tour/models/user.dart';
import 'package:tour/utils/firebase.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _controller = TextEditingController();
  final String feedbackUid = 'wbg2DcPnX2gXtdkRlAmM23QkooX2';
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  @override
  void initState() {
    print('--------------------$user----------------------');
    super.initState();
    usersRef.doc(user?.uid).get().then((value) {
      this.loggedInUser = UserModel.fromJson(
        value.data() as Map<String, dynamic>,
      );
      setState(() {});
    });
  }
  Future<void> sendFeedback(String feedback) async {
    try {
      await FirebaseFirestore.instance
          .collection('feedbacks')
          .doc(feedbackUid)
          .set({
            'email': loggedInUser.email,
        'feedback': feedback,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Feedback sent successfully!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to send feedback: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter your feedback'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String feedback = _controller.text;
                if (feedback.isNotEmpty) {
                  sendFeedback(feedback);
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
