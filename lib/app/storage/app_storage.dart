import 'package:get_storage/get_storage.dart';

class AppStorage {
  static final box = GetStorage();

  static const token = 'token';

  static const user = 'user';

  static bool isLoggedIn() => box.hasData(token);

  static void saveToken(String value) => box.write(token, value);

  static void saveUser(Map<String, dynamic> userData) {
    box.write(user, userData);
  }

  static Map<String, dynamic>? get getUser {
    return box.read(user);
  }

  static void logout() => box.erase();
}
