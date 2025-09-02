import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_app_user/src/bloc/auth_sigin_event.dart';
import 'package:split_app_user/src/bloc/auth_singin_bloc.dart';
import 'package:split_app_user/src/models/member.dart';
import 'package:split_app_user/src/repositories/in_memory_repo.dart';
import 'package:split_app_user/src/repositories/sigin_repo.dart';
import 'package:split_app_user/src/ui/screens/forgotPassword.dart';
import 'package:split_app_user/src/ui/screens/signupScreen.dart';
import 'theme.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/screens/login_screen.dart';

import 'ui/screens/home_screen.dart';
import 'ui/screens/create_group_screen.dart';
import 'ui/screens/add_members_screen.dart';
import 'ui/screens/group_details_screen.dart';
import 'ui/screens/add_expense_screen.dart';
import 'ui/screens/settle_up_screen.dart';

import 'bloc/group_bloc.dart';

class SplitApp extends StatelessWidget {
  final HiveRepo hiveRepo;

  const SplitApp({super.key, required this.hiveRepo});

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(authRepository: authRepo)..add(AppStarted()),
        ),
        BlocProvider(
          create: (_) => GroupBloc(repo: hiveRepo)..add(GroupStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Split',
        theme: buildTheme(),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (_) => const SplashScreen(),
          OnboardingScreen.routeName: (_) => const OnboardingScreen(),
          LoginScreen.routeName: (_) => const LoginScreen(),
          SignupScreen.routeName: (_) => const SignupScreen(),
          ForgotPasswordScreen.routeName: (_) => const ForgotPasswordScreen(),
          HomeScreen.routeName: (_) => const HomeScreen(),
          CreateGroupScreen.routeName: (_) => const CreateGroupScreen(),
          AddMembersScreen.routeName: (_) {
            final user = FirebaseAuth.instance.currentUser;
            return AddMembersScreen(
              defaultMember: Member(
                id: user?.uid ?? '1',
                name: user?.displayName ?? user?.email ?? 'Guest User',
              ),
            );
          },
          GroupDetailsScreen.routeName: (_) => const GroupDetailsScreen(),
          AddExpenseScreen.routeName: (_) => const AddExpenseScreen(),
          SettleUpScreen.routeName: (_) => const SettleUpScreen(),
        },
      ),
    );
  }
}
