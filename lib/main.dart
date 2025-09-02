import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:split_app_user/src/bloc/auth_sigin_event.dart';
import 'package:split_app_user/src/bloc/auth_singin_bloc.dart';
import 'package:split_app_user/src/models/expense.dart';
import 'package:split_app_user/src/models/group.dart';
import 'package:split_app_user/src/models/member.dart';
import 'package:split_app_user/src/repositories/sigin_repo.dart';
import 'firebase_options.dart';
import 'src/app.dart';
import 'src/bloc/group_bloc.dart';
import 'src/repositories/in_memory_repo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("✅ Firebase initialized successfully");
  } catch (e, stack) {
    debugPrint("🔥 Firebase init error: $e");
    debugPrintStack(stackTrace: stack);
  }

 await Hive.initFlutter();

  Hive.registerAdapter(GroupAdapter());
  Hive.registerAdapter(MemberAdapter());
  Hive.registerAdapter(ExpenseAdapter());

  final groupBox = await Hive.openBox<Group>('groups');
  final repo = HiveRepo(groupBox);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GroupBloc(repo: repo)..add(GroupStarted())),
        BlocProvider(
          create: (_) =>
              AuthBloc(authRepository: AuthRepository())..add(AppStarted()),
        ),
      ],
      child: SplitApp(hiveRepo: repo),
    ),
  );
}
