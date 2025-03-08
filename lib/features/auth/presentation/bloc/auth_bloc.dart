import 'package:bloc/bloc.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/cubits/app_user_cubit.dart';
import '../../../../core/entities/user.dart';
import '../../../../core/error/failure.dart';
import '../../domain/usecases/current_user.dart';
import '../../domain/usecases/user_sign_in.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  //private instances of auth usecases for protection
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;

  final CurrentUser _currentUser;

  final AppUserCubit _appUserCubit;

  //requires usecases from outside and make them private
  //initial state is AuthInitial()
  AuthBloc(
      {required UserSignUp userSignUp,
      required UserSignIn userSignIn,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit})
      : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {

    //If AuthEvent is triggered loading should take place, so emit it
    on<AuthEvent>((_, emit) => emit(AuthLoading()));

    //Signup Event Trigger
    on<AuthSignUp>(_onAuthSignUp);

    //SignIn Event Trigger
    on<AuthSignIn>(_onAuthSignIn);

    //Current User Trigger
    on<AuthIsUserSignedIn>(_onAuthIsUserSignedIn);
  }

  //helper function to sign up
  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    //async response to get user details
    final Either<Failure, User> response =
        await _userSignUp(UserSignUpParameters(
      name: event.name,
      email: event.email,
      password: event.password,
    ));
    // .fold Executes the two cases either failure or success
    response.fold(
        (Failure failure) => emit(AuthFailure(message: failure.message)),
        (User user) => _emitAuthSuccess(user, emit));
  }

  //helper function to sign in
  void _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    //async response to get user details
    final Either<Failure, User> response =
        await _userSignIn(UserSignInParameters(
      email: event.email,
      password: event.password,
    ));
    // .fold Executes the two cases either failure or success
    response.fold(
        (Failure failure) => emit(AuthFailure(message: failure.message)),
        (User user) => _emitAuthSuccess(user, emit));
  }

  //helper function to check if the user is signed in
  void _onAuthIsUserSignedIn(
      AuthIsUserSignedIn event, Emitter<AuthState> emit) async {
    //async response to get user details
    final Either<Failure, User> response = await _currentUser(NoParams());
    // .fold Executes the two cases either failure or success
    response.fold(
        (Failure failure) => emit(AuthFailure(message: failure.message)),
        (User user) => _emitAuthSuccess(user, emit));
  }

  //A helper function to update app wide user and change auth state to success
  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
