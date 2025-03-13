import 'package:aq/components/expense_summary.dart';
import 'package:aq/components/expense_tile.dart';
import 'package:aq/data/expense_data.dart';
import 'package:aq/models/expense_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //text controller 
  final newExpenseNameController = TextEditingController();
  final newExpenseDollerController = TextEditingController();
  final newExpenseCentController = TextEditingController();

  // add new expense
  void addNewExpense(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text(
          "Add new Expenses"
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //expense name
            TextField(
              controller: newExpenseNameController,
              decoration: InputDecoration(
                      hintText: "Expense Name"
                    ),
            ),

            // expense amount
            Row(
              children: [
                // dollars
                Expanded(
                  child: TextField(
                    controller: newExpenseDollerController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Dollars"
                    ),
                  ),
                ),

                // cents
                Expanded(
                  child: TextField(
                    controller: newExpenseCentController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Cents"
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: save,
            child: const Text("Save"),
            ),

          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text("Cancel"),
            ),
        ],
      ),
      );
  }

  void save(){
    // put dollers and cents togeather
    String amount = '${newExpenseDollerController.text}.${newExpenseCentController.text}';

    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text, 
      amount: amount, 
      dateTime: DateTime.now()
      );
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);

    Navigator.pop(context);
    clear();
  }

  void cancel(){
    Navigator.pop(context);
  }

  void clear(){
    newExpenseNameController.clear();
    newExpenseDollerController.clear();
    newExpenseCentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            // weeky summary
            ExpenseSummary(
              startOfWeek: value.startOfTheWeek()
              ),

            const SizedBox(height: 20,),

            // expense list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getAllExpenseList().length,
              itemBuilder: (context, index) => ExpenseTile(
                name: value.getAllExpenseList()[index].name, 
                amount: value.getAllExpenseList()[index].amount, 
                dateTime: value.getAllExpenseList()[index].dateTime
                )
              ),
          ],
        )
        ),
      );
  }
}