import '../../../storage/app_storage.dart';
import '../../domain/interface/auth_interface.dart';
import '../datasource/auth_datasource.dart';
import '../model/user_model.dart';

class AuthRepository implements AuthInterface {
  final AuthDatasource datasource;

  AuthRepository(this.datasource);

  @override
  Future<UserModel> login(String email, String password) async {
    final userMap = await datasource.login(email, password);

    final user = UserModel.fromJson(userMap);

    AppStorage.saveToken(user.id.toString());
    AppStorage.saveUser(user.toJson());

    return user;
  }

  @override
  Future<void> register(String name, String email, String password) async {
    await datasource.register(name, email, password);
  }
}
