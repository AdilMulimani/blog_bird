import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/entities/user.dart';
import '../../../../core/usecase/usecase.dart';

class UserSignUp implements UseCase<User, UserSignUpParameters> {
  final AuthRepository authRepository;

  const UserSignUp({
    required this.authRepository,
  });

  @override
  Future<Either<Failure, User>> call(
    UserSignUpParameters params,
  ) async {
    return await authRepository.signUpWithEmailPassword(
        name: params.name, email: params.email, password: params.password);
  }
}

class UserSignUpParameters {
  final String email;
  final String password;
  final String name;

  const UserSignUpParameters({
    required this.email,
    required this.password,
    required this.name,
  });
}
