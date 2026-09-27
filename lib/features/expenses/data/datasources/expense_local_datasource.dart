



import '../models/expense_model.dart';

abstract class ExpenseLocalDataSource {
  Future<List<ExpenseModel>> getExpenses();

  Future<void> insertExpense(ExpenseModel expense);

  Future<void> updateExpense(ExpenseModel expense);

  Future<void> deleteExpense(String id);

  Future<List<ExpenseModel>> getPendingExpenses();
}