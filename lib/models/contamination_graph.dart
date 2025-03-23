import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ContaminationBarGraph extends StatelessWidget {
  final List<Map<String, dynamic>> dataPoints;

  const ContaminationBarGraph({Key? key, required this.dataPoints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure dataPoints is not empty
    if (dataPoints.isEmpty) {
      return const Center(
        child: Text("No data available for the graph"),
      );
    }

    // Extract time and contamination probability values
    List<BarChartGroupData> barGroups = dataPoints.map((point) {
      double time = point["time"].toDouble(); // Time in hours (e.g., 13.0 for 1 PM)
      double contamProb = double.parse(
        point["contam_prob_rf"].toString().replaceAll('%', ''),
      ); // Contamination probability

      return BarChartGroupData(
        x: time.toInt(), // X-axis: Time in hours
        barRods: [
          BarChartRodData(
            toY: contamProb, // Y-axis: Contamination probability
            color: Colors.red,
            width: 10, // Width of the bars
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      );
    }).toList();

    // Find the minimum and maximum time for scaling the x-axis
    double minTime = dataPoints.map((point) => point["time"].toDouble()).reduce((a, b) => a < b ? a : b);
    double maxTime = dataPoints.map((point) => point["time"].toDouble()).reduce((a, b) => a > b ? a : b);

    return Container(
      height: 200, // Adjust the height as needed
      padding: const EdgeInsets.all(10),
      child: BarChart(
        BarChartData(
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
                interval: 1, // Show labels for every hour
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
                interval: 10, // Show labels at intervals of 10%
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          barGroups: barGroups,
          alignment: BarChartAlignment.spaceAround, // Adjust bar spacing
          groupsSpace: 10, // Space between groups
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Colors.blueGrey, // Tooltip background color
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.toStringAsFixed(2)}%', // Display contamination probability in tooltip
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}