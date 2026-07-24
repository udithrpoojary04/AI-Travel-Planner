import 'package:dartz/dartz.dart';
import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<Either<Exception, List<Expense>>> getExpensesForTrip(String tripId);
  Future<Either<Exception, void>> addExpense(Expense expense);
  Future<Either<Exception, void>> deleteExpense(String expenseId);
}
