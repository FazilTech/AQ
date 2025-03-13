import 'package:aq/bar%20graph/individual_bar.dart';

class BarData{
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thrAmount;
  final double friAmount;
  final double satAmount;

  BarData({
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thrAmount,
    required this.friAmount,
    required this.satAmount
  });

  List<IndividualBar> barData = [];

  // initialize bar data
  void initializeBarData(){
    barData = [
      // sun
      IndividualBar(x: 0, y: sunAmount),
      // Mon
      IndividualBar(x: 1, y: monAmount),
      // Tue
      IndividualBar(x: 2, y: tueAmount),
      // Wed
      IndividualBar(x: 3, y: wedAmount),
      // Thr
      IndividualBar(x: 4, y: thrAmount),
      // Fri
      IndividualBar(x: 5, y: friAmount),
      // Sat
      IndividualBar(x: 6, y: satAmount),
    ];
  }

}