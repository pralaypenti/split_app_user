import 'package:equatable/equatable.dart';
import 'member.dart';
import 'expense.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final String category; // Food, Travel, Rent
  final List<Member> members;
  final List<Expense> expenses;

  const Group({
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
  }) => Group(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    members: members ?? this.members,
    expenses: expenses ?? this.expenses,
  );

  @override
  List<Object?> get props => [id, name, category, members, expenses];
}
