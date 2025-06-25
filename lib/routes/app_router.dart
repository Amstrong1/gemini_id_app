import 'dart:math';

import 'package:go_router/go_router.dart';
import 'package:id_app/presentation/screens/auth/forgot_password_screen.dart';
import 'package:id_app/presentation/screens/history_screen.dart';
import 'package:id_app/presentation/screens/home_screen.dart';
import 'package:id_app/presentation/screens/auth/login_screen.dart';
import 'package:id_app/presentation/screens/auth/new_password_screen.dart';
import 'package:id_app/presentation/screens/auth/register_screen.dart';
import 'package:id_app/presentation/screens/identification/agency_selection.dart';
import 'package:id_app/presentation/screens/identification/agency_verification_screen.dart';
import 'package:id_app/presentation/screens/identification/tracking_code.dart';
import 'package:id_app/presentation/screens/identification/upload_doc.dart';
import 'package:id_app/presentation/screens/identification/verification_method.dart';
import 'package:id_app/presentation/screens/splash_screen.dart';
import 'package:id_app/presentation/screens/start_screen.dart';

// generate callerID of local user
final String selfCallerID = Random().nextInt(999999).toString().padLeft(6, '0');

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const NewPasswordScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/agency-selection',
      builder: (context, state) => const AgencySelectionScreen(),
    ),
    GoRoute(
      path: '/tracking-code',
      builder: (context, state) => const TrackingCodeScreen(),
    ),
    GoRoute(
      path: '/verification-method',
      builder: (context, state) =>
          VerificationMethodScreen(selfCallerId: selfCallerID),
    ),
    GoRoute(
      path: '/upload-doc',
      builder: (context, state) => UploadDocumentScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => VerificationHistoryScreen(),
    ),
    GoRoute(
      path: '/in-person-verification',
      builder: (context, state) => const AgencyVerificationScreen(),
    ),
  ],
);
