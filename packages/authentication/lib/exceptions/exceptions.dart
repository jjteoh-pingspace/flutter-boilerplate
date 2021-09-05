/// Fail to sign up
class SignUpFailure implements Exception {}

/// Fail to sign in with email and password
class SignInWithEmailPasswordFailure implements Exception {}

/// Fail to sign in with Google
class SignInWithGoogleFailure implements Exception {}

/// Fail to sign in with Facebook
class SignInWithFacebookFailure implements Exception {}

/// Fail to sign out
class SignOutFailure implements Exception {}

/// Fail to check email existed
class EmailCheckingRequestFailure implements Exception {}
