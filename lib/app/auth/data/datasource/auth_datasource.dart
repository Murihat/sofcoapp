import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../helper/password_hash_helper.dart';

class AuthDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  /// LOGIN
  Future<Map<String, dynamic>> login(String email, String password) async {
    // ambil user berdasarkan email saja
    final user = await _client
        .from('sofco_user')
        .select()
        .eq('email', email)
        .maybeSingle();

    if (user == null) {
      throw const AuthException('Invalid email or password');
    }

    final hashedPassword = user['password'];

    // verify password
    final isValid = PasswordHashHelper.verify(password, hashedPassword);

    if (!isValid) {
      throw const AuthException('Invalid email or password');
    }

    return user;
  }

  /// REGISTER
  Future<void> register(String name, String email, String password) async {
    // cek email sudah ada
    final existingUser = await _client
        .from('sofco_user')
        .select('id')
        .eq('email', email)
        .maybeSingle();

    if (existingUser != null) {
      throw const AuthException('Email already registered');
    }

    // hash password
    final hashedPassword = PasswordHashHelper.hash(password);

    // insert user
    await _client.from('sofco_user').insert({
      'full_name': name,
      'email': email,
      'password': hashedPassword,
    });
  }
}
