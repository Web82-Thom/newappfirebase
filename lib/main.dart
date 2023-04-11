import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newappfirebase/modules/auth/views/auth_view.dart';
import 'package:newappfirebase/modules/auth/views/email_verification_view.dart';
import 'package:newappfirebase/ressources/widgets/splash_screen.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';
import 'package:newappfirebase/routes/app_pages.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
  runApp(const MyApp());
  
}
//USE FOR FORM SIGN in.out//
final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
        return GetMaterialApp(
          scaffoldMessengerKey: Utils.messengerKey,
          navigatorKey: navigatorKey,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.blue[900],
          ),
          getPages: AppPages.routes,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('fr', 'FR'),
          ],
          debugShowCheckedModeBanner: false,
          home:  StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              if (userSnapshot.hasData) {
                return const EmailVerificationView();
              }
              return const AuthView();
            },
          ),
        );
      }
    
  }
