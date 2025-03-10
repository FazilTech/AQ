import 'package:aq/dateTime/date_time_helper.dart';
import 'package:aq/models/expense_items.dart';

class ExpenseData{

  // list of all expenses
  List<ExpenseItem> overallExpenseList = [];

  // get the expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  // add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
  }

  // delete an expense
  void deleteExpense(ExpenseItem expense){
    overallExpenseList.remove(expense);
  }

  // get weekday from dateTime object
  String getDayName(DateTime dateTime){
    switch (dateTime.weekday){
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thr';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
      return '';
    }
  }

  // get the date for the start of the week
  DateTime startOfTheWeek(){
    DateTime? startOfWeek;

    // get Today Date
    DateTime today = DateTime.now();

    // go backwards from today to find sunday
    for(int i=0; i<7; i++){
      if(getDayName(today.subtract(Duration(days: i))) == 'Sun'){
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  /*
    convert overall list of expenses into daily expense summaryb
  */

  Map<String, double> calculateDailyExpenseSummary(){
    Map<String, double> dailyExpenseSummary = {
      // date {yyyymmdd} : amountTotalForDay
    };

    for(var expense in overallExpenseList){
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if(dailyExpenseSummary.containsKey(date)){
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      }else{
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    return dailyExpenseSummary;
  }
}