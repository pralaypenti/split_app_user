import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_app_user/src/bloc/auth_sigin_event.dart';
import 'package:split_app_user/src/bloc/auth_singin_state.dart';
import 'package:split_app_user/src/repositories/sigin_repo.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AppStarted>((event, emit) {
      final user = authRepository.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.login(event.email, event.password);
        emit(AuthAuthenticated(user!));
      } catch (e) {
        emit(AuthError("Login failed: $e"));
      }
    });

    on<SignupRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signup(
          event.email,
          event.password,
          event.name,
        );
        emit(AuthAuthenticated(user!));
      } catch (e) {
        emit(AuthError("Signup failed: $e"));
      }
    });

    on<GoogleLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signInWithGoogle();
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthError("User canceled Google login"));
        }
      } catch (e) {
        emit(AuthError("Google login failed: $e"));
      }
    });

    on<AppleLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signInWithApple();
        emit(AuthAuthenticated(user!));
      } catch (e) {
        emit(AuthError("Apple login failed: $e"));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await authRepository.logout();
      emit(AuthUnauthenticated());
    });
  }
}