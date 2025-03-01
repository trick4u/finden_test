import 'package:dartz/dartz.dart';

import '../failure/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> signInWithEmail(String email, String password);
  Future<Either<Failure, Unit>> signUpWithEmail(String email, String password);
  Future<void> signOut();
  String? getCurrentUserId();
}