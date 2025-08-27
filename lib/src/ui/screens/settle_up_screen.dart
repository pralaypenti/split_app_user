import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_app_user/src/bloc/group_bloc.dart';

class SettleUpScreen extends StatelessWidget {
  static const routeName = '/settle-up';
  const SettleUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settle Up')),
      body: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          final g = state.activeGroup;
          if (g == null) return const Center(child: Text('No active group'));
          // Simple equal split suggestions (no graph): who paid how much.
          final totals = <String,int>{ for (final m in g.members) m.id: 0 };
          for (final e in g.expenses) {
            totals[e.paidBy] = (totals[e.paidBy] ?? 0) + e.amount;
          }
          final perHead = (g.expenses.fold<int>(0,(p,e)=>p+e.amount) / (g.members.length)).round();
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Text('Per head: ₹$perHead'),
              const SizedBox(height: 12),
              ...g.members.map((m) {
                final diff = (totals[m.id] ?? 0) - perHead;
                final text = diff >= 0 ? '${m.name} should receive ₹$diff' : '${m.name} owes ₹${-diff}';
                return ListTile(title: Text(text));
              }),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Mark as settled')),
            ],
          );
        },
      ),
    );
  }
}
