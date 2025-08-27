part of 'group_bloc.dart';

enum GroupStatus { initial, loading, ready }

class GroupState extends Equatable {
  final GroupStatus status;
  final List<Group> groups;
  final Group? activeGroup;

  const GroupState({
    this.status = GroupStatus.initial,
    this.groups = const [],
    this.activeGroup,
  });

  GroupState copyWith({
    GroupStatus? status,
    List<Group>? groups,
    Group? activeGroup,
  }) => GroupState(
    status: status ?? this.status,
    groups: groups ?? this.groups,
    activeGroup: activeGroup ?? this.activeGroup,
  );

  @override
  List<Object?> get props => [status, groups, activeGroup];
}
