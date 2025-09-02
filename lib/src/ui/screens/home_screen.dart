import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_app_user/src/bloc/auth_sigin_event.dart';
import 'package:split_app_user/src/bloc/auth_singin_bloc.dart';
import 'package:split_app_user/src/models/group.dart';
import 'package:split_app_user/src/bloc/group_bloc.dart';
import 'package:split_app_user/src/ui/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  void _confirmDelete(BuildContext context, Group group) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text('Are you sure you want to delete "${group.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<GroupBloc>().add(DeleteGroup(group));
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
          ),
        ],
      ),
      body: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          if (state.status == GroupStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.groups.isEmpty) {
            return const Center(child: Text('No groups yet. Tap + to create.'));
          }
          return ListView.builder(
            itemCount: state.groups.length,
            itemBuilder: (context, i) {
              final g = state.groups[i];
              final total = g.expenses.fold<int>(0, (p, e) => p + e.amount);
              return ListTile(
                title: Text(g.name),
                subtitle: Text('${g.members.length} members • ${g.category}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('₹$total'),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, g),
                    ),
                  ],
                ),
                onTap: () {
                  context.read<GroupBloc>().add(ActiveGroupChanged(g));
                  Navigator.pushNamed(context, '/group-details');
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'create_group',
        onPressed: () => Navigator.pushNamed(context, '/create-group'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
