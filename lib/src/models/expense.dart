import 'package:hive/hive.dart';
part 'expense.g.dart';

@HiveType(typeId: 2)
class Expense extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int amount;

  @HiveField(3)
  final String paidBy;

  @HiveField(4)
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.paidBy,
    required this.createdAt,
  });
}
