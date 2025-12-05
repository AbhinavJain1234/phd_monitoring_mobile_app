# PhD Monitoring Mobile App

A comprehensive Flutter-based mobile application for monitoring and managing PhD student workflows, submissions, and administrative tasks. This app facilitates seamless interaction between students, supervisors, and administrators in academic institutions.

## 📱 Overview

The PhD Monitoring Mobile App is designed to streamline the PhD student lifecycle management process. It provides role-based access for students, supervisors, and administrators to handle various academic workflows including supervisor allocation, status changes, IRB constitutions, revisions, and publications tracking.

## ✨ Features

### Core Functionality
- **Role-Based Authentication**: Secure login system with multi-role support (Student, Supervisor, Admin)
- **Dashboard**: Personalized dashboards based on user roles
- **Form Management**: Digital submission and tracking of various academic forms
- **Notification System**: Real-time notifications for form updates and approvals
- **Profile Management**: User profile viewing and management
- **Publication Tracking**: Monitor and manage student publications

### Form Types
- **Supervisor Allocation**: Request and manage supervisor assignments
- **Supervisor Change**: Handle supervisor change requests
- **Status Change**: Track and update PhD status changes
- **IRB Constitution**: Submit and manage IRB constitution forms
- **IRB Revision**: Handle IRB revision submissions
- **Form Submissions**: View submission history and status

### User Experience
- **Responsive UI**: Adaptive layouts for different screen sizes
- **Material Design**: Modern, clean interface following Material Design guidelines
- **Dark Mode Support**: Theme customization options
- **Smooth Navigation**: Go Router-based navigation with deep linking support
- **Document Viewing**: In-app document viewing and downloading capabilities

## 🛠️ Tech Stack

### Framework & Language
- **Flutter** (SDK 3.5.0+)
- **Dart**

### Key Dependencies
- **State Management**: `provider` (^6.1.2)
- **Navigation**: `go_router` (^14.3.0)
- **UI Components**: 
  - `flutter_screenutil` (^5.9.3) - Responsive sizing
  - `google_fonts` (^6.2.1) - Custom typography
  - `percent_indicator` (^4.2.3) - Progress indicators
  - `carousel_slider` (^5.0.0) - Image carousels
  - `auto_size_text` (^3.0.0) - Adaptive text sizing
- **Networking**: 
  - `http` (^1.2.2) - HTTP requests
  - `dio` (^5.0.0) - Advanced HTTP client
- **Storage**: 
  - `shared_preferences` (^2.3.2) - Local data persistence
  - `path_provider` (^2.0.15) - File system paths
- **Utilities**:
  - `intl` (^0.19.0) - Internationalization and date formatting
  - `url_launcher` (^6.2.5) - External URL handling
  - `open_file` (^3.5.10) - File opening functionality
  - `fluttertoast` (^8.0.9) - Toast notifications

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point
├── configs/
│   └── form_config.dart          # Form configuration settings
├── constants/
│   └── url.dart                  # API endpoints and URLs
├── functions/
│   ├── fetch_data.dart           # API data fetching utilities
│   ├── file_at_url.dart          # File download functions
│   ├── format_date_time.dart     # Date/time formatting
│   └── opendocument.dart         # Document opening utilities
├── model/
│   ├── user.dart                 # User data model
│   └── user_role.dart            # User role definitions
├── providers/
│   └── user_provider.dart        # User state management
├── routes/
│   └── router.dart               # App routing configuration
├── screens/
│   ├── login_screen/             # Authentication screens
│   ├── home_screen/              # Home and navigation
│   │   ├── dashboard_screen/     # Main dashboard views
│   │   ├── notification_screen/  # Notifications
│   │   ├── profile_screen/       # User profile
│   │   └── app_drawer/           # Navigation drawer
│   ├── forms/                    # Form-related screens
│   │   ├── forms_screen.dart
│   │   ├── form_submission_list_screen.dart
│   │   ├── supervisor_allocation/
│   │   ├── supervisor_change/
│   │   ├── status_change/
│   │   ├── irb_constitution/
│   │   ├── irb_revision/
│   │   └── widgets/              # Reusable form widgets
│   └── publications/             # Publication management
├── theme/
│   ├── app_colors.dart           # Color palette
│   └── app_theme.dart            # Theme configuration
└── widgets/
    ├── build_test_feild.dart     # Custom text field
    └── student_data_table.dart   # Data table component
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.5.0 or higher
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- An Android or iOS device/emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/AbhinavJain1234/phd_monitoring_mobile_app.git
   cd phd_monitoring_mobile_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoint**
   - Update the `SERVER_URL` in `lib/constants/url.dart` with your backend API URL

4. **Run the app**
   ```bash
   # For development
   flutter run

   # For specific device
   flutter run -d <device_id>

   # For release build
   flutter run --release
   ```

### Building

#### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

## 🔧 Configuration

### API Configuration
Edit `lib/constants/url.dart` to configure your backend server:
```dart
const SERVER_URL = 'https://your-api-endpoint.com/api';
```

### Theme Customization
Modify `lib/theme/app_colors.dart` and `lib/theme/app_theme.dart` to customize the app's appearance.

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ⚠️ Web (Basic support available)
- ⚠️ Linux (Basic support available)
- ⚠️ macOS (Basic support available)
- ⚠️ Windows (Basic support available)

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## 📝 User Roles

### Student
- View personalized dashboard
- Submit forms (supervisor allocation, status change, etc.)
- Track form submission status
- Manage publications
- Receive notifications

### Supervisor
- Review student submissions
- Provide recommendations
- Approve/reject requests
- View assigned students
- Access student details

### Administrator
- Manage all submissions
- Override approvals
- View system-wide analytics
- Manage user roles

## 🔐 Authentication

The app uses token-based authentication with:
- Secure login with email and password
- Session persistence using SharedPreferences
- Role-based access control
- Automatic token refresh
