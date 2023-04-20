// Login exceptions
class UserNotFondAuthException implements Exception{}
class WrongPasswordAuthException implements Exception{}

// register Exceptions
class WeakPasswordAuthException implements Exception{}
class EmailAlreadyInUseAuthException implements Exception{}
class InvalidEmailAuthException implements Exception{}

// generic exceptions
class GenericAuthException implements Exception{}
class UserNotLoggedInAuthException implements Exception{}