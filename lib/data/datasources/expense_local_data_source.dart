import 'package:hive/hive.dart';
import '../models/expense_model.dart';

abstract class ExpenseLocalDataSource {
  Future<List<ExpenseModel>> getExpensesForTrip(String tripId);
  Future<void> saveExpense(ExpenseModel expense);
  Future<void> deleteExpense(String expenseId);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final Box<ExpenseModel> expenseBox;

  ExpenseLocalDataSourceImpl({required this.expenseBox});

  @override
  Future<List<ExpenseModel>> getExpensesForTrip(String tripId) async {
    return expenseBox.values.where((expense) => expense.tripId == tripId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<void> saveExpense(ExpenseModel expense) async {
    await expenseBox.put(expense.id, expense);
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    await expenseBox.delete(expenseId);
  }
}
