import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_app_user/src/bloc/group_bloc.dart';
import 'package:split_app_user/src/models/expense.dart';



class AddExpenseScreen extends StatefulWidget {
  static const routeName = '/add-expense';
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  String? _paidBy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          final g = state.activeGroup;
          if (g == null) return const Center(child: Text('No active group'));
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
                const SizedBox(height: 12),
                TextField(controller: _amount, decoration: const InputDecoration(labelText: 'Amount (₹)'), keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                const Text('Paid By'),
                Wrap(
                  spacing: 8,
                  children: g.members.map((m) => ChoiceChip(
                    label: Text(m.name),
                    selected: _paidBy == m.id,
                    onSelected: (_) => setState(()=> _paidBy = m.id),
                  )).toList(),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (_title.text.isEmpty || _amount.text.isEmpty || _paidBy == null) return;
                    final exp = Expense(
                      id: Random().nextInt(1<<32).toString(),
                      title: _title.text,
                      amount: int.tryParse(_amount.text) ?? 0,
                      paidBy: _paidBy!,
                      createdAt: DateTime.now(),
                    );
                    context.read<GroupBloc>().add(AddExpenseRequested(exp));
                    Navigator.pop(context);
                  },
                  child: const Text('Add Expense'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
