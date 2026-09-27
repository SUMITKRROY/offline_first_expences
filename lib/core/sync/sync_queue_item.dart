enum SyncOperation {
  create,
  update,
  delete,
}

class SyncQueueItem {
  final int id;
  final String entityId;
  final SyncOperation operation;
  final String payload;
  final DateTime createdAt;
  final int retryCount;

  const SyncQueueItem({
    required this.id,
    required this.entityId,
    required this.operation,
    required this.payload,
    required this.createdAt,
    required this.retryCount,
  });
}