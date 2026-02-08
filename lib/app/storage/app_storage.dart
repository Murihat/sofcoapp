import 'package:get_storage/get_storage.dart';

class AppStorage {
  static final box = GetStorage();

  // existing
  static const token = 'token';

  // new
  static const user = 'user';

  // ========= SESSION =========
  static bool isLoggedIn() => box.hasData(token);

  static void saveToken(String value) => box.write(token, value);

  // ========= USER =========
  static void saveUser(Map<String, dynamic> userData) {
    box.write(user, userData);
  }

  static Map<String, dynamic>? get getUser {
    return box.read(user);
  }

  static void logout() => box.erase();
}
