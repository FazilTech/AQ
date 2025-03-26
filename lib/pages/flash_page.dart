import 'package:aq/pages/flashp_page.dart';
import 'package:aq/pages/prediction_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlashPage extends StatefulWidget {
  const FlashPage({super.key});

  @override
  State<FlashPage> createState() => _FlashPageState();
}

class _FlashPageState extends State<FlashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(  
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(18, 11, 94, 1),
                Color.fromRGBO(23, 23, 23, 1)
              ]
              )
          ),
          child: Column(
            children: [
              
              Padding(
                padding: const EdgeInsets.only(top: 110),
                child: Text(
                  "Let me work on all your \nQuestions",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sora(
                    fontSize: 15,
                    color: Colors.white
                  )
                ),
              ),

               Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "What can i do for \nyou today?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sora(
                    fontSize: 20,
                    color: Colors.white
                  )
                ),
              ),

              const SizedBox(height: 50,),

              Image.asset(
                "assets/images/flask_page.gif",
                height: 250,
              ),

              const SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.dashboard_sharp,
                    color: Colors.white,
                    size: 20,
                  ),

                  const SizedBox(width: 10,),

                  Text(
                    "Use Keyboard",
                    style: GoogleFonts.sora(
                      color: Colors.white,
                      fontSize: 18
                    ),
                  )
                ],
              ),

              const SizedBox(height: 60,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FlashpPage(),)),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 40,),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Icon(
                      Icons.mic,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 40,),
                  GestureDetector(
                    onTap:() => Navigator.push(context, MaterialPageRoute(builder: (context) => const PredictionPage(),)),
                    child: Icon(
                      Icons.search_sharp,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}