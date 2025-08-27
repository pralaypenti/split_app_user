import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_app_user/src/bloc/group_bloc.dart';

class GroupDetailsScreen extends StatelessWidget {
  static const routeName = '/group-details';
  const GroupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Details')),
      body: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          final g = state.activeGroup;
          if (g == null) return const Center(child: Text('No active group'));
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Text(g.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Expenses'),
              const SizedBox(height: 8),
              if (g.expenses.isEmpty) const Text('No expenses yet'),
              ...g.expenses.map((e) => Card(
                child: ListTile(
                  title: Text(e.title),
                  trailing: Text('₹${e.amount}'),
                  subtitle: Text('Paid by: ${g.members.firstWhere((m)=>m.id==e.paidBy).name}'),
                ),
              )),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'add',
            onPressed: () => Navigator.pushNamed(context, '/add-expense'),
            label: const Text('Add Expense'),
            icon: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'settle',
            onPressed: () => Navigator.pushNamed(context, '/settle-up'),
            label: const Text('Settle Up'),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
