import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import 'sync_queue_item.dart';

class SyncQueueDataSource {
  final AppDatabase database;

  SyncQueueDataSource({
    required this.database,
  });

  Future<void> addOperation({
    required String entityId,
    required SyncOperation operation,
    required Map<String, dynamic> payload,
  }) async {
    final db = await database.database;

    await db.insert(
      'sync_queue',
      {
        'entityId': entityId,
        'operation': operation.name,
        'payload': jsonEncode(payload),
        'createdAt': DateTime.now().toIso8601String(),
        'retryCount': 0,
      },
    );
  }

  Future<List<SyncQueueItem>> getPendingOperations() async {
    final db = await database.database;

    final result = await db.query(
      'sync_queue',
      orderBy: 'createdAt ASC',
    );

    return result.map((json) {
      return SyncQueueItem(
        id: json['id'] as int,
        entityId: json['entityId'] as String,
        operation: SyncOperation.values.byName(
          json['operation'] as String,
        ),
        payload: json['payload'] as String,
        createdAt: DateTime.parse(
          json['createdAt'] as String,
        ),
        retryCount: json['retryCount'] as int,
      );
    }).toList();
  }

  Future<void> deleteOperation(int id) async {
    final db = await database.database;

    await db.delete(
      'sync_queue',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> incrementRetryCount(int id) async {
    final db = await database.database;

    await db.rawUpdate(
      '''
      UPDATE sync_queue
      SET retryCount = retryCount + 1
      WHERE id = ?
      ''',
      [id],
    );
  }
}