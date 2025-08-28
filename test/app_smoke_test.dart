import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:split_app_user/src/models/group.dart' as app;
import 'dart:io';

void main() {
  setUpAll(() async {
    final dir = Directory.systemTemp.createTempSync();
    Hive.init(dir.path);
    Hive.registerAdapter(app.GroupAdapter());
  });

  // testWidgets('App builds and shows splash', (tester) async {
  //   final groupBox = await Hive.openBox<app.Group>('groups');
  //   final repo = HiveRepo(groupBox);
  //   await tester.pumpWidget(SplitApp(hiveRepo: repo));

  //   await tester.pumpAndSettle();

  //   expect(find.text('Split'), findsOneWidget);
  // });
//   testWidgets('App builds and shows splash', (tester) async {
//  final groupBox = await Hive.openBox<app.Group>('groups');
//     final repo = HiveRepo(groupBox); 
//      await tester.pumpWidget(SplitApp(hiveRepo: repo));

//   await tester.pumpAndSettle();

//   expect(find.text('Split'), findsOneWidget);
// });

}
