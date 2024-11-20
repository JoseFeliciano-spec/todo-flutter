import 'package:todo_flutter/context/auth/domain/entities/auth.dart';

abstract class AuthRepository {
  Future<String> register(String email, String password, String name);
  Future<String> login(String email, String password);
  Future<User> getCurrentUser();
}
