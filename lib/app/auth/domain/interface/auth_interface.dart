import '../../data/model/user_model.dart';

abstract class AuthInterface {
  Future<UserModel> login(String email, String password);
  Future<void> register(String name, String email, String password);
}
