import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tour/screens/homePage.dart';
import 'package:tour/screens/utils/constants.dart';
import 'package:tour/screens/utils/helper_functions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../model/user_model.dart';
import '../animations/change_screen_animation.dart';
import 'bottom_text.dart';
import 'top_text.dart';

enum Screens {
  createAccount,
  welcomeBack,
}

class LoginContent extends StatefulWidget {
  const LoginContent({Key? key}) : super(key: key);

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with TickerProviderStateMixin {
  late final List<Widget> createAccountContent;
  late final List<Widget> loginContent;
  final _auth = FirebaseAuth.instance;
  late String userUid;
  String? errorMessage;
  final TextEditingController firstNameEditingController =
      TextEditingController();
  final TextEditingController secondNameEditingController =
      TextEditingController();
  final TextEditingController EmailEditingController = TextEditingController();
  final TextEditingController PasswordEditingController =
      TextEditingController();

  Widget inputField(String hint, IconData iconData,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextFormField(
            obscureText: obscureText,
            controller: obscureText
                ? null
                : hint == 'First Name'
                    ? firstNameEditingController
                    : hint == 'Last Name'
                        ? secondNameEditingController
                        : hint == 'Email'
                            ? EmailEditingController
                            : hint == 'Password'
                                ? PasswordEditingController
                                : null,
            validator: (value) {
              
              RegExp regex = new RegExp(r'^.{3,}$');
              if (value!.isEmpty) {
                return ("First Name cannot be Empty");
              }
              if (hint == 'Email' && !regex.hasMatch(value)) {
                return ("Enter Valid name(Min. 3 Character)");
              }
              return null;
            },
            
            onSaved: (value) {
              
              if (hint == 'First Name') {
                firstNameEditingController.text = value!;
              } else if (hint == 'Last Name') {
                secondNameEditingController.text = value!;
              } else if (hint == 'Email') {
                EmailEditingController.text = value!;
              } else if (hint == 'Password') {
                
                PasswordEditingController.text = value!;
              }
              
            },
            
            textInputAction: TextInputAction.next,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              prefixIcon: Icon(iconData),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: () {
          if (title == "Sign Up") {
            print("//////////password/////////////"+"${PasswordEditingController.text}");
            signUp(EmailEditingController.text, '123456');
            // signUp('swatisonone@gmail.com','123456');
          } else {
            signIn(EmailEditingController.text, '123456');
            // signIn('swatisonone1002@gmail.com','123456');
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14), backgroundColor: kSecondaryColor,
          shape: const StadiumBorder(),
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'or',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget logos() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/facebook.png'),
          const SizedBox(width: 24),
          Image.asset('assets/images/google.png'),
        ],
      ),
    );
  }

  Widget forgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 110),
      child: TextButton(
        onPressed: () {},
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    createAccountContent = [
      inputField('First Name', Ionicons.person_outline),
      inputField('Last Name', Ionicons.person_outline),
      inputField('Email', Ionicons.mail_outline),
      inputField('Password', Ionicons.lock_closed_outline, obscureText: true),
      inputField('Country', Ionicons.flag),
      loginButton('Sign Up'),
      orDivider(),
      logos(),
    ];

    loginContent = [
      inputField('Email', Ionicons.mail_outline),
      inputField('Password', Ionicons.lock_closed_outline, obscureText: true),
      loginButton('Log In'),
      forgotPassword(),
    ];

    ChangeScreenAnimation.initialize(
      vsync: this,
      createAccountItems: createAccountContent.length,
      loginItems: loginContent.length,
    );

    for (var i = 0; i < createAccountContent.length; i++) {
      createAccountContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.createAccountAnimations[i],
        child: createAccountContent[i],
      );
    }

    for (var i = 0; i < loginContent.length; i++) {
      loginContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.loginAnimations[i],
        child: loginContent[i],
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    ChangeScreenAnimation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 136,
          left: 24,
          child: TopText(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: createAccountContent,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: loginContent,
              ),
            ],
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: BottomText(),
          ),
        ),
      ],
    );
  }

  void signIn(String email, String password) async {
    if(password.isEmpty){
      print("///////////////vallidator//////////////"+"$email"+"   "+" $password");
    }
    
    // Implement your sign-in logic
    try {
      await _auth
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((uid) => {
                userUid = '$uid',
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.of(context).pushReplacement(CupertinoPageRoute(
                    builder: (context) =>
                        MyHomePage(title: "vbn", initialTabIndex: 0))),
              });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(msg: errorMessage!);
      print(error.code);
    }
  }

  void signUp(String email, String password) async {
    // Implement your sign-up logic
    print("///firstname///"+firstNameEditingController.text+"  "+email+" "+password);
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(msg: errorMessage!);
      print(error.code);
    }
  }

  void postDetailsToFirestore() async {
    // Calling our firestore
    // Calling our user model
    // Sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // Writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondNameEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");
    Navigator.pushAndRemoveUntil(
        (context),
        CupertinoPageRoute(
            builder: (context) =>
                MyHomePage(title: "fghj", initialTabIndex: 0)),
        (route) => false);
  }
}
