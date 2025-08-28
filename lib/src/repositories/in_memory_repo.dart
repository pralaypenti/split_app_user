import 'package:hive/hive.dart';
import '../models/group.dart';
import '../models/member.dart';
import '../models/expense.dart';

abstract class Repo {
  Future<List<Group>> fetchGroups();
  Future<Group> createGroup(String name, String category, List<Member> members);
  Future<Group> addExpense(Group group, Expense expense);
  Future<void> deleteGroup(Group group);
}

class HiveRepo implements Repo {
  final Box<Group> _groupBox;

  HiveRepo(this._groupBox);

  @override
  Future<List<Group>> fetchGroups() async {
    return _groupBox.values.toList();
  }

  @override
  Future<Group> createGroup(
      String name, String category, List<Member> members) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final group = Group(
      id: id,
      name: name,
      category: category,
      members: members,
      expenses: [],
    );
    await _groupBox.add(group);
    return group;
  }

  @override
  Future<Group> addExpense(Group group, Expense expense) async {
    final key = _groupBox.keys.firstWhere(
      (k) => _groupBox.get(k)!.id == group.id,
      orElse: () => throw StateError('Group not found'),
    );
    final updated = group.copyWith(expenses: [...group.expenses, expense]);
    await _groupBox.put(key, updated);
    return updated;
  }

  @override
  Future<void> deleteGroup(Group group) async {
    final key = _groupBox.keys.firstWhere(
      (k) => _groupBox.get(k)!.id == group.id,
      orElse: () => throw StateError('Group not found'),
    );
    await _groupBox.delete(key);
  }
}
