import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/group.dart';
import '../models/member.dart';
import '../models/expense.dart';
import '../repositories/in_memory_repo.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final Repo repo;
  GroupBloc({required this.repo}) : super(const GroupState()) {
    on<GroupStarted>(_onStarted);
    on<CreateGroupRequested>(_onCreateGroup);
    on<AddExpenseRequested>(_onAddExpense);
    on<DeleteGroup>(_onDeleteGroup);
    on<ActiveGroupChanged>(
      (e, emit) => emit(state.copyWith(activeGroup: e.group)),
    );
  }

  Future<void> _onStarted(GroupStarted event, Emitter<GroupState> emit) async {
    emit(state.copyWith(status: GroupStatus.loading));
    final groups = await repo.fetchGroups();
    emit(state.copyWith(status: GroupStatus.ready, groups: groups));
  }

  Future<void> _onCreateGroup(
    CreateGroupRequested event,
    Emitter<GroupState> emit,
  ) async {
    emit(state.copyWith(status: GroupStatus.loading));
    final g = await repo.createGroup(event.name, event.category, event.members);
    final groups = [...state.groups, g];
    emit(
      state.copyWith(status: GroupStatus.ready, groups: groups, activeGroup: g),
    );
  }

  Future<void> _onAddExpense(
    AddExpenseRequested event,
    Emitter<GroupState> emit,
  ) async {
    final active = state.activeGroup;
    if (active == null) return;
    emit(state.copyWith(status: GroupStatus.loading));
    final updated = await repo.addExpense(active, event.expense);
    final groups = [
      for (final g in state.groups)
        if (g.id == updated.id) updated else g,
    ];
    emit(
      state.copyWith(
        status: GroupStatus.ready,
        groups: groups,
        activeGroup: updated,
      ),
    );
  }

  Future<void> _onDeleteGroup(
    DeleteGroup event,
    Emitter<GroupState> emit,
  ) async {
    emit(state.copyWith(status: GroupStatus.loading));
    await repo.deleteGroup(event.group);
    final updatedGroups = state.groups
        .where((g) => g.id != event.group.id)
        .toList();
    emit(
      state.copyWith(
        status: GroupStatus.ready,
        groups: updatedGroups,
        activeGroup: null,
      ),
    );
  }
}
