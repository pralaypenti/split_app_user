part of 'group_bloc.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();
  @override
  List<Object?> get props => [];
}

class GroupStarted extends GroupEvent {}

class CreateGroupRequested extends GroupEvent {
  final String name;
  final String category;
  final List<Member> members;
  const CreateGroupRequested(this.name, this.category, this.members);

  @override
  List<Object?> get props => [name, category, members];
}

class AddExpenseRequested extends GroupEvent {
  final Expense expense;
  const AddExpenseRequested(this.expense);
  @override
  List<Object?> get props => [expense];
}

class ActiveGroupChanged extends GroupEvent {
  final Group group;
  const ActiveGroupChanged(this.group);
  @override
  List<Object?> get props => [group];
}
class DeleteGroup extends GroupEvent {
  final Group group;

  const DeleteGroup(this.group);

  @override
  List<Object?> get props => [group];
}