import 'package:lab_clinicas_core/lab_clinicas_core.dart';

abstract interface class UserRepositoryInterface {
  Future<Either<AuthException, String>>login(String email, String password);


}