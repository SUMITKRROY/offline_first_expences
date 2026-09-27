import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../models/expense_model.dart';
import 'expense_local_datasource.dart';

class ExpenseLocalDataSourceImpl
    implements ExpenseLocalDataSource {
  final AppDatabase database;

  ExpenseLocalDataSourceImpl({
    required this.database,
  });

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final db = await database.database;

    final result = await db.query(
      AppDatabase.expenseTable,
      where: 'isDeleted = ?',
      whereArgs: [0],
      orderBy: 'createdAt DESC',
    );

    return result
        .map(
          (json) => ExpenseModel.fromJson(json),
    )
        .toList();
  }

  @override
  Future<void> insertExpense(
      ExpenseModel expense,
      ) async {
    final db = await database.database;

    await db.insert(
      AppDatabase.expenseTable,
      expense.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateExpense(
      ExpenseModel expense,
      ) async {
    final db = await database.database;

    await db.update(
      AppDatabase.expenseTable,
      expense.toJson(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  @override
  Future<void> deleteExpense(
      String id,
      ) async {
    final db = await database.database;

    await db.delete(
      AppDatabase.expenseTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<ExpenseModel>> getPendingExpenses() async {
    final db = await database.database;

    final result = await db.query(
      AppDatabase.expenseTable,
      where: 'syncStatus = ?',
      whereArgs: ['pending'],
      orderBy: 'createdAt ASC',
    );

    return result
        .map(
          (json) => ExpenseModel.fromJson(json),
    )
        .toList();
  }
}