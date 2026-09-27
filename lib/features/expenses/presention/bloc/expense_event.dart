import '../../domain/entities/expense.dart';

sealed class ExpenseEvent {}

class LoadExpenses extends ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  final Expense expense;

  AddExpense(this.expense);
}

class UpdateExpense extends ExpenseEvent {
  final Expense expense;

  UpdateExpense(this.expense);
}

class DeleteExpense extends ExpenseEvent {
  final String expenseId;

  DeleteExpense(this.expenseId);
}

class SyncExpenses extends ExpenseEvent {}

class RetrySync extends ExpenseEvent {}