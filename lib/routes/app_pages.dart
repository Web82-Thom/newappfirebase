import 'package:get/get.dart';
import 'package:newappfirebase/modules/home/views/home_view.dart';



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
    // GetPage(
    //   name: _Paths.AUTH,
    //   page: () => AuthView(),
    //   // binding: AuthBinding(),
    // ),
    // GetPage(
    //   name: _Paths.SIGNUP,
    //   page: () => SignupWidget(),
    //   // binding: AuthBinding(),
    // ),
    // GetPage(
    //   name: _Paths.SIGNIN,
    //   page: () => SigninWidget(),
    //   // binding: AuthBinding(),
    // ),
    // GetPage(
    //   name: _Paths.PROFILE,
    //   page: () => ProfileView(),
    //   // binding: AuthBinding(),
    // ),
    // GetPage(
    //   name: _Paths.CONTACT,
    //   page: () => ContactView(),
    //   // binding: AuthBinding(),
    // ),
    
  ];
}
