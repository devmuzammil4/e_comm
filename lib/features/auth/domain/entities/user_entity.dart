import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing a premium verified user profile.
/// Completely decoupled from database schemas and authentication provider engines.
class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String? profileImageUrl;
  final String accessToken;
  final bool isEmailVerified;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    this.profileImageUrl,
    required this.accessToken,
    required this.isEmailVerified,
  });

  /// Premium Analytics Helper Business Logic.
  /// Determines if the active user profile has incomplete information configurations.
  bool get hasIncompleteProfile => displayName.trim().isEmpty;

  /// Syntactic Sugar check for membership authorization parameters.
  String get dynamicGreetingToken => "Welcome back, $displayName";

  /// Immutable tracking state modifier utility method.
  UserEntity copyWith({
    String? displayName,
    String? profileImageUrl,
    String? accessToken,
    bool? isEmailVerified,
  }) {
    return UserEntity(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      accessToken: accessToken ?? this.accessToken,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    profileImageUrl,
    accessToken,
    isEmailVerified,
  ];
}
