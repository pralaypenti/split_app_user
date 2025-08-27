import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:split_app_user/src/ui/screens/login_screen.dart';

import 'firebase_options.dart';
import 'src/app.dart';
import 'src/bloc/group_bloc.dart';
import 'src/repositories/in_memory_repo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // ✅ Initialize Firebase safely
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("✅ Firebase initialized successfully");
  } catch (e, stack) {
    debugPrint("🔥 Firebase init error: $e");
    debugPrintStack(stackTrace: stack);
  }

  final repo = InMemoryRepo();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GroupBloc(repo: repo)..add(GroupStarted()),
        ),
        BlocProvider(
          create: (_) => AuthBloc(authRepository: AuthRepository())..add(AppStarted()),
        ),
      ],
      child: const SplitApp(),
    ),
  );
}
