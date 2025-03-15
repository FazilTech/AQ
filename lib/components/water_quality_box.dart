import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaterQualityBox extends StatelessWidget {
  final String title;
  final String value;
  final String iconName;
  final String? previousValue;  // To compare with the previous value
  
  const WaterQualityBox({
    super.key,
    required this.title,
    required this.value,
    required this.iconName,
    this.previousValue,  // Optional parameter for previous value
  });

  @override
  Widget build(BuildContext context) {
    double currentValue = double.tryParse(value) ?? 0.0;
    double? prevValue = previousValue != null ? double.tryParse(previousValue!) : null;

    // Define ranges
    bool isPhValue = title == "PH Value";
    bool isTbValue = title == "Turbidity";
    bool isTpValue = title == "Temp";
    bool isD2Value = title == "Diss O2";

    // Range checks
    bool isInRange = false;
    Color valueColor = Colors.green;  // Default color if within range
    String arrow = "";

    if (isPhValue && currentValue >= 6.5 && currentValue <= 8.5) {
      isInRange = true;
    } else if (isTbValue && currentValue >= 0 && currentValue <= 5) {
      isInRange = true;
    } else if (isTpValue && currentValue >= 0 && currentValue <= 40) {
      isInRange = true;
    } else if (isD2Value && currentValue >= 5 && currentValue <= 14) {
      isInRange = true;
    }

    // If the value is out of range, set the color to red
    if (!isInRange) {
      valueColor = Colors.red;
    }

    // If previous value exists, compare the new value with the old one
    if (prevValue != null) {
      if (currentValue > prevValue) {
        arrow = "↑";  // Up arrow if the value increased
      } else if (currentValue < prevValue) {
        arrow = "↓";  // Down arrow if the value decreased
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(207, 207, 245, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.sora(
              fontSize: 17,
              color: Color.fromRGBO(0, 53, 102, 1),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
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
              Row(
                children: [
                  Text(
                    value,
                    style: GoogleFonts.sora(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: valueColor,
                    ),
                  ),
                  if (arrow.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        arrow,
                        style: TextStyle(
                          fontSize: 18,
                          color: valueColor,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
