import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_manager/providers/transaction_provider.dart';
import 'package:finance_manager/models/transaction.dart';
import 'package:finance_manager/screens/add_transaction_screen.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:finance_manager/text_theme_override.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<TransactionProvider>(context).transactions;
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Manager'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (ctx, i) {
                return ListTile(
                  title: Text(transactions[i].title),
                  subtitle: Text('\$${transactions[i].amount.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      Provider.of<TransactionProvider>(context, listen: false).removeTransaction(transactions[i].id);
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 200,
            child: charts.TimeSeriesChart(
              _createChartData(transactions),
              animate: true,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AddTransactionScreen.routeName);
        },
      ),
    );
  }

  List<charts.Series<Transaction, DateTime>> _createChartData(List<Transaction> transactions) {
    return [
      charts.Series<Transaction, DateTime>(
        id: 'Expenses',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Transaction tx, _) => tx.date,
        measureFn: (Transaction tx, _) => tx.amount,
        data: transactions.where((tx) => tx.type == 'expense').toList(),
      ),
      charts.Series<Transaction, DateTime>(
        id: 'Income',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (Transaction tx, _) => tx.date,
        measureFn: (Transaction tx, _) => tx.amount,
        data: transactions.where((tx) => tx.type == 'income').toList(),
      ),
    ];
  }
}
