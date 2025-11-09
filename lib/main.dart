import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/transactionProvider.dart';
import './state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TransactionProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        primaryColor: Colors.tealAccent,
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'SF Pro Display',
        ),
      ),
      home: const ExpenseTracker(),
    );
  }
}
