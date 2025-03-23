import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeQualityAnalysis extends StatelessWidget {
  final String city;
  final String country;
  final Map<String, dynamic> userData;
  final Map<String, dynamic> waterQualityData;

  const HomeQualityAnalysis({
    super.key,
    required this.city,
    required this.country,
    required this.userData,
    required this.waterQualityData,
  });

  @override
  Widget build(BuildContext context) {
    // Extract values from waterQualityData
    double phValue = double.tryParse(waterQualityData["phValue"] ?? "0.0") ?? 0.0;
    double tbValue = double.tryParse(waterQualityData["tbValue"] ?? "0.0") ?? 0.0;
    double doValue = double.tryParse(waterQualityData["doValue"] ?? "0.0") ?? 0.0;
    double tdValue = double.tryParse(waterQualityData["tdValue"] ?? "0.0") ?? 0.0;
    double clValue = double.tryParse(waterQualityData["clValue"] ?? "0.0") ?? 0.0;
    double tpValue = double.tryParse(waterQualityData["tpValue"] ?? "0.0") ?? 0.0;

    // Determine if values are within range
    bool isPhInRange = phValue >= 6.5 && phValue <= 8.5;
    bool isTbInRange = tbValue >= 0 && tbValue <= 5;
    bool isDoInRange = doValue >= 7;
    bool isTdInRange = tdValue >= 10 && tdValue <= 30;
    bool isClInRange = clValue >= 0 && clValue <= 4;
    bool isTpInRange = tpValue >= 10 && tpValue <= 30;

    // Get the last updated time
    String lastUpdatedTime = 'N/A';
    if (waterQualityData["dateTime"] != null) {
      lastUpdatedTime = DateFormat('HH:mm').format(
        (waterQualityData["dateTime"] as Timestamp).toDate(),
      );
    }

    // Determine contamination status based on probability
    double contamProb = double.tryParse(waterQualityData["contam_prob_rf"]?.toString() ?? "0.0") ?? 0.0;
    bool isContaminated = contamProb >= 0.5; // If probability >= 50%, water is contaminated

    return Container(
      margin: const EdgeInsets.only(left: 15),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 9),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(162, 214, 249, 1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            spreadRadius: -1,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Column(
        children: [
          // Location Row
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(16, 0, 138, 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_pin,
                  size: 25,
                  color: Colors.white,
                ),
                Text(
                  '$city, $country',
                  style: GoogleFonts.sora(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // User Profile and Water Safety Status
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: userData['profileImageUrl'] != null
                    ? NetworkImage(userData['profileImageUrl'])
                    : const AssetImage('')
                        as ImageProvider,
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Text(
                    isContaminated ? "Contaminated" : "Safe",
                    style: GoogleFonts.sora(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isContaminated ? Colors.red : const Color.fromRGBO(0, 53, 102, 1),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Last Updated: $lastUpdatedTime',
                    style: GoogleFonts.sora(
                      fontSize: 12,
                      color: const Color.fromRGBO(0, 53, 102, 1),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 6),

          // Water Quality Indicators
          Column(
            children: [
              // Row for pH and Turbidity
              Row(
                children: [
                  _buildIndicator("pH", isPhInRange),
                  _buildIndicator("Tb", isTbInRange),
                  _buildIndicator("DO", isDoInRange),
                ],
              ),
              const SizedBox(height: 10),

              // Row for Total Dissolved Solids and Chlorine Level
              Row(
                children: [
                  _buildIndicator("TDS", isTdInRange),
                  _buildIndicator("Cl", isClInRange),
                  _buildIndicator("Temp", isTpInRange),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  // Helper method to build an indicator widget
  Widget _buildIndicator(String label, bool isInRange) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isInRange ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.sora(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}