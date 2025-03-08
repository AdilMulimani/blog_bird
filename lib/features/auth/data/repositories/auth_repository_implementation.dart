import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../core/entities/user.dart';
import '../../../../core/error/exceptions.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;

  const AuthRepositoryImplementation({
    required this.connectionChecker,
    required this.authRemoteDataSource,
  });

  @override
  Future<Either<Failure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await _getUser(() => authRemoteDataSource.signInWithEmailPassword(
          email: email,
          password: password,
        ));
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _getUser(() => authRemoteDataSource.signUpWithEmailPassword(
          name: name,
          email: email,
          password: password,
        ));
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await connectionChecker.isConnected) {
        final supabase.Session? session =
            authRemoteDataSource.currentUserSession;
        if (session == null) {
          return left(const Failure('User is not logged in!'));
        }
        return right(UserModel(
          id: session.user.id,
          email: session.user.email ?? '',
          name: '',
        ));
      }
      final User? user = await authRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(const Failure('User is not logged in!'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //Helper function to get user
  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const Failure('No internet Connection'));
      }
      final User user = await fn();
      return right(user);
    } on supabase.AuthException catch (e) {
      return left(Failure(e.toString()));
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
