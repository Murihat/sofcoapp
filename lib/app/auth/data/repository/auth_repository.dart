import '../../../storage/app_storage.dart';
import '../../domain/interface/auth_interface.dart';
import '../datasource/auth_datasource.dart';

class AuthRepository implements AuthInterface {
  final AuthDatasource datasource;

  AuthRepository(this.datasource);

  @override
  Future<void> login(String email, String password) async {
    final user = await datasource.login(email, password);
    AppStorage.saveToken(user['id'].toString());
  }

  @override
  Future<void> register(String name, String email, String password) async {
    await datasource.register(name, email, password);
  }
}
