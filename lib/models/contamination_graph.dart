import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ContaminationGraph extends StatelessWidget {
  final List<Map<String, dynamic>> dataPoints;

  const ContaminationGraph({Key? key, required this.dataPoints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure dataPoints is not empty
    if (dataPoints.isEmpty) {
      return const Center(
        child: Text("No data available for the graph"),
      );
    }

    // Extract time and contamination probability values
    List<FlSpot> spots = dataPoints.map((point) {
      double time = point["time"].toDouble(); // Time in hours (e.g., 13.0 for 1 PM)
      double contamProb = double.parse(
        point["contam_prob_rf"].toString().replaceAll('%', ''),
      ); // Contamination probability
      return FlSpot(time, contamProb);
    }).toList();

    // Find the minimum and maximum time for scaling the x-axis
    double minTime = spots.map((spot) => spot.x).reduce((a, b) => a < b ? a : b);
    double maxTime = spots.map((spot) => spot.x).reduce((a, b) => a > b ? a : b);

    // Find the maximum contamination probability for scaling the y-axis
    double maxContamProb = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

    return Container(
      height: 200, // Adjust the height as needed
      padding: const EdgeInsets.all(10),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  // Display the hour as the x-axis label
                  return Text(
                    '${value.toInt()}h',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  // Display the contamination probability as the y-axis label
                  return Text(
                    '${value.toInt()}%',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          minX: minTime,
          maxX: maxTime,
          minY: 0,
          maxY: maxContamProb + 1, // Add some padding to the y-axis
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.red,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.red.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }
}