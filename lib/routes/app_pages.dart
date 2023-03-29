import 'package:get/get.dart';
import 'package:newappfirebase/modules/auth/views/auth_view.dart';
import 'package:newappfirebase/modules/chat/views/chat_view.dart';
import 'package:newappfirebase/modules/chat/views/chatrooms.dart';
import 'package:newappfirebase/modules/home/views/home_view.dart';
import 'package:newappfirebase/modules/profile/views/profile_view.dart';
import 'package:newappfirebase/modules/profile/views/user_infos_view.dart';



part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      // binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.PROFILEVIEW,
      page: () => const ProfileView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.CHATVIEW,
      page: () => const ChatView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.CHATROOM,
      page: () => const ChatRoom(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.USERINFOS,
      page: () => const UserInfosView(),
      // binding: AuthBinding(),
    ),
  ];
}
