import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_app_user/src/app.dart';
import 'package:split_app_user/src/bloc/group_bloc.dart';
import 'package:split_app_user/src/repositories/in_memory_repo.dart';



void main() {
  testWidgets('App builds and shows splash', (tester) async {
    final repo = InMemoryRepo();
    await tester.pumpWidget(BlocProvider(
      create: (_) => GroupBloc(repo: repo),
      child: const SplitApp(),
    ));
    expect(find.text('Split'), findsOneWidget);
  });
}
