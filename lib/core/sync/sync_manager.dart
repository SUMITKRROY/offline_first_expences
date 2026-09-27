
import '../../features/expenses/domain/repositories/expense_repository.dart';
import '../connectivity/connectivity_service.dart';


class SyncManager {
  final ConnectivityService connectivityService;
  final ExpenseRepository expenseRepository;

  SyncManager({
    required this.connectivityService,
    required this.expenseRepository,
  });

  Future<void> start() async {
    final connected =
    await connectivityService.isConnected();

    if (connected) {
      await sync();
    }

    connectivityService.connectionStream.listen(
          (connected) async {
        if (connected) {
          await sync();
        }
      },
    );
  }

  Future<void> sync() async {
    try {
      await expenseRepository.syncExpenses();
    } catch (e) {
      // Log the error.
      // Don't crash the application.
    }
  }
}