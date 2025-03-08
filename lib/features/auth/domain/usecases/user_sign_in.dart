import 'package:fpdart/fpdart.dart';

import '../../../../core/entities/user.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class UserSignIn implements UseCase<User, UserSignInParameters> {
  final AuthRepository authRepository;

  const UserSignIn({
    required this.authRepository,
  });

  @override
  Future<Either<Failure, User>> call(
    UserSignInParameters params,
  ) async {
    return await authRepository.signInWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignInParameters {
  final String email;
  final String password;

  const UserSignInParameters({
    required this.email,
    required this.password,
  });
}
