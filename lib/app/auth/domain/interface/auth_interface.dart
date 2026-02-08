abstract class AuthInterface {
  Future<void> login(String email, String password);
  Future<void> register(String name, String email, String password);
}
