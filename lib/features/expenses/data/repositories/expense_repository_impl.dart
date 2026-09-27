import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';
import '../datasources/expense_remote_datasource.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<Expense>> getExpenses() async {
    final expenses = await localDataSource.getExpenses();

    return expenses;
  }

  @override
  Future<Expense> addExpense(
      Expense expense,
      ) async {
    final localExpense = ExpenseModel.fromEntity(
      expense,
    ).copyWith(
      syncStatus: SyncStatus.pending,
    );

    // 1. Save locally first
    await localDataSource.insertExpense(
      localExpense,
    );

    // 2. Return immediately
    return localExpense;
  }

  @override
  Future<Expense> updateExpense(
      Expense expense,
      ) async {
    final localExpense = ExpenseModel.fromEntity(
      expense,
    ).copyWith(
      syncStatus: SyncStatus.pending,
      updatedAt: DateTime.now(),
    );

    await localDataSource.updateExpense(
      localExpense,
    );

    return localExpense;
  }

  @override
  Future<void> deleteExpense(
      String id,
      ) async {
    final existingExpenses =
    await localDataSource.getExpenses();

    final expense = existingExpenses.firstWhere(
          (expense) => expense.id == id,
    );

    final deletedExpense = expense.copyWith(
      isDeleted: true,
      syncStatus: SyncStatus.pending,
      updatedAt: DateTime.now(),
    );

    await localDataSource.updateExpense(
      deletedExpense,
    );
  }

  @override
  Future<void> syncExpenses() async {
    final pendingExpenses =
    await localDataSource.getPendingExpenses();

    for (final expense in pendingExpenses) {
      await _syncExpense(expense);
    }
  }

  Future<void> _syncExpense(
      ExpenseModel expense,
      ) async {
    if (expense.isDeleted) {
      await remoteDataSource.deleteExpense(
        expense.id,
      );
    } else {
      await remoteDataSource.createExpense(
        expense,
      );
    }

    final syncedExpense = expense.copyWith(
      syncStatus: SyncStatus.synced,
    );

    await localDataSource.updateExpense(
      syncedExpense,
    );
  }
}