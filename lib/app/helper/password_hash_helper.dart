import 'package:bcrypt/bcrypt.dart';

class PasswordHashHelper {
  /// hash password saat register
  static String hash(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  /// verify password saat login
  static bool verify(String password, String hashedPassword) {
    return BCrypt.checkpw(password, hashedPassword);
  }
}
