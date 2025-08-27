// import 'package:flutter_bloc/flutter_bloc.dart';

// abstract class AuthEvent {}
// class AppStarted extends AuthEvent {}
// class LoggedIn extends AuthEvent {}
// class LoggedOut extends AuthEvent {}

// abstract class AuthState {}
// class AuthInitial extends AuthState {}
// class Authenticated extends AuthState {}
// class Unauthenticated extends AuthState {}

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   AuthBloc() : super(AuthInitial()) {
//     on<AppStarted>((event, emit) {
//       // check if user is logged in (firebase.currentUser != null)
//       emit(Unauthenticated());
//     });

//     on<LoggedIn>((event, emit) => emit(Authenticated()));
//     on<LoggedOut>((event, emit) => emit(Unauthenticated()));
//   }
// }
