import 'package:aq/components/icon_container.dart';
import 'package:aq/components/input_box.dart';
import 'package:aq/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeePage extends StatelessWidget {
  const HomeePage({super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController searchController = TextEditingController();

    List<String> weekDays = ["Sun", "Mon", "Tue", "Wed", "Thr", "Fri", "Sat"];

    DateTime today = DateTime.now();
    int todayIndex = today.weekday % 7;

    List<Map<String, String>> weekDates = List.generate(7, (index){
      DateTime date = today.subtract(Duration(days: todayIndex - index));
      return{
        "day": weekDays[index],
        "date": DateFormat('dd').format(date),
        "isToday": date.day == today.day ? "true" : "false"
      };
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(240, 240, 245, 1),
        body: Column(
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello James,",
                        style: GoogleFonts.sora(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Wanna see today’s progress?",
                        style: GoogleFonts.sora(fontSize: 15),
                      )
                    ],
                  ),
                  const Spacer(),
                  IconContainer(
                    onTap: () {},
                    icon: const Icon(Icons.notifications),
                  ),
                  const SizedBox(width: 10),
                  IconContainer(
                    onTap: () {},
                    icon: const Icon(Icons.person_3),
                  ),
                ],
              ),
            ),

            Row(
                children: [
                  Expanded(
                    child:Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), 
                            blurRadius: 6, 
                            spreadRadius: -20, 
                            offset: const Offset(0, 6),
                          )
                        ]
                      ),
                      child: InputBoxDecoration(
                              hintText: "Search...",
                              obscureText: false,
                              controller: searchController,
                              icon: const Icon(Icons.search),
                              radius: 20,
                            ),
                    ),
                        ),
                    IconContainer(
                      onTap: () {},
                      icon: const Icon(Icons.calendar_month),
                    ),

                    const SizedBox(width: 10,)
                ],
              ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: weekDates.map((dayData) {
                  bool isToday = dayData["isToday"] == "true";

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: isToday ? const Color.fromRGBO(162, 214, 249, 1) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            dayData["day"]!,
                            style: GoogleFonts.sora(
                              color: const Color.fromRGBO(0, 53, 102, 1),
                              fontSize: 13
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            dayData["date"]!,
                            style: GoogleFonts.sora(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(162, 214, 249, 1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), 
                            blurRadius: 3, 
                            spreadRadius: 1, 
                            offset: const Offset(0, 6),
                          )
                        ]
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(16, 0, 138, 0.1),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_pin,
                              size: 35,
                              color: Colors.white,
                            ),

                            Text(
                              "Chennai, TamilNadu",
                              
                              style: GoogleFonts.sora(
                                fontSize: 12,
                                fontWeight:FontWeight.bold
                              ),
                            )
                          ],
                        )
                      ),

                      const SizedBox(height: 15,),

                      Row(
                        children: [
                          IconContainer(
                            onTap: (){},
                            icon: const Icon(Icons.person_3)
                          ),

                          const SizedBox(width: 20,),
                          
                          Column(
                            children: [
                              
                              Text(
                                "Contaminated",
                                style: GoogleFonts.sora(
                                fontSize: 15,
                                fontWeight:FontWeight.bold,
                                color: const Color.fromRGBO(0, 53, 102, 1),
                              ),
                              ),
                              
                              const SizedBox(height: 5,),
                              
                              Text(
                                "Last Updated 2:33",
                                style: GoogleFonts.sora(
                                  fontSize: 12,
                                  color: const Color.fromRGBO(0, 53, 102, 1),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      const SizedBox(height: 10,),

                      Column(
                        children: [
                          Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 55),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(100)
                              ),
                            ),
                          ),

                          const SizedBox(width: 10,),
                          
                          Text(
                            "Tb | Tp | D2",
                            style: GoogleFonts.sora(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                          )
                        ],
                      ),

                      const SizedBox(height: 7,),

                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(100)
                            ),
                          ),

                          const SizedBox(width: 10,),
                          
                          Text(
                            "Ph",
                            style: GoogleFonts.sora(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                          )
                        ],
                      ),
                        ],
                      )

                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(240, 255, 181, 1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), 
                            blurRadius: 3, 
                            spreadRadius: 1, 
                            offset: const Offset(0, 6),
                          )
                        ]
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Explore",
                        style: GoogleFonts.sora(
                          fontSize: 20,
                          color: Color.fromRGBO(0, 53, 102, 1),
                          fontWeight: FontWeight.bold
                        ),
                      ),

                      Text(
                        "Expore policies \n and \n Organization",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sora(
                          fontSize: 15
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: MyButton(
                          color: const Color.fromRGBO(0, 53, 102, 1),
                          onTap: (){}, 
                          text: "Click"
                          ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}