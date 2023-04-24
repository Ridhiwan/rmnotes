import 'package:flutter_test/flutter_test.dart';
import 'package:rmnotes/services/auth/auth_exceptions.dart';
import 'package:rmnotes/services/auth/auth_provider.dart';
import 'package:rmnotes/services/auth/auth_user.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('Should not be initialized at the beginning', () => expect(
        provider.isInitialized, false));

    test("Can't logout if not initialized", () => expect(
      provider.logOut(),
    throwsA(const TypeMatcher<NotInitializedException>()),
    ));

    test('Should be able to be initialized', () async{
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null', () => expect(
      provider.currentUser, null
    ));
    
    test('Should be able to initialize in less than 3 seconds', () async{
      await provider.initialize();
      expect(provider.isInitialized, true);
    },
        timeout: const Timeout(Duration(seconds: 3))
    );
    
    test('Create user should delegate to login function', () async{
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'ukiribi',
      );
      expect(
          badEmailUser,
          throwsA(const TypeMatcher<UserNotFondAuthException>()),);

      final badPasswordUser = provider.createUser(
        email: '23@bar.com',
        password: 'foobar',
      );
      expect(
          badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()),);

      final user = await provider.createUser(
        email: 'email',
        password: 'password',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    
    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    
    test('User should be able to log out and log in again', () async{
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password',);
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });

}
class NotInitializedException implements Exception{}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async{
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 2));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async{
    await Future.delayed(const Duration(seconds: 2));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFondAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async{
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFondAuthException();
    await Future.delayed(const Duration(seconds: 2));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async{
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFondAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }

}