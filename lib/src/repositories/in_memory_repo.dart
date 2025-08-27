import 'dart:math';
import '../models/member.dart';
import '../models/expense.dart';
import '../models/group.dart';

abstract class Repo {
  Future<List<Group>> fetchGroups();
  Future<Group> createGroup(String name, String category, List<Member> members);
  Future<Group> addExpense(Group group, Expense expense);
  Future<void> deleteGroup(Group group);
}

class InMemoryRepo implements Repo {
  final List<Group> _groups = [];

  @override
  Future<List<Group>> fetchGroups() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return List<Group>.unmodifiable(_groups);
  }

  @override
  Future<Group> createGroup(
    String name,
    String category,
    List<Member> members,
  ) async {
    final g = Group(
      id: _id(),
      name: name,
      category: category,
      members: members,
      expenses: const [],
    );
    _groups.add(g);
    return g;
  }

  @override
  Future<Group> addExpense(Group group, Expense expense) async {
    final idx = _groups.indexWhere((e) => e.id == group.id);
    if (idx == -1) throw StateError('Group not found');
    final updated = group.copyWith(expenses: [...group.expenses, expense]);
    _groups[idx] = updated;
    return updated;
  }

  @override
  Future<void> deleteGroup(Group group) async {
    _groups.removeWhere((g) => g.id == group.id);
  }

  String _id() => Random().nextInt(1 << 32).toString();
}
