import 'package:lab_clinicas_core/lab_clinicas_core.dart';

abstract interface class UserLoginServiceInterface {
Future<Either<ServiceException, Unit>> execute(String email, String password);

}