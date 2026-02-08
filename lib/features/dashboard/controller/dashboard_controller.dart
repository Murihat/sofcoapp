import 'package:get/get.dart';
import '../../../app/auth/data/model/user_model.dart';
import '../../../app/routes/app_router.dart';
import '../../../app/storage/app_storage.dart';

class DashboardController extends GetxController {
  late final UserModel user;

  @override
  void onInit() {
    super.onInit();

    final data = AppStorage.getUser;
    if (data == null) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    user = UserModel.fromJson(data);
  }

  void logout() {
    AppStorage.logout();
    Get.offAllNamed(Routes.LOGIN);
  }
}
