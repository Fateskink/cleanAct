import '../../../../core/entities/course_base.dart';

/// Course entity specific to Course Management feature
/// Contains analytics and management data for instructors/admins
class CourseWithAnalytics extends CourseBase {
  final int totalEnrollments;
  final int activeStudents;
  final int completedStudents;
  final double averageRating;
  final int totalReviews;
  final double revenue;
  final Map<String, int> enrollmentsByMonth;
  final List<String> tags;
  final DateTime? lastModifiedBy;
  final String? lastModifierName;
  final bool isPromoted;
  final int viewCount;

  const CourseWithAnalytics({
    required String id,
    required DateTime createdAt,
    DateTime? updatedAt,
    required String title,
    required String description,
    required String instructorId,
    required CourseDifficulty difficulty,
    required CourseStatus status,
    required double price,
    required int durationHours,
    String? imageUrl,
    this.totalEnrollments = 0,
    this.activeStudents = 0,
    this.completedStudents = 0,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.revenue = 0.0,
    this.enrollmentsByMonth = const {},
    this.tags = const [],
    this.lastModifiedBy,
    this.lastModifierName,
    this.isPromoted = false,
    this.viewCount = 0,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          title: title,
          description: description,
          instructorId: instructorId,
          difficulty: difficulty,
          status: status,
          price: price,
          durationHours: durationHours,
          imageUrl: imageUrl,
        );

  /// Get completion rate as percentage
  double get completionRate {
    if (totalEnrollments == 0) return 0.0;
    return (completedStudents / totalEnrollments) * 100;
  }

  /// Check if course is popular (high enrollment)
  bool get isPopular => totalEnrollments > 100;

  /// Check if course has good rating
  bool get hasGoodRating => averageRating >= 4.0 && totalReviews >= 10;

  /// Get revenue per enrollment
  double get revenuePerEnrollment {
    if (totalEnrollments == 0) return 0.0;
    return revenue / totalEnrollments;
  }

  /// Check if course needs attention (low completion rate)
  bool get needsAttention => completionRate < 50 && totalEnrollments > 10;

  @override
  List<Object?> get props => [
        ...super.props,
        totalEnrollments,
        activeStudents,
        completedStudents,
        averageRating,
        totalReviews,
        revenue,
        enrollmentsByMonth,
        tags,
        lastModifiedBy,
        lastModifierName,
        isPromoted,
        viewCount,
      ];

  @override
  String toString() {
    return 'CourseWithAnalytics(id: $id, title: $title, enrollments: $totalEnrollments, rating: $averageRating)';
  }
}
