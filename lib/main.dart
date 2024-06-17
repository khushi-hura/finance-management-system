import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_manager/models/transaction.dart';
import 'package:finance_manager/providers/transaction_provider.dart';
import 'package:finance_manager/screens/home_screen.dart';
import 'package:finance_manager/screens/add_transaction_screen.dart';
import 'package:finance_manager/text_theme_override.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Finance Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        routes: {
          AddTransactionScreen.routeName: (ctx) => AddTransactionScreen(),
        },
      ),
    );
  }
}
