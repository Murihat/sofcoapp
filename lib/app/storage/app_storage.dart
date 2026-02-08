import 'package:get_storage/get_storage.dart';

class AppStorage {
  static final box = GetStorage();

  static const token = 'token';

  static bool isLoggedIn() => box.hasData(token);

  static void saveToken(String value) => box.write(token, value);

  static void logout() => box.erase();
}
