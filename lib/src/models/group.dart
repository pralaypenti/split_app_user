import 'package:hive/hive.dart';
import 'member.dart';
import 'expense.dart';
part 'group.g.dart';

@HiveType(typeId: 0)
class Group extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final List<Member> members;
  @HiveField(4)
  final List<Expense> expenses;

  Group({
    required this.id,
    required this.name,
    required this.category,
    required this.members,
    required this.expenses,
  });

  Group copyWith({
    String? id,
    String? name,
    String? category,
    List<Member>? members,
    List<Expense>? expenses,
  }) =>
      Group(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        members: members ?? this.members,
        expenses: expenses ?? this.expenses,
      );
}
