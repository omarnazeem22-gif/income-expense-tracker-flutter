import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/transactionProvider.dart';
import './screens/addScreen.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});
  @override
  ExpenseTrackerState createState() => ExpenseTrackerState();
}

class ExpenseTrackerState extends State<ExpenseTracker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          "Income/Expense Tracker",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: Consumer<TransactionProvider>(
                builder: (context, provider, child) {
                  final transactions = provider.transactions;
                  if (transactions.isEmpty) {
                    return const Center(
                      child: Text(
                        "No transactions yet",
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      return Card(
                        color: const Color(0xFF1E1E1E),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: Icon(
                            tx.isIncome
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: tx.isIncome
                                ? Colors.greenAccent
                                : Colors.redAccent,
                          ),
                          title: Text(
                            tx.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            tx.date.toString(),
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                          trailing: Text(
                            "${tx.isIncome ? '+' : '-'}\$${tx.amount.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: tx.isIncome
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Consumer<TransactionProvider>(
            builder: (context, provider, child) {
              final income = provider.transactions
                  .where((tx) => tx.isIncome)
                  .fold(0.0, (sum, tx) => sum + tx.amount);

              final expenses = provider.transactions
                  .where((tx) => !tx.isIncome)
                  .fold(0.0, (sum, tx) => sum + tx.amount);

              final balance = income - expenses;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  border: Border(top: BorderSide(color: Colors.grey)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem("Income", income, Colors.greenAccent),
                    _buildSummaryItem("Expenses", expenses, Colors.redAccent),
                    _buildSummaryItem(
                      "Balance",
                      balance,
                      balance < 0 ? Colors.redAccent : Colors.tealAccent,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.tealAccent,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: const Color(0xFF1E1E1E),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: AddTransactionSheet(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "\$${amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
