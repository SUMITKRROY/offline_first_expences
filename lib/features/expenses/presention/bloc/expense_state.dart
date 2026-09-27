import '../../domain/entities/expense.dart';

sealed class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;
  final bool isSyncing;

  ExpenseLoaded({
    required this.expenses,
    this.isSyncing = false,
  });
}

class ExpenseError extends ExpenseState {
  final String message;

  ExpenseError(this.message);
}