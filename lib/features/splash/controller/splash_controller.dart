import 'package:get/get.dart';
import '../../../app/routes/app_router.dart';
import '../../../app/storage/app_storage.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      if (AppStorage.isLoggedIn()) {
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }
}
