import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:split_app_user/src/bloc/group_bloc.dart';
import 'package:split_app_user/src/models/expense.dart';
import 'package:split_app_user/src/models/member.dart';
import 'package:split_app_user/src/repositories/in_memory_repo.dart';
import 'package:split_app_user/src/models/group.dart' as app;

void main() {
  group('GroupBloc', () {
    late GroupBloc bloc;
    late HiveRepo repo;

   setUp(() async {
  Hive.init('./test/hive_test_temp');
  if (!Hive.isAdapterRegistered(MemberAdapter().typeId)) {
    Hive.registerAdapter(MemberAdapter());
  }
  if (!Hive.isAdapterRegistered(ExpenseAdapter().typeId)) {
    Hive.registerAdapter(ExpenseAdapter());
  }
  if (!Hive.isAdapterRegistered(app.GroupAdapter().typeId)) {
    Hive.registerAdapter(app.GroupAdapter());
  }
  final groupBox = await Hive.openBox<app.Group>('groups');
  repo = HiveRepo(groupBox);
  bloc = GroupBloc(repo: repo);
});


    blocTest<GroupBloc, GroupState>(
      'starts and loads groups',
      build: () => bloc,
      act: (b) => b.add(GroupStarted()),
      expect: () => [
        isA<GroupState>().having(
          (s) => s.status,
          'status',
          GroupStatus.loading,
        ),
        isA<GroupState>().having((s) => s.status, 'status', GroupStatus.ready),
      ],
    );

    blocTest<GroupBloc, GroupState>(
      'create group then add expense',
      build: () => bloc,
      act: (b) async {
        b.add(GroupStarted());
        await Future<void>.delayed(const Duration(milliseconds: 10));
        b.add(
          CreateGroupRequested('Trip', 'Travel', [
            Member(id: 'a', name: 'Alice'),
            Member(id: 'b', name: 'Bob'),
          ]),
        );
        await Future<void>.delayed(const Duration(milliseconds: 10));
        final g = b.state.activeGroup!;
        b.add(
          AddExpenseRequested(
            Expense(
              id: '1',
              title: 'Taxi',
              amount: 300,
              paidBy: g.members.first.id,
              createdAt: DateTime(2024),
            ),
          ),
        );
      },
      wait: const Duration(milliseconds: 100),
      expect: () => contains(isA<GroupState>()),
    );
  });
}
