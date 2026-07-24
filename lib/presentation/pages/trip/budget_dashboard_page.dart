import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/trip.dart';
import '../../bloc/expense/expense_bloc.dart';
import '../../bloc/expense/expense_event.dart';
import '../../bloc/expense/expense_state.dart';
import '../../../injection_container.dart' as di;
import '../../../core/theme/app_theme.dart';

class BudgetDashboardPage extends StatelessWidget {
  final Trip trip;

  const BudgetDashboardPage({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ExpenseBloc>()..add(LoadExpensesEvent(trip.id)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Budget Dashboard'),
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        body: Stack(
          children: [
            // Background Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.background, Color(0xFF1E1B4B)],
                ),
              ),
            ),
            // Glow effect
            Positioned(
              bottom: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryGradientEnd.withOpacity(0.15),
                ),
              ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(duration: 4.seconds, begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
            ),
            SafeArea(
              child: BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  if (state is ExpenseLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
                  } else if (state is ExpenseError) {
                    return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.white)));
                  } else if (state is ExpenseLoaded) {
                    return _buildDashboard(context, state.expenses, state.totalSpent);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton.extended(
              onPressed: () => _showAddExpenseDialog(context),
              backgroundColor: AppTheme.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Expense', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ).animate().slideY(begin: 1.0).fadeIn(delay: 500.ms);
          }
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, List<Expense> expenses, double totalSpent) {
    final double remaining = trip.budget - totalSpent;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    'Total Budget',
                    trip.budget,
                    AppTheme.primary,
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    'Spent',
                    totalSpent,
                    AppTheme.secondary,
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSummaryCard(
              context,
              'Remaining',
              remaining,
              remaining >= 0 ? const Color(0xFF10B981) : AppTheme.secondary,
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1),
            const SizedBox(height: 32),
            
            // Chart
            if (expenses.isNotEmpty) ...[
              Text(
                'Spending by Category',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 24),
              SizedBox(
                height: 220,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 50,
                    sections: _generateChartData(expenses),
                  ),
                ),
              ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack, delay: 400.ms),
              const SizedBox(height: 32),
            ],

            // Expense List
            Text(
              'Recent Expenses',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ).animate().fadeIn(delay: 500.ms),
            const SizedBox(height: 16),
            if (expenses.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.surface.withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white10),
                        ),
                        child: const Icon(Icons.account_balance_wallet_outlined, size: 48, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No expenses logged yet.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 600.ms)
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return Dismissible(
                    key: Key(expense.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.secondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      context.read<ExpenseBloc>().add(DeleteExpenseEvent(
                            expenseId: expense.id,
                            tripId: trip.id,
                          ));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.surface.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(expense.category).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_getCategoryIcon(expense.category), color: _getCategoryColor(expense.category)),
                        ),
                        title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        subtitle: Text("${DateFormat('MMM d').format(expense.date)} • ${expense.category}", style: const TextStyle(color: AppTheme.textSecondary)),
                        trailing: Text(
                          '₹${expense.amount.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: (600 + (index * 50)).ms).slideX(begin: 0.1, end: 0);
                },
              ),
            const SizedBox(height: 80), // padding for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary)),
          const SizedBox(height: 12),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _generateChartData(List<Expense> expenses) {
    final Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals[expense.category] = (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    return categoryTotals.entries.map((entry) {
      return PieChartSectionData(
        color: _getCategoryColor(entry.key),
        value: entry.value,
        title: entry.key,
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food': return const Color(0xFFF59E0B); // Amber
      case 'Transport': return const Color(0xFF3B82F6); // Blue
      case 'Accommodation': return const Color(0xFF8B5CF6); // Violet
      case 'Activities': return const Color(0xFF10B981); // Emerald
      case 'Shopping': return const Color(0xFFEC4899); // Pink
      default: return const Color(0xFF64748B); // Slate
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food': return Icons.restaurant;
      case 'Transport': return Icons.directions_transit;
      case 'Accommodation': return Icons.hotel;
      case 'Activities': return Icons.local_activity;
      case 'Shopping': return Icons.shopping_bag;
      default: return Icons.money;
    }
  }

  void _showAddExpenseDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = 'Food';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: Colors.white10),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add Expense', style: Theme.of(bottomSheetContext).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 24),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title', prefixIcon: Icon(Icons.description)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Amount', prefixIcon: Icon(Icons.currency_rupee)),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category)),
                items: ['Food', 'Transport', 'Accommodation', 'Activities', 'Shopping', 'Other']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) selectedCategory = val;
                },
                dropdownColor: AppTheme.surfaceHighlight,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(amountController.text);
                  if (titleController.text.isNotEmpty && amount != null) {
                    final newExpense = Expense(
                      id: const Uuid().v4(),
                      tripId: trip.id,
                      title: titleController.text,
                      amount: amount,
                      category: selectedCategory,
                      date: DateTime.now(),
                    );
                    context.read<ExpenseBloc>().add(AddExpenseEvent(newExpense));
                    Navigator.pop(bottomSheetContext);
                  }
                },
                child: const Text('Save Expense'),
              ),
            ],
          ),
        );
      },
    );
  }
}
