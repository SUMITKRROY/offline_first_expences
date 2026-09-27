import 'dart:convert';


import '../../features/expenses/data/datasources/expense_remote_datasource.dart';
import '../../features/expenses/data/models/expense_model.dart';
import '../connectivity/connectivity_service.dart';
import 'sync_queue_datasource.dart';
import 'sync_queue_item.dart';

class SyncWorker {
  final SyncQueueDataSource queueDataSource;
  final ExpenseRemoteDataSource remoteDataSource;
  final ConnectivityService connectivityService;

  bool _isSyncing = false;

  SyncWorker({
    required this.queueDataSource,
    required this.remoteDataSource,
    required this.connectivityService,
  });

  Future<void> processQueue() async {
    if (_isSyncing) {
      return;
    }

    final connected =
    await connectivityService.isConnected();

    if (!connected) {
      return;
    }

    _isSyncing = true;

    try {
      final operations =
      await queueDataSource.getPendingOperations();

      for (final operation in operations) {
        await _processOperation(operation);
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _processOperation(
      SyncQueueItem item,
      ) async {
    try {
      final payload =
      jsonDecode(item.payload) as Map<String, dynamic>;

      final expense =
      ExpenseModel.fromJson(payload);

      switch (item.operation) {
        case SyncOperation.create:
          await remoteDataSource.createExpense(
            expense,
          );
          break;

        case SyncOperation.update:
          await remoteDataSource.updateExpense(
            expense,
          );
          break;

        case SyncOperation.delete:
          await remoteDataSource.deleteExpense(
            item.entityId,
          );
          break;
      }

      // API succeeded.
      await queueDataSource.deleteOperation(
        item.id,
      );
    } catch (e) {
      await queueDataSource.incrementRetryCount(
        item.id,
      );

      // Keep the operation in the queue.
      // It will be retried later.
    }
  }
}