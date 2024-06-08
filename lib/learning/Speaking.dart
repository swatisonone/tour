import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tour/learning/speakinglearning.dart';

class Speaking extends StatefulWidget {
  late ColorScheme dync;
  Speaking({required this.dync, super.key});

  @override
  State<Speaking> createState() => _SpeakingState();
}

class _SpeakingState extends State<Speaking> {
  List<String> speakingcatg = [];


  @override
  void initState() {
    super.initState();
    fetchSpeakingCategories();
  }

  void fetchSpeakingCategories() async {
    // Replace the following code with fetching data from Firestore or another backend
    // For now, adding dummy data for demonstration purposes
    speakingcatg = ['Category 1', 'Category 2', 'Category 3'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dync.primaryContainer,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipPath(
            clipper: TopheadCLipper(),
            child: Container(
              child: Center(
                child: Text(
                  "Speaking",
                  style: TextStyle(
                      color: widget.dync.primaryContainer,
                      fontSize: 34,
                      fontWeight: FontWeight.bold),
                ),
              ),
              color: widget.dync.primary,
              height: MediaQuery.of(context).size.height / 3.5,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            child: ListView.builder(
                itemCount: speakingcatg.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // !(index <= 1)
                      //     ? {}
                      //     : Navigator.of(context)
                      //         .pushReplacement(MaterialPageRoute(
                      //             builder: (context) => SpeakingLearning(
                      //                   cat: speakingcatg[index],
                      //                   dync: widget.dync,
                      //                 )));
                    },
                    // child: (index <= prog.progress_get()[2])
                    //     ? Container(
                    //         margin: EdgeInsets.all(10),
                    //         decoration: BoxDecoration(
                    //             color: widget.dync.primary,
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(10))),
                    //         width: double.infinity,
                    //         height: MediaQuery.of(context).size.height / 10,
                    //         child: Center(
                    //           child: Text(
                    //             speakingcatg[index],
                    //             style: TextStyle(
                    //                 color: widget.dync.secondaryContainer,
                    //                 fontSize: 20,
                    //                 fontWeight: FontWeight.bold),
                    //           ),
                    //         ))
                        // : Stack(
                        //     children: [
                        //       Container(
                        //           margin: EdgeInsets.all(10),
                        //           decoration: BoxDecoration(
                        //               color: widget.dync.primary,
                        //               borderRadius: BorderRadius.all(
                        //                   Radius.circular(10))),
                        //           width: double.infinity,
                        //           height:
                        //               MediaQuery.of(context).size.height / 10,
                        //           child: Center(
                        //             child: Text(
                        //               speakingcatg[index],
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.bold,
                        //                   color: widget.dync.primaryContainer,
                        //                   fontSize: 18),
                        //             ),
                        //           )),
                        //       Opacity(
                        //         opacity: 0.8,
                        //         child: Container(
                        //             margin: EdgeInsets.all(10),
                        //             decoration: BoxDecoration(
                        //                 color: widget.dync.primary,
                        //                 borderRadius: BorderRadius.all(
                        //                     Radius.circular(10))),
                        //             width: double.infinity,
                        //             height:
                        //                 MediaQuery.of(context).size.height / 10,
                        //             child: Center(child: Icon(Icons.lock))),
                        //       ),
                        //     ],
                        //   ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class TopheadCLipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height - 40);

    path.quadraticBezierTo(
        size.width / 4, size.height - 80, size.width / 2, size.height - 40);

    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 40);

    path.lineTo(size.width, 0.0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true; //if new instance have different instance than old instance
    //then you must return true;
  }
}
