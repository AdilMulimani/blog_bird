import 'package:blog_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

//an abstract interface class which has generic type SuccessType and a Parameter Type
//uses special call function which return either a failure (message) or the success type
abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

//if no any parameters needs to passed
class NoParams {}
