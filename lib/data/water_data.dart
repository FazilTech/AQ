import 'package:aq/dateTime/date_time_helper.dart';
import 'package:aq/models/water_quality_items.dart';
import 'package:flutter/material.dart';

class WaterData extends ChangeNotifier {

  // List of all water quality readings
  List<WaterQualityItems> overallWaterQualityList = [];

  // Get the water quality list
  List<WaterQualityItems> getAllWaterQualityList() {
    return overallWaterQualityList;
  }

  // Add new water quality data
  void addNewWaterQuality(WaterQualityItems newWaterQuality) {
    overallWaterQualityList.add(newWaterQuality);
    notifyListeners();
  }

  // Delete a water quality entry
  void deleteWaterQuality(WaterQualityItems waterQuality) {
    overallWaterQualityList.remove(waterQuality);
    notifyListeners();
  }

  // Get current time
  String getCurrentTime() {
    DateTime now = DateTime.now();
    return "${now.hour}:${now.minute}:${now.second}";
  }

  // Get the date for the start of the week
  DateTime startOfTheWeek() {
    DateTime? startOfWeek;
    DateTime today = DateTime.now();

    // Go backwards from today to find Sunday
    for (int i = 0; i < 7; i++) {
      if (today.subtract(Duration(days: i)).weekday == DateTime.sunday) {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  /*
    Convert overall list of water quality readings into daily summary
  */

  Map<String, Map<String, double>> calculateDailyWaterQualitySummary() {
    Map<String, Map<String, double>> dailySummary = {};

    for (var reading in overallWaterQualityList) {
      String date = convertDateTimeToString(reading.dateTime);

      if (!dailySummary.containsKey(date)) {
        dailySummary[date] = {
          "pH": 0.0,
          "Turbidity": 0.0,
          "Total Phosphorus": 0.0,
          "Dissolved Oxygen": 0.0
        };
      }

      dailySummary[date]!["pH"] = double.parse(reading.phValue);
      dailySummary[date]!["Turbidity"] = double.parse(reading.tbValue);
      dailySummary[date]!["Total Phosphorus"] = double.parse(reading.tpValue);
      dailySummary[date]!["Dissolved Oxygen"] = double.parse(reading.d2Value);
    }

    return dailySummary;
  }
}
