import 'package:equatable/equatable.dart';
import '../../../domain/entities/expense.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

class LoadExpensesEvent extends ExpenseEvent {
  final String tripId;

  const LoadExpensesEvent(this.tripId);

  @override
  List<Object> get props => [tripId];
}

class AddExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const AddExpenseEvent(this.expense);

  @override
  List<Object> get props => [expense];
}

class DeleteExpenseEvent extends ExpenseEvent {
  final String expenseId;
  final String tripId;

  const DeleteExpenseEvent({required this.expenseId, required this.tripId});

  @override
  List<Object> get props => [expenseId, tripId];
}
