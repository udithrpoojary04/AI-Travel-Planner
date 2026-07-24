import 'package:hive/hive.dart';
import '../../domain/entities/expense.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 3)
class ExpenseModel extends Expense {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String tripId;
  
  @HiveField(2)
  final String title;
  
  @HiveField(3)
  final double amount;
  
  @HiveField(4)
  final String category;
  
  @HiveField(5)
  final DateTime date;

  const ExpenseModel({
    required this.id,
    required this.tripId,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  }) : super(
          id: id,
          tripId: tripId,
          title: title,
          amount: amount,
          category: category,
          date: date,
        );

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      tripId: expense.tripId,
      title: expense.title,
      amount: expense.amount,
      category: expense.category,
      date: expense.date,
    );
  }
}
