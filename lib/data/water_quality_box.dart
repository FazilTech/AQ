import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaterQualityBox extends StatelessWidget {
  final String title;
  final String value;
  final String iconName;

  const WaterQualityBox({
    super.key,
    required this.title,
    required this.value,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    double currentValue = double.tryParse(value) ?? 0.0;

    // Debug statement to check the value and title
    print("Title: $title, Value: $currentValue");

    // Define range checks based on the parameter
    bool isInRange = false;
    Color valueColor = Colors.green;

    switch (title) {
      case "pH Value":
        isInRange = currentValue >= 6.5 && currentValue <= 8.5;
        print("pH Value: $currentValue, In Range: $isInRange"); // Debug statement
        break;
      case "Turbidity":
        isInRange = currentValue >= 0 && currentValue <= 5;
        break;
      case "Dissolved_Oxygen":
        isInRange = currentValue >= 7;
        break;
      case "Total_Dissolved_Solids":
        isInRange = currentValue >= 10 && currentValue <= 30;
        break;
      case "Chlorine_Level":
        isInRange = currentValue >= 0 && currentValue <= 4;
        break;
      case "Water_Temperature":
        isInRange = currentValue >= 10 && currentValue <= 30;
        break;
      default:
        isInRange = false;
    }

    // Set color based on range check
    valueColor = isInRange ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(207, 207, 245, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Title
          Text(
            title,
            style: GoogleFonts.sora(
              fontSize: 17,
              color: const Color.fromRGBO(0, 53, 102, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Icon and Value
          Row(
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(240, 255, 181, 0.9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  iconName,
                  style: GoogleFonts.sora(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Value
              Text(
                value,
                style: GoogleFonts.sora(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}