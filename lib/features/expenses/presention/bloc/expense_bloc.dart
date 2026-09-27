import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc
    extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository repository;

  ExpenseBloc({
    required this.repository,
  }) : super(ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpense>(_onAddExpense);
    on<UpdateExpense>(_onUpdateExpense);
    on<DeleteExpense>(_onDeleteExpense);
    on<SyncExpenses>(_onSyncExpenses);
    on<RetrySync>(_onRetrySync);
  }

  Future<void> _onLoadExpenses(
      LoadExpenses event,
      Emitter<ExpenseState> emit,
      ) async {
    emit(ExpenseLoading());

    try {
      final expenses =
      await repository.getExpenses();

      emit(
        ExpenseLoaded(
          expenses: expenses,
        ),
      );
    } catch (e) {
      emit(
        ExpenseError(
          'Failed to load expenses',
        ),
      );
    }
  }

  Future<void> _onAddExpense(
      AddExpense event,
      Emitter<ExpenseState> emit,
      ) async {
    try {
      await repository.addExpense(
        event.expense,
      );

      final expenses =
      await repository.getExpenses();

      emit(
        ExpenseLoaded(
          expenses: expenses,
        ),
      );
    } catch (e) {
      emit(
        ExpenseError(
          'Failed to add expense',
        ),
      );
    }
  }

  Future<void> _onUpdateExpense(
      UpdateExpense event,
      Emitter<ExpenseState> emit,
      ) async {
    try {
      await repository.updateExpense(
        event.expense,
      );

      final expenses =
      await repository.getExpenses();

      emit(
        ExpenseLoaded(
          expenses: expenses,
        ),
      );
    } catch (e) {
      emit(
        ExpenseError(
          'Failed to update expense',
        ),
      );
    }
  }

  Future<void> _onDeleteExpense(
      DeleteExpense event,
      Emitter<ExpenseState> emit,
      ) async {
    try {
      await repository.deleteExpense(
        event.expenseId,
      );

      final expenses =
      await repository.getExpenses();

      emit(
        ExpenseLoaded(
          expenses: expenses,
        ),
      );
    } catch (e) {
      emit(
        ExpenseError(
          'Failed to delete expense',
        ),
      );
    }
  }

  Future<void> _onSyncExpenses(
      SyncExpenses event,
      Emitter<ExpenseState> emit,
      ) async {
    final currentState = state;

    try {
      if (currentState is ExpenseLoaded) {
        emit(
          ExpenseLoaded(
            expenses: currentState.expenses,
            isSyncing: true,
          ),
        );
      }

      await repository.syncExpenses();

      final expenses =
      await repository.getExpenses();

      emit(
        ExpenseLoaded(
          expenses: expenses,
          isSyncing: false,
        ),
      );
    } catch (e) {
      if (currentState is ExpenseLoaded) {
        emit(
          ExpenseLoaded(
            expenses: currentState.expenses,
            isSyncing: false,
          ),
        );
      }
    }
  }

  Future<void> _onRetrySync(
      RetrySync event,
      Emitter<ExpenseState> emit,
      ) async {
    add(SyncExpenses());
  }
}