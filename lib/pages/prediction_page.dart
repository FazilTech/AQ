import 'package:aq/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  List<String> allSymptoms = [
    "itching", "skin_rash", "fatigue", "vomiting", "fever",
    "headache", "joint_pain", "diarrhoea", "weight_loss", "nausea", "cough", "sore_throat"
  ];

  List<String> selectedSymptoms = [];
  String predictionResult = "";

  void toggleSelection(String symptom) {
    setState(() {
      if (selectedSymptoms.contains(symptom)) {
        selectedSymptoms.remove(symptom);
      } else {
        selectedSymptoms.add(symptom);
      }
    });
  }

  Future<void> predictDisease() async {
    if (selectedSymptoms.length < 3) {
      setState(() {
        predictionResult = "Please select at least 3 symptoms.";
      });
      return;
    }

    final url = Uri.parse('http://192.168.55.132:5555/predict');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"symptoms": selectedSymptoms}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        predictionResult = responseData["message"] != null
            ? "${responseData["predicted_disease"]}\n\n${responseData["message"]}"
            : responseData["predicted_disease"];
      });
    } else {
      setState(() {
        predictionResult = "Error: Unable to fetch prediction.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
            "Disease Prediction",
            style: GoogleFonts.sora(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20
            ),
            )
        ),
      
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select your Symptoms:", 
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: Colors.blue
                )
              ),
            
            const SizedBox(height: 20),
            
            Wrap(
              spacing: 10,
              children: allSymptoms.map((symptom) {
                bool isSelected = selectedSymptoms.contains(symptom);
                return Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: MyButton(
                    color: isSelected ? Colors.black :const Color.fromRGBO(0, 53, 102, 1) , 
                    onTap: () => toggleSelection(symptom), 
                    text: symptom,
                    ),
                );
              }).toList(),
            ),

            

            const SizedBox(height: 30),
            
            Center(
              child: GestureDetector(
                onTap: predictDisease,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: const Text(
                    "Predict Disease",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
            
            Center(
              child: Column(
                children: [
                const Text(
                  "Prediction",
                  style: TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold,
                    color: Colors.blue
                    ),
                  ),
              
                  Text(
                    "$predictionResult",
                    style: const TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: Colors.green
                      ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}