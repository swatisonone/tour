import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tour/auth/login/login.dart';
import 'package:tour/auth/login/login_view_model.dart';
import 'package:tour/auth/register/register_view_model.dart';
import 'package:tour/landing/landing_page.dart';
import 'package:tour/screens/homePage.dart';
import 'package:tour/view_models/auth/posts_view_model.dart';
import 'package:tour/view_models/profile/edit_profile_view_model.dart';
import 'package:tour/view_models/status/status_view_model.dart';
import 'firebase_options.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Fluttertoast.showToast(msg: "Firebase initilized successfully!");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (context) => RegisterViewModel()),
        ChangeNotifierProvider(create: (context) => PostsViewModel()),
        ChangeNotifierProvider(create: (context) => StatusViewModel()),
        ChangeNotifierProvider(create: (context) => EditProfileViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tour',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login()
      ,
    );
  }
    Widget _buildTab(int index) {
    return MyHomePage(title: 'Pro-Planet', initialTabIndex: index);
  }
}
