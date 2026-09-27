import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../models/expense_model.dart';
import 'expense_remote_datasource.dart';

class ExpenseRemoteDataSourceImpl
    implements ExpenseRemoteDataSource {
  final DioClient dioClient;

  ExpenseRemoteDataSourceImpl({
    required this.dioClient,
  });

  Dio get _dio => dioClient.dio;

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final response = await _dio.get(
      '/expenses',
    );

    final data = response.data as List;

    return data
        .map(
          (json) => ExpenseModel.fromJson(
        json as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  @override
  Future<ExpenseModel> createExpense(
      ExpenseModel expense,
      ) async {
    final response = await _dio.post(
      '/expenses',
      data: expense.toJson(),
    );

    return ExpenseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<ExpenseModel> updateExpense(
      ExpenseModel expense,
      ) async {
    final response = await _dio.put(
      '/expenses/${expense.id}',
      data: expense.toJson(),
    );

    return ExpenseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<void> deleteExpense(
      String id,
      ) async {
    await _dio.delete(
      '/expenses/$id',
    );
  }
}