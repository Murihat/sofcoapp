import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app/auth/data/repository/auth_repository.dart';
import '../../../app/helper/error_snackbar_helper.dart';
import '../../../app/helper/success_snackbar_helper.dart';
import '../../../app/routes/app_router.dart';

class AuthController extends GetxController {
  final AuthRepository repo;

  AuthController(this.repo);

  final loading = false.obs;

  Future<void> login(String email, String password) async {
    try {
      loading.value = true;
      final user = await repo.login(email, password);
      print('user_login: ${user.id} - ${user.fullName} - ${user.email}');
      SuccessSnackbarHelper.show('Login successful');
      Get.offAllNamed(Routes.DASHBOARD);
    } on AuthException catch (e) {
      ErrorSnackbarHelper.show(e.message);
    } catch (e) {
      print(e.toString());
      ErrorSnackbarHelper.show('Something went wrong. Please try again.');
    } finally {
      loading.value = false;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      loading.value = true;
      await repo.register(name, email, password);
      Get.back();
      SuccessSnackbarHelper.show('Registration successful, Please Login.');
    } on AuthException catch (e) {
      ErrorSnackbarHelper.show(e.message);
    } catch (e) {
      print(e.toString());
      ErrorSnackbarHelper.show('Something went wrong. Please try again.');
    } finally {
      loading.value = false;
    }
  }
}
