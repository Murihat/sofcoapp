import 'package:get/get.dart';
import '../../../app/auth/data/datasource/auth_datasource.dart';
import '../../../app/auth/data/repository/auth_repository.dart';
import '../controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthDatasource());
    Get.lazyPut(() => AuthRepository(Get.find()));
    Get.lazyPut(() => AuthController(Get.find()));
  }
}
