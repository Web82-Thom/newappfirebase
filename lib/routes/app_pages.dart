import 'package:get/get.dart';
import 'package:newappfirebase/modules/auth/views/auth_view.dart';
import 'package:newappfirebase/modules/auth/widgets/signin_widget.dart';
import 'package:newappfirebase/modules/auth/widgets/signup_widget.dart';
import 'package:newappfirebase/modules/chat/views/chat_view.dart';
// import 'package:newappfirebase/modules/chat/widgets/users_list.dart';
import 'package:newappfirebase/modules/home/views/home_view.dart';
import 'package:newappfirebase/modules/profile/views/list_users_view.dart';
import 'package:newappfirebase/modules/profile/views/profile_view.dart';



part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      // binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => AuthView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.PROFILEVIEW,
      page: () => ProfileView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.CHATVIEW,
      page: () => ChatView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.LISTUSERSVIEW,
      page: () => UserListView(),
      // binding: AuthBinding(),
    ),
  ];
}
