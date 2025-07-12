import '../../../../core/entities/course_base.dart';

/// Course entity specific to Academy feature
/// Contains learning progress and enrollment data
class CourseWithProgress extends CourseBase {
  final double progress; // 0.0 to 1.0
  final DateTime? enrolledAt;
  final DateTime? completedAt;
  final int totalLessons;
  final int completedLessons;
  final List<String> completedLessonIds;
  final DateTime? lastAccessedAt;
  final Map<String, dynamic>? userNotes;

  const CourseWithProgress({
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
    this.progress = 0.0,
    this.enrolledAt,
    this.completedAt,
    this.totalLessons = 0,
    this.completedLessons = 0,
    this.completedLessonIds = const [],
    this.lastAccessedAt,
    this.userNotes,
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

  /// Check if user is enrolled in this course
  bool get isEnrolled => enrolledAt != null;

  /// Check if course is completed
  bool get isCompleted => completedAt != null || progress >= 1.0;

  /// Check if course is in progress
  bool get isInProgress => isEnrolled && !isCompleted && progress > 0;

  /// Get progress percentage
  int get progressPercentage => (progress * 100).round();

  /// Check if user has started the course
  bool get hasStarted => progress > 0 || lastAccessedAt != null;

  /// Get estimated time to complete (in hours)
  double get estimatedTimeToComplete => durationHours * (1 - progress);

  @override
  List<Object?> get props => [
        ...super.props,
        progress,
        enrolledAt,
        completedAt,
        totalLessons,
        completedLessons,
        completedLessonIds,
        lastAccessedAt,
        userNotes,
      ];

  @override
  String toString() {
    return 'CourseWithProgress(id: $id, title: $title, progress: ${progressPercentage}%, isCompleted: $isCompleted)';
  }
}
