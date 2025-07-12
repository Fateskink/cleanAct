import 'base_entity.dart';

/// Course difficulty levels
enum CourseDifficulty { beginner, intermediate, advanced, expert }

/// Course status
enum CourseStatus { draft, published, archived, suspended }

/// Base Course entity with only essential fields shared across all features
/// This follows the same pattern as UserBase
class CourseBase extends BaseEntity {
  final String title;
  final String description;
  final String instructorId;
  final CourseDifficulty difficulty;
  final CourseStatus status;
  final double price;
  final int durationHours;
  final String? imageUrl;

  const CourseBase({
    required String id,
    required DateTime createdAt,
    DateTime? updatedAt,
    required this.title,
    required this.description,
    required this.instructorId,
    required this.difficulty,
    required this.status,
    required this.price,
    required this.durationHours,
    this.imageUrl,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Check if course is free
  bool get isFree => price == 0;

  /// Check if course is published
  bool get isPublished => status == CourseStatus.published;

  /// Get age of entity in days
  int get ageInDays {
    return DateTime.now().difference(createdAt).inDays;
  }

  /// Check if entity was recently created (within 7 days)
  bool get isRecentlyCreated {
    return ageInDays <= 7;
  }

  /// Check if course is available for enrollment
  bool get isAvailableForEnrollment =>
      status == CourseStatus.published && !isRecentlyCreated;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        instructorId,
        difficulty,
        status,
        price,
        durationHours,
        imageUrl,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'CourseBase(id: $id, title: $title, difficulty: $difficulty, status: $status)';
  }
}
