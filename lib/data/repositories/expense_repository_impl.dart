import 'package:dartz/dartz.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_data_source.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Exception, List<Expense>>> getExpensesForTrip(String tripId) async {
    try {
      final expenses = await localDataSource.getExpensesForTrip(tripId);
      return Right(expenses);
    } catch (e) {
      return Left(Exception('Failed to load expenses'));
    }
  }

  @override
  Future<Either<Exception, void>> addExpense(Expense expense) async {
    try {
      final expenseModel = ExpenseModel.fromEntity(expense);
      await localDataSource.saveExpense(expenseModel);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to save expense'));
    }
  }

  @override
  Future<Either<Exception, void>> deleteExpense(String expenseId) async {
    try {
      await localDataSource.deleteExpense(expenseId);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to delete expense'));
    }
  }
}
