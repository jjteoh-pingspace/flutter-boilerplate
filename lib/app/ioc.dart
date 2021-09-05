import 'package:equatable/equatable.dart';
import 'package:my_authentication/models/user.dart';

enum AppStatus { unknown, authenticated, unauthenticated }

class AppState extends Equatable {
  const AppState._(
      {required this.status, this.appUser = User.empty});

  const AppState.unknown() : this._(status: AppStatus.unknown);

  const AppState.authenticated(User user)
      : this._(status: AppStatus.authenticated, appUser: user);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User appUser;

  @override
  List<Object?> get props => [status, appUser];
}
