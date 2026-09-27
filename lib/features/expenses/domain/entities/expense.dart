

enum SyncStatus{
  synced,
  pending,
  failed,
}

class Expense {
  final String id;
  final String userId;
  final double amount;
  final String categoryId;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final int version;
  final bool isDeleted;

  const Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.categoryId,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.version, required this.isDeleted,
  });
}