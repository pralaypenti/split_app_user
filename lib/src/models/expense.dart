import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final String title;
  final int amount; // in INR
  final String paidBy; // member id
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.paidBy,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, amount, paidBy, createdAt];
}
