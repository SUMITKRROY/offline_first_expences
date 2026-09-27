import '../../domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.userId,
    required super.amount,
    required super.categoryId,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
    required super.syncStatus,
    required super.version, required super.isDeleted,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      syncStatus: SyncStatus.values.byName(
        json['syncStatus'] as String,
      ),
      version: json['version'] as int, isDeleted: json['isDeleted'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'categoryId': categoryId,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'syncStatus': syncStatus.name,
      'version': version,
    };
  }

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      userId: expense.userId,
      amount: expense.amount,
      categoryId: expense.categoryId,
      description: expense.description,
      createdAt: expense.createdAt,
      updatedAt: expense.updatedAt,
      syncStatus: expense.syncStatus,
      version: expense.version, isDeleted: expense.isDeleted,
    );
  }
  ExpenseModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? categoryId,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    int? version,
    bool? isDeleted,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version, isDeleted: isDeleted ?? this.isDeleted,
      // isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
