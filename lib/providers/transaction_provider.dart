import 'package:flutter/material.dart';
import 'package:finance_manager/models/transaction.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  TransactionProvider() {
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    _transactions = List.generate(maps.length, (i) {
      return Transaction(
        id: maps[i]['id'],
        title: maps[i]['title'],
        amount: maps[i]['amount'],
        date: DateTime.parse(maps[i]['date']),
        type: maps[i]['type'],
      );
    });
    notifyListeners();
  }

  Future<sqflite.Database> _getDatabase() async {
    return sqflite.openDatabase(
      join(await sqflite.getDatabasesPath(), 'transactions.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE transactions(id INTEGER PRIMARY KEY, title TEXT, amount REAL, date TEXT, type TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> addTransaction(String title, double amount, DateTime date, String type) async {
    final db = await _getDatabase();
    final id = await db.insert(
      'transactions',
      {
        'title': title,
        'amount': amount,
        'date': date.toIso8601String(),
        'type': type,
      },
      conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
    );
    _transactions.add(Transaction(id: id, title: title, amount: amount, date: date, type: type));
    notifyListeners();
  }

  Future<void> removeTransaction(int id) async {
    final db = await _getDatabase();
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
    _transactions.removeWhere((tx) => tx.id == id);
    notifyListeners();
  }
}
