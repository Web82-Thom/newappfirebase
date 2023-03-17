part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const AUTH = _Paths.AUTH;
  static const SIGNIN = _Paths.SIGNIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const PROFILEVIEW = _Paths.PROFILEVIEW;
   
}

abstract class _Paths {
  static const HOME = '/home';
  static const AUTH = '/auth';
  static const SIGNIN = '/signin';
  static const SIGNUP = '/signup';
  static const PROFILEVIEW = '/profile';
}
