import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_manager/providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  static const routeName = '/add-transaction';

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _date;
  String _type = 'expense';

  void _submitForm() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount == null || _date == null) {
      return;
    }

    Provider.of<TransactionProvider>(context, listen: false).addTransaction(
      enteredTitle,
      enteredAmount,
      _date!,
      _type,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: _titleController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _date == null ? 'No Date Chosen!' : 'Picked Date: ${_date!.toLocal()}',
                  ),
                ),
                TextButton(
                  child: Text('Choose Date'),
                  onPressed: _presentDatePicker,
                ),
              ],
            ),
            DropdownButton<String>(
              value: _type,
              items: [
                DropdownMenuItem(
                  child: Text('Expense'),
                  value: 'expense',
                ),
                DropdownMenuItem(
                  child: Text('Income'),
                  value: 'income',
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _type = value.toString();
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Add Transaction'),
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
    );
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _date = pickedDate;
      });
    });
  }
}
