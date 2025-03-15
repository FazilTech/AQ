import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WaterQualityTile extends StatelessWidget {
  final double phValue;
  final double tbValue; // Turbidity (NTU)
  final double tpValue; // Temperature (°C)
  final double d2Value; // Dissolved Oxygen (mg/L)
  final DateTime dateTime;

  const WaterQualityTile({
    required this.phValue,
    required this.tbValue,
    required this.tpValue,
    required this.d2Value,
    required this.dateTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDataRow("pH Value", phValue),
            _buildDataRow("Turbidity (NTU)", tbValue),
            _buildDataRow("Temperature (°C)", tpValue),
            _buildDataRow("Dissolved Oxygen (mg/L)", d2Value),
            const Divider(),
            Text(
              "Date: ${DateFormat('yyyy-MM-dd').format(dateTime)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),            
          ],
        ),
      ),
    );
  }

  /// ✅ Fixed: Accepts `double` and converts to `String` inside the function
  Widget _buildDataRow(String title, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value.toStringAsFixed(2)), // ✅ Convert to string here
        ],
      ),
    );
  }
}
