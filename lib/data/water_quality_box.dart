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

    // Define ranges
    bool isPhValue = title == "PH Value";
    bool isTbValue = title == "Turbidity";
    bool isTpValue = title == "Temp";
    bool isD2Value = title == "Diss O2";

    // Range checks
    bool isInRange = false;
    Color valueColor = Colors.green; 


    if (isPhValue && currentValue >= 6.5 && currentValue <= 8.5) {
      isInRange = true;
    } else if (isTbValue && currentValue >= 0 && currentValue <= 5) {
      isInRange = true;
    } else if (isTpValue && currentValue >= 0 && currentValue <= 40) {
      isInRange = true;
    } else if (isD2Value && currentValue >= 5 && currentValue <= 14) {
      isInRange = true;
    }
    
    if (!isInRange) {
      valueColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
              color: const Color.fromRGBO(0, 53, 102, 1),
              fontWeight: FontWeight.bold
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: valueColor,
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
