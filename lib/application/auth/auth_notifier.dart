

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/failure/failure.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthState {
  final bool isAuthenticated;
  final Option<Failure> failure;

  AuthState({required this.isAuthenticated, required this.failure});

  AuthState copyWith({bool? isAuthenticated, Option<Failure>? failure}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      failure: failure ?? this.failure,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository)
      : super(AuthState(isAuthenticated: _authRepository.getCurrentUserId() != null, failure: none()));

  Future<void> signIn(String email, String password) async {
    final result = await _authRepository.signInWithEmail(email, password);
    state = result.fold(
      (failure) => state.copyWith(isAuthenticated: false, failure: some(failure)),
      (_) => state.copyWith(isAuthenticated: true, failure: none()),
    );
  }

  Future<void> signUp(String email, String password) async {
    final result = await _authRepository.signUpWithEmail(email, password);
    state = result.fold(
      (failure) => state.copyWith(isAuthenticated: false, failure: some(failure)),
      (_) => state.copyWith(isAuthenticated: true, failure: none()),
    );
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    state = state.copyWith(isAuthenticated: false, failure: none());
  }
}