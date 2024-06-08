import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tour/learning/Speaking.dart';
import 'package:tour/learning/translator/translator_ui.dart';
import 'package:tour/learning/writingbrain/writing.dart';
import 'package:tour/models/user.dart';
import 'package:tour/ocr.dart';
import 'package:tour/screens/location.dart';
import 'package:tour/translator/translation_page.dart';
import 'package:tour/utils/firebase.dart';

class MyHomeScreen extends StatefulWidget {
  
  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  int _currentIndex = 0;
   User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final ColorScheme lightDynamic = ColorScheme.fromSwatch(
  primarySwatch: Colors.blue,
).copyWith(
  secondary: Colors.amber,
);
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
ThemeData get lightDynamicTheme => ThemeData(
  fontFamily: 'Ubuntu',
  colorScheme: lightDynamic,
  useMaterial3: true,
);

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  
  }
  Widget _buildBody() {
    return SingleChildScrollView(

      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            _buildTopBanner(),
            
            _buildGifCard(),
            
            // _buildBottomBanner(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBanner() {
  return Container(
    height: 340.0,
    color: Colors.white,
    child: Stack(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height/3,
          child: Image.asset(
            'assets/images/header.jpg', // Replace with the actual image path
            fit: BoxFit.cover, // You can adjust the BoxFit according to your needs
            
          ),
          
        ),
        Positioned(
  bottom: 5, // Adjust the bottom position to add space
  left: MediaQuery.of(context).size.width / 2 - 65, // Adjust the position of the circular image
  child: Padding(
    padding: EdgeInsets.all(5.0), // Add padding around the circular image
    child: Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 7.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(0, 249, 247, 247),
            spreadRadius: 5,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: CircleAvatar(
                                    radius: 40.0,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    child: Center(
                                      child: Text(
                                        '${loggedInUser.username![0].toUpperCase()}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 0.0,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  )
    ),
  ),
),

      ],
    ),
  );
}


  // Widget _buildBottomBanner() {
  //   return Container(
  //     height: 200.0,
  //     color: Colors.blue,
  //     child: Container(
  //       width:double.infinity ,
  //       child: Image.asset(
  //         'assets/images/header.jpg', // Replace with the actual image path
  //         fit: BoxFit.cover, // You can adjust the BoxFit according to your needs
  //       ),
  //     ),
  //   );
  // }
  
  Widget _buildGifCard() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ClipPath(
        
        child: Container(
        
          height: height*0.5,
          
        child: Center(
          child: Stack(
            children: [
              Center(
                child: Text("Start your journey here"),
              ),
              Positioned(
        top: 50.0,
        left: 50.0,
        child: GestureDetector(
          
          onTap: () => 
          Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => LocationsListScreen(),),
),
          child: Container(
        width: 100,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0), // Adjust the circular border radius
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 5, // Blur radius
              offset: Offset(0, 3), // Offset from the top
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0), // ClipRRect to ensure image is within rounded borders
          child: Image.asset(
            "assets/images/near_place .png",
            fit: BoxFit.cover,
          ),
        ),
          ),
        ),
      ),
              Positioned(
        top: 50.0,
        right: 50.0,
        child: GestureDetector(
          onTap: () => {},
//           Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) => Writing(dync: lightDynamic),),
// ),
          child: Container(
        width: 100,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0), // Adjust the circular border radius
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 5, // Blur radius
              offset: Offset(0, 3), // Offset from the top
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0), // ClipRRect to ensure image is within rounded borders
          child: Image.asset(
            "assets/images/tour.png",
            fit: BoxFit.cover,
          ),
        ),
          ),
        ),
      ),
      
              Positioned(
        bottom: 50.0,
        right: 50,
        child: GestureDetector(
          onTap: (){
            Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => Writing(dync: lightDynamic)),
);
          },
          child: Container(
        width: 100,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0), // Adjust the circular border radius
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 5, // Blur radius
              offset: Offset(0, 3), // Offset from the top
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0), // ClipRRect to ensure image is within rounded borders
          child: Image.asset(
            "assets/images/translator.jpg",
            fit: BoxFit.cover,
          ),
        ),
          ),
        ),
      ),
      Positioned(
        bottom: 50.0,
        left: 50.0,
        child: GestureDetector(
          onTap: () async {
              
            Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => TranslationPage()),
);
          },
          child: Container(
        width: 100,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0), // Adjust the circular border radius
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 5, // Blur radius
              offset: Offset(0, 3), // Offset from the top
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0), // ClipRRect to ensure image is within rounded borders
          child: Image.asset(
            "assets/images/india.jpeg",
            fit: BoxFit.cover,
          ),
        ),
          ),
        ),
      ),
              
              // Center(
              //   child: GestureDetector(
              //     onTap: () => print('Main button tapped'),
              //     child: CircleAvatar(
              //       backgroundColor: Colors.black,
              //       radius: 40.0,
              //       child: Icon(Icons.home, color: Colors.white, size: 50.0),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        ),
      )
    );
  }


  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class MyTheme {
  static final ColorScheme lightDynamic = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
  ).copyWith(
    secondary: Colors.amber,
  );

  static ThemeData get lightDynamicTheme => ThemeData(
    fontFamily: 'Ubuntu',
    colorScheme: lightDynamic,
    useMaterial3: true,
  );
}

