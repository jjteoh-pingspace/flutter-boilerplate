import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_boilerplate/app/ioc.dart';
import 'package:my_authentication/models/user.dart';
import 'package:my_authentication/repositories/authentication_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticationRepository authenticatopnRepo})
      : _authenticationRepo = authenticatopnRepo,
        super(authenticatopnRepo.currentUser.isNotEmpty
            ? AppState.authenticated(authenticatopnRepo.currentUser)
            : const AppState.unauthenticated()) {
    _userSubscription = _authenticationRepo.user.listen(_onUserChanged);
  }

  final AuthenticationRepository _authenticationRepo;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(User user) => add(AppUserChanged(user));

  Future<AppState> _mapAppUserChangedToState(AppUserChanged event) async {
    if (event.user.isEmpty) {
      return const AppState.unauthenticated();
    }
    return AppState.authenticated(event.user);
  }

  Future<AppState> _mapAppUserLoggedOutToState() async {
    await _authenticationRepo.signOut();

    return const AppState.unauthenticated();
  }

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is AppUserChanged) {
      yield await _mapAppUserChangedToState(event);
    } else if (event is AppUserLogoutRequested) {
      yield await _mapAppUserLoggedOutToState();
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}

