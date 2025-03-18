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
    double hdValue = double.tryParse(waterQualityData["HdValue"] ?? "0.0") ?? 0.0;
    double soValue = double.tryParse(waterQualityData["SoValue"] ?? "0.0") ?? 0.0;
    double chValue = double.tryParse(waterQualityData["ChValue"] ?? "0.0") ?? 0.0;
    double suValue = double.tryParse(waterQualityData["SuValue"] ?? "0.0") ?? 0.0;
    double coValue = double.tryParse(waterQualityData["CoValue"] ?? "0.0") ?? 0.0;
    double ocValue = double.tryParse(waterQualityData["OcValue"] ?? "0.0") ?? 0.0;
    double trValue = double.tryParse(waterQualityData["TrValue"] ?? "0.0") ?? 0.0;

    // Determine if values are within range
    bool isPhInRange = phValue >= 6.5 && phValue <= 8.5;
    bool isTbInRange = tbValue >= 0 && tbValue <= 5;
    bool isHdInRange = hdValue < 120;
    bool isSoInRange = soValue < 500;
    bool isChInRange = chValue < 4;
    bool isSuInRange = suValue < 250;
    bool isCoInRange = coValue < 800;
    bool isOcInRange = ocValue < 2;
    bool isTrInRange = trValue < 80;

    String lastUpdatedTime = 'N/A';
    if (waterQualityData["dateTime"] != null) {
      lastUpdatedTime = DateFormat('HH:mm').format(
        (waterQualityData["dateTime"] as Timestamp).toDate(),
      );
    }

    // Check if all values are within range
    bool isWaterSafe = isPhInRange &&
        isTbInRange &&
        isHdInRange &&
        isSoInRange &&
        isChInRange &&
        isSuInRange &&
        isCoInRange &&
        isOcInRange &&
        isTrInRange;

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
                    isWaterSafe ? "Safe" : "Contaminated",
                    style: GoogleFonts.sora(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(0, 53, 102, 1),
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
          Column(
            children: [
              // Row for pH and Tb
              Row(
                children: [
                  _buildIndicator("Ph", isPhInRange),
                  _buildIndicator("Tb", isTbInRange),
                  _buildIndicator("Hd", isHdInRange),
                ],
              ),
              const SizedBox(height: 10),
              // Row for Hd and So
              Row(
                children: [
                  _buildIndicator("So", isSoInRange),
                  _buildIndicator("Ch", isChInRange),
                  _buildIndicator("Su", isSuInRange),
                ],
              ),
              const SizedBox(height: 10),
              // Row for Co and Oc
              Row(
                children: [
                  _buildIndicator("Co", isCoInRange),
                  _buildIndicator("Oc", isOcInRange),
                  _buildIndicator("Tr", isTrInRange),
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