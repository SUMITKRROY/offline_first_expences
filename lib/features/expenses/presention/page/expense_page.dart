import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({
    super.key,
  });

  @override
  State<ExpensePage> createState() =>
      _ExpensePageState();
}

class _ExpensePageState
    extends State<ExpensePage> {

  @override
  void initState() {
    super.initState();

    context.read<ExpenseBloc>().add(
      LoadExpenses(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ExpenseError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is ExpenseLoaded) {
            if (state.expenses.isEmpty) {
              return const Center(
                child: Text(
                  'No expenses found',
                ),
              );
            }

            return ListView.builder(
              itemCount: state.expenses.length,
              itemBuilder: (context, index) {
                final expense =
                state.expenses[index];

                return ListTile(
                  title: Text(
                    expense.description,
                  ),
                  subtitle: Text(
                    expense.categoryId,
                  ),
                  trailing: Text(
                    '₹${expense.amount}',
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add expense
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}