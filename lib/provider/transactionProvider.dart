import 'package:app2/Model/transactions.dart';
import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  final List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  double get total => _transactions.fold(
    0,
    (sum, tx) => tx.isIncome ? sum + tx.amount : sum - tx.amount,
  );

  void addTransaction(Transaction tx) {
    _transactions.add(tx);
    notifyListeners();
  }
}
