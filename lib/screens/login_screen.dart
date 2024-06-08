import 'dart:math' as math;
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/center_widget/center_widget.dart';
import 'components/login_content.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Blur Effect
          Positioned.fill(
            child: Image.asset(
              'assets/images/img1.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.3), // Adjust opacity as needed
              ),
            ),
          ),
          // Rest of your UI components
        
          CenterWidget(size: screenSize),
          const LoginContent(),
        ],
      ),
    );
  }
}
