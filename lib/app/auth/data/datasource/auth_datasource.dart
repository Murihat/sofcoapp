import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../helper/password_hash_helper.dart';

class AuthDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final user = await _client
        .from('sofco_user')
        .select()
        .eq('email', email)
        .maybeSingle();

    if (user == null) {
      throw const AuthException('Invalid email or password');
    }

    final hashedPassword = user['password'];

    final isValid = PasswordHashHelper.verify(password, hashedPassword);

    if (!isValid) {
      throw const AuthException('Invalid email or password');
    }

    return user;
  }

  Future<void> register(String name, String email, String password) async {
    final existingUser = await _client
        .from('sofco_user')
        .select('id')
        .eq('email', email)
        .maybeSingle();

    if (existingUser != null) {
      throw const AuthException('Email already registered');
    }

    final hashedPassword = PasswordHashHelper.hash(password);

    await _client.from('sofco_user').insert({
      'full_name': name,
      'email': email,
      'password': hashedPassword,
    });
  }
}
