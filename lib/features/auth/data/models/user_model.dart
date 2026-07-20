import '../../domain/entities/user_entity.dart';

/// Data Layer representation of a authenticated User profile.
/// Implements bidirectional JSON mapping to protect domain rules from API database format anomalies.
class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.displayName,
    super.profileImageUrl,
    required super.accessToken,
    required super.isEmailVerified,
  });

  /// Factory constructor to safely extract user profile parameters from API mapping blocks.
  /// Enforces runtime fallback data settings to eliminate zero null-pointer crash states.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid']?.toString() ?? json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      displayName: json['display_name']?.toString() ?? json['name']?.toString() ?? 'Sports Member',
      profileImageUrl: json['profile_image_url']?.toString(),
      accessToken: json['access_token']?.toString() ?? '',
      isEmailVerified: json['is_email_verified'] is bool
          ? json['is_email_verified'] as bool
          : (json['is_email_verified']?.toString().toLowerCase() == 'true'),
    );
  }

  /// Maps the analytical configuration properties back down into an infrastructure JSON map.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'display_name': displayName,
      'profile_image_url': profileImageUrl,
      'access_token': accessToken,
      'is_email_verified': isEmailVerified,
    };
  }

  /// Adaptability converter factory to safely package domain profiles for tracking operations.
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      displayName: entity.displayName,
      profileImageUrl: entity.profileImageUrl,
      accessToken: entity.accessToken,
      isEmailVerified: entity.isEmailVerified,
    );
  }
}
