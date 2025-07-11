# CleanAct - Billiard Ecosystem App

## 📋 Project Overview
A comprehensive billiard platform featuring:
- 🎓 **Academy**: Billiard courses and learning management
- 🏆 **Tournament**: Professional billiard competitions (Future)
- 👥 **SNS**: Social network for billiard players (Future)

Currently focusing on **Academy Module** development.

## 🏗️ Clean Architecture Structure

```
lib/
├── core/                          # Shared across all modules
│   ├── constants/                 # App constants, API endpoints
│   ├── errors/                    # Custom exceptions, failures
│   ├── network/                   # HTTP client, network info
│   ├── theme/                     # App theme, colors, text styles
│   ├── utils/                     # Helper functions, extensions
│   ├── widgets/                   # Reusable UI components
│   └── injection_container.dart   # Dependency injection setup
├── features/
│   ├── authentication/           # Login, register, profile
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── user.dart
│   │   │   │   └── auth_result.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── register_usecase.dart
│   │   │       └── get_current_user_usecase.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart
│   │   │   │   └── auth_result_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   ├── register_page.dart
│   │       │   └── profile_page.dart
│   │       └── widgets/
│   │           ├── auth_form_field.dart
│   │           └── auth_button.dart
│   ├── academy/                  # Main learning module
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── course.dart
│   │   │   │   ├── lesson.dart
│   │   │   │   ├── assignment.dart
│   │   │   │   ├── submission.dart
│   │   │   │   └── enrollment.dart
│   │   │   ├── repositories/
│   │   │   │   ├── course_repository.dart
│   │   │   │   ├── enrollment_repository.dart
│   │   │   │   └── assignment_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_courses_usecase.dart
│   │   │       ├── enroll_course_usecase.dart
│   │   │       ├── get_course_details_usecase.dart
│   │   │       ├── submit_assignment_usecase.dart
│   │   │       ├── get_submissions_usecase.dart
│   │   │       └── grade_submission_usecase.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── course_remote_datasource.dart
│   │   │   │   ├── course_local_datasource.dart
│   │   │   │   ├── enrollment_remote_datasource.dart
│   │   │   │   └── assignment_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── course_model.dart
│   │   │   │   ├── lesson_model.dart
│   │   │   │   ├── assignment_model.dart
│   │   │   │   ├── submission_model.dart
│   │   │   │   └── enrollment_model.dart
│   │   │   └── repositories/
│   │   │       ├── course_repository_impl.dart
│   │   │       ├── enrollment_repository_impl.dart
│   │   │       └── assignment_repository_impl.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── course/
│   │       │   │   ├── course_bloc.dart
│   │       │   │   ├── course_event.dart
│   │       │   │   └── course_state.dart
│   │       │   ├── enrollment/
│   │       │   │   ├── enrollment_bloc.dart
│   │       │   │   ├── enrollment_event.dart
│   │       │   │   └── enrollment_state.dart
│   │       │   └── assignment/
│   │       │       ├── assignment_bloc.dart
│   │       │       ├── assignment_event.dart
│   │       │       └── assignment_state.dart
│   │       ├── pages/
│   │       │   ├── course_list_page.dart
│   │       │   ├── course_detail_page.dart
│   │       │   ├── lesson_page.dart
│   │       │   ├── assignment_page.dart
│   │       │   ├── submission_page.dart
│   │       │   └── instructor_dashboard_page.dart
│   │       └── widgets/
│   │           ├── course_card.dart
│   │           ├── lesson_tile.dart
│   │           ├── assignment_card.dart
│   │           ├── submission_item.dart
│   │           └── progress_indicator.dart
│   ├── tournament/               # Future module
│   │   └── presentation/
│   │       └── pages/
│   │           └── tournament_placeholder_page.dart
│   └── sns/                      # Future module
│       └── presentation/
│           └── pages/
│               └── sns_placeholder_page.dart
├── main.dart
└── app.dart                     # App configuration, routing
```

## 🎓 Academy Course Enrollment Flow

### 1. **User Journey: Course Enrollment**

```
📱 User Opens App
    ↓
🔐 Authentication Check
    ↓
🏠 Main Dashboard
    ↓
🎓 Academy Module
    ↓
📚 Browse Courses List
    ↓ (User selects course)
📖 Course Details Page
    ├── Course Info
    ├── Instructor Details
    ├── Lessons Preview
    └── Enrollment Button
    ↓ (User clicks Enroll)
✅ Enrollment Confirmation
    ↓
📝 Access Course Content
    ├── Watch Lessons
    ├── Complete Assignments
    └── Track Progress
```

### 2. **Technical Flow Implementation**

#### **Step 1: Course Discovery**
```dart
// User opens Academy module
CourseBloc.add(LoadCoursesEvent())
    ↓
GetCoursesUseCase.call()
    ↓
CourseRepository.getCourses()
    ↓
CourseRemoteDataSource.fetchCourses()
    ↓
Display CourseListPage with course cards
```

#### **Step 2: Course Details**
```dart
// User taps on course card
Navigator.push(CourseDetailPage(courseId))
    ↓
CourseBloc.add(LoadCourseDetailsEvent(courseId))
    ↓
GetCourseDetailsUseCase.call(courseId)
    ↓
Display course info, lessons, instructor details
```

#### **Step 3: Enrollment Process**
```dart
// User taps "Enroll Now" button
EnrollmentBloc.add(EnrollCourseEvent(courseId, userId))
    ↓
EnrollCourseUseCase.call(courseId, userId)
    ↓
EnrollmentRepository.enrollUserInCourse()
    ↓
Success: Navigate to Course Content
Error: Show error message
```

#### **Step 4: Assignment Submission**
```dart
// User completes assignment
AssignmentBloc.add(SubmitAssignmentEvent(assignmentData))
    ↓
SubmitAssignmentUseCase.call(assignmentData)
    ↓
AssignmentRepository.submitAssignment()
    ↓
Notify instructor for review
```

### 3. **Data Flow Architecture**

```
📱 UI Layer (BLoC Pattern)
    ↕️
🎯 Domain Layer (Use Cases)
    ↕️
💾 Data Layer (Repository + DataSources)
    ↕️
🌐 External APIs / Local Storage
```

### 4. **Key Entities Structure**

```dart
// Core Academy Entities
class Course {
  final String id;
  final String title;
  final String description;
  final String instructorId;
  final List<Lesson> lessons;
  final double price;
  final int duration; // in hours
  final String difficultyLevel;
  final String imageUrl;
}

class Enrollment {
  final String id;
  final String userId;
  final String courseId;
  final DateTime enrolledAt;
  final double progress; // 0.0 to 1.0
  final EnrollmentStatus status;
}

class Assignment {
  final String id;
  final String lessonId;
  final String title;
  final String description;
  final AssignmentType type; // video, quiz, practical
  final DateTime dueDate;
  final int maxScore;
}

class Submission {
  final String id;
  final String assignmentId;
  final String userId;
  final String content; // file path, text, video url
  final DateTime submittedAt;
  final int? score;
  final String? feedback;
  final SubmissionStatus status;
}
```

### 5. **Module Communication**

Các module sẽ communicate thông qua:
- **Shared Events**: Using EventBus for cross-module communication
- **Navigation Service**: Centralized navigation management
- **Shared State**: User authentication state, app configuration

Cấu trúc này cho phép:
✅ **Scalability**: Dễ dàng thêm Tournament và SNS modules
✅ **Maintainability**: Mỗi feature độc lập, dễ debug
✅ **Testability**: Từng layer có thể test riêng biệt
✅ **Team Development**: Nhiều dev có thể làm song song

Anh có muốn em bắt đầu implement cụ thể từ authentication module hay academy module trước không?
