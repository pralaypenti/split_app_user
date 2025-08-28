import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_app_user/src/bloc/group_bloc.dart';
import 'package:split_app_user/src/models/member.dart';

class CreateGroupScreen extends StatefulWidget {
  static const routeName = '/create-group';
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _name = TextEditingController();
  String _category = 'Food';
  final List<Member> _picked = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Group')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Group Name'),
            ),
            const SizedBox(height: 12),
            const Text('Select Category'),
            Wrap(
              spacing: 8,
              children: ['Food', 'Travel', 'Rent']
                  .map(
                    (c) => ChoiceChip(
                      label: Text(c),
                      selected: _category == c,
                      onSelected: (_) => setState(() => _category = c),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final members =
                    await Navigator.pushNamed(context, '/add-members')
                        as List<Member>?;
                if (members != null) {
                  setState(() {
                    _picked.clear();
                    _picked.addAll(members);
                  });
                }
              },
              child: const Text('Add Members'),
            ),
            const SizedBox(height: 8),
            Text(
              _picked.isEmpty
                  ? 'No members selected'
                  : _picked.map((e) => e.name).join(', '),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_name.text.isEmpty || _picked.isEmpty) return;
                context.read<GroupBloc>().add(
                  CreateGroupRequested(_name.text, _category, _picked),
                );
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
