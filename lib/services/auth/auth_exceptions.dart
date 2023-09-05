// login Expection

class UserNotFoundAuthException implements Exception {}

class WorngPasswordAuthException implements Exception {}

// REGISTER EXPECTION

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// Generic expection

class GenericAuthException implements Exception {}

class UserNotLoggedAuthException implements Exception {}
