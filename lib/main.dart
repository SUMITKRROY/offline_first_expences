import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/database/app_database.dart';
import 'core/network/dio_client.dart';

import 'features/expenses/data/datasources/expense_local_datasource.dart';
import 'features/expenses/data/datasources/expense_local_datasource_impl.dart';

import 'features/expenses/data/datasources/expense_remote_datasource.dart';
import 'features/expenses/data/datasources/expense_remote_datasource_impl.dart';

import 'features/expenses/data/repositories/expense_repository_impl.dart';

import 'features/expenses/domain/repositories/expense_repository.dart';

 
import 'features/expenses/presention/bloc/expense_bloc.dart';
import 'features/expenses/presention/page/expense_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Database
  final database = AppDatabase();

  // Local data source
  final localDataSource = ExpenseLocalDataSourceImpl(
    database: database,
  );

  // Network
  final dioClient = DioClient();

  // Remote data source
  final remoteDataSource = ExpenseRemoteDataSourceImpl(
    dioClient: dioClient,
  );

  // Repository
  final repository = ExpenseRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );

  runApp(
    MyApp(
      repository: repository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ExpenseRepository repository;

  const MyApp({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ExpenseRepository>(
      create: (_) => repository,
      child: BlocProvider(
        create: (context) => ExpenseBloc(
          repository: context.read<ExpenseRepository>(),
        ),
        child: MaterialApp(
          title: 'Offline First',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
            ),
          ),
          home: const ExpensePage(),
        ),
      ),
    );
  }
}