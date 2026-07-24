import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final String tripId;
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  const Expense({
    required this.id,
    required this.tripId,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  @override
  List<Object?> get props => [id, tripId, title, amount, category, date];
}
