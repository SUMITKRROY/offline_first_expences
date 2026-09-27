

import '../models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<List<ExpenseModel>> getExpenses();

  Future<ExpenseModel> createExpense(
      ExpenseModel expense,
      );

  Future<ExpenseModel> updateExpense(
      ExpenseModel expense,
      );

  Future<void> deleteExpense(String id);
}