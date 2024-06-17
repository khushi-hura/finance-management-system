class Transaction {
  final int id;
  final String title;
  final double amount;
  final DateTime date;
  final String type; // 'income' or 'expense'

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
  });
}
