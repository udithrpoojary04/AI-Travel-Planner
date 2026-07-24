import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/expense_repository.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository expenseRepository;

  ExpenseBloc({required this.expenseRepository}) : super(ExpenseInitial()) {
    on<LoadExpensesEvent>(_onLoadExpenses);
    on<AddExpenseEvent>(_onAddExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
  }

  Future<void> _onLoadExpenses(LoadExpensesEvent event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    final result = await expenseRepository.getExpensesForTrip(event.tripId);
    
    result.fold(
      (error) => emit(ExpenseError(error.toString())),
      (expenses) {
        final total = expenses.fold(0.0, (sum, item) => sum + item.amount);
        emit(ExpenseLoaded(expenses: expenses, totalSpent: total));
      },
    );
  }

  Future<void> _onAddExpense(AddExpenseEvent event, Emitter<ExpenseState> emit) async {
    await expenseRepository.addExpense(event.expense);
    add(LoadExpensesEvent(event.expense.tripId));
  }

  Future<void> _onDeleteExpense(DeleteExpenseEvent event, Emitter<ExpenseState> emit) async {
    await expenseRepository.deleteExpense(event.expenseId);
    add(LoadExpensesEvent(event.tripId));
  }
}
