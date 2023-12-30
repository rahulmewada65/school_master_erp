import 'package:go_router/go_router.dart';
import 'package:school_master_erp/providers/user_data_provider.dart';
import 'package:school_master_erp/views/screens/buttons_screen.dart';
import 'package:school_master_erp/views/screens/classes_screen/class_profile.dart';
import 'package:school_master_erp/views/screens/classes_screen/class_screen.dart';
import 'package:school_master_erp/views/screens/classes_screen/new_class_screen.dart';
import 'package:school_master_erp/views/screens/colors_screen.dart';
import 'package:school_master_erp/views/screens/exam_screen/exam_profile.dart';
import 'package:school_master_erp/views/screens/exam_screen/exam_screen.dart';
import 'package:school_master_erp/views/screens/exam_screen/new_exam_screen.dart';
import 'package:school_master_erp/views/screens/fees_screen/create_fees_stacture.dart';
import 'package:school_master_erp/views/screens/fees_screen/crud_detail_screen.dart';
import 'package:school_master_erp/views/screens/fees_screen/fee_screen.dart';
import 'package:school_master_erp/views/screens/fees_screen/stacture_screen.dart';
import 'package:school_master_erp/views/screens/student_screen/crud_screen.dart';
import 'package:school_master_erp/views/screens/dashboard_screen.dart';
import 'package:school_master_erp/views/screens/dialogs_screen.dart';
import 'package:school_master_erp/views/screens/error_screen.dart';
import 'package:school_master_erp/views/screens/student_screen/form_screen.dart';
import 'package:school_master_erp/views/screens/general_ui_screen.dart';
import 'package:school_master_erp/views/screens/login_screen.dart';
import 'package:school_master_erp/views/screens/logout_screen.dart';
import 'package:school_master_erp/views/screens/my_profile_screen.dart';
import 'package:school_master_erp/views/screens/pdf-page/pdf_screen.dart';
import 'package:school_master_erp/views/screens/register_screen.dart';
import 'package:school_master_erp/views/screens/student_screen/student_screen.dart';
import 'package:school_master_erp/views/screens/subject_screen/new_subject_screen.dart';
import 'package:school_master_erp/views/screens/subject_screen/subject_screen.dart';
import 'package:school_master_erp/views/screens/text_screen.dart';

class RouteUri {
  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String student = '/student';
  static const String myProfile = '/my-profile';
  static const String logout = '/logout';
  static const String form = '/form';
  static const String generalUi = '/general-ui';
  static const String colors = '/colors';
  static const String text = '/text';
  static const String buttons = '/buttons';
  static const String dialogs = '/dialogs';
  static const String error404 = '/404';
  static const String login = '/login';
  static const String register = '/register';
  static const String crud = '/crud';
  static const String feeScreen = '/fee_screen';
  static const String create_structure = '/create_structure';
  static const String structure_screen = '/structure_screen';
  static const String classes = '/classes';
  static const String crudDetail = '/crud-detail';
  static const String classScreen = '/add_class';
  static const String pdfscreen = '/pdf-screen';
  static const String subject_screen = '/subject_screen';
  static const String add_subject = '/add_subject';
  static const String exam_screen = '/exam_screen';
  static const String add_exam = '/add_exam';
  static const String teacher_screen = '/teacher_screen';
  static const String add_teacher = '/add_teacher';
  static const String class_profile = '/class_profile';
  static const String exam_profile = '/exam_profile';
}

const List<String> unrestrictedRoutes = [
  RouteUri.error404,
  RouteUri.logout,
  RouteUri.login, // Remove this line for actual authentication flow.
  RouteUri.register, // Remove this line for actual authentication flow.
];

const List<String> publicRoutes = [
  // RouteUri.login, // Enable this line for actual authentication flow.
  // RouteUri.register, // Enable this line for actual authentication flow.
];

GoRouter appRouter(UserDataProvider userDataProvider) {
  return GoRouter(
    initialLocation: RouteUri.home,
    errorPageBuilder: (context, state) => NoTransitionPage<void>(
      key: state.pageKey,
      child: const ErrorScreen(),
    ),
    routes: [
      GoRoute(
        path: RouteUri.home,
        redirect: (state) => RouteUri.dashboard,
      ),
      GoRoute(
        path: RouteUri.dashboard,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const DashboardScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.student,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: StudentScreen(id: state.queryParams['id'] ?? ''),
        ),
      ),
      GoRoute(
        path: RouteUri.feeScreen,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const FeeScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.classes,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const ClassScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.subject_screen,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const SubjectScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.myProfile,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const MyProfileScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.logout,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const LogoutScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.create_structure,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const CreateStructure(),
        ),
      ),
      GoRoute(
        path: RouteUri.structure_screen,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const StactureScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.form,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: FormScreen(id: state.queryParams['id'] ?? ''),
        ),
      ),
      GoRoute(
        path: RouteUri.add_subject,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: AddSubjectScreen(id: state.queryParams['id'] ?? ''),
        ),
      ),
      GoRoute(
        path: RouteUri.exam_screen,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const ExamScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.add_exam,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: AddExamScreen(id: state.queryParams['id'] ?? ''),
        ),
      ),
      GoRoute(
        path: RouteUri.teacher_screen,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const ExamScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.add_teacher,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: AddExamScreen(id: state.queryParams['id'] ?? ''),
        ),
      ),
      GoRoute(
        path: RouteUri.generalUi,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const GeneralUiScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.colors,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const ColorsScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.text,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const TextScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.buttons,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const ButtonsScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.dialogs,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const DialogsScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.login,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.register,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const RegisterScreen(),
          );
        },
      ),
      GoRoute(
        path: RouteUri.crud,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const CrudScreen(),
          );
        },
      ),
      GoRoute(
        path: RouteUri.crudDetail,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: CrudDetailScreen(id: state.queryParams['id'] ?? ''),
          );
        },
      ),
      GoRoute(
        path: RouteUri.classScreen,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: AddClassScreen(id: state.queryParams['id'] ?? ''),
          );
        },
      ),
      GoRoute(
        path: RouteUri.class_profile,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: ClassProfileScreen(id: state.queryParams['id'] ?? ''),
          );
        },
      ),
      GoRoute(
        path: RouteUri.exam_profile,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: ExamProfileScreen(id: state.queryParams['id'] ?? ''),
          );
        },
      ),
      GoRoute(
        path: RouteUri.pdfscreen,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const PdfScreen(),
        ),
      ),
    ],
    redirect: (state) {
      if (unrestrictedRoutes.contains(state.subloc)) {
        return null;
      } else if (publicRoutes.contains(state.subloc)) {
        // Is public route.
        if (userDataProvider.isUserLoggedIn()) {
          // User is logged in, redirect to home page.
          return RouteUri.home;
        }
      } else {
        // Not public route.
        if (!userDataProvider.isUserLoggedIn()) {
          // User is not logged in, redirect to login page.
          return RouteUri.login;
        }
      }

      return null;
    },
  );
}
