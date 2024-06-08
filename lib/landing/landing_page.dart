import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tour/auth/login/login.dart';
import 'package:tour/auth/register/register.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeIn,
    );

    _controller!.forward();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation!,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tour',
                style: TextStyle(
                  fontSize: 32.0, // Increased font size for better emphasis
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Ubuntu-Regular',
                ),
              ),
              SizedBox(height: 20.0),
              Image.asset(
                'assets/images/tour_logo.png', // Assuming you have a logo for the app
                height: 150.0,
                width: 150.0,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(
                      builder: (_) => Login(),
                    ),
                  );
                },
                child: FadeTransition(
                  opacity: _fadeAnimation!,
                  child: Container(
                    height: 45.0,
                    width: 130.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      border: Border.all(color: Colors.grey),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Theme.of(context).colorScheme.secondary,
                          Color(0xff597FDB),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(
                      builder: (_) => Register(),
                    ),
                  );
                },
                child: FadeTransition(
                  opacity: _fadeAnimation!,
                  child: Container(
                    height: 45.0,
                    width: 130.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      border: Border.all(color: Colors.white),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Theme.of(context).colorScheme.secondary,
                          Color(0xff597FDB),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
