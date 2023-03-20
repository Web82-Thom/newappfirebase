import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newappfirebase/modules/auth/controllers/auth_controller.dart';
// import 'package:newappfirebase/modules/auth/controllers/authentification_service.dart';
import 'package:newappfirebase/modules/auth/models/user_model.dart';
import 'package:newappfirebase/modules/chat/models/chat_model.dart';
import 'package:newappfirebase/modules/chat/views/chat_view.dart';
// import 'package:newappfirebase/modules/chat/widgets/users_list.dart';
import 'package:newappfirebase/modules/profile/controllers/profile_controller.dart';
import 'package:newappfirebase/ressources/widgets/splash_screen.dart';
import 'package:newappfirebase/routes/app_pages.dart';
import 'package:provider/provider.dart';

class UserListView extends StatefulWidget {
  @override
  _UserListViewState createState() => _UserListViewState();
}
final AuthController authController = AuthController();
class _UserListViewState extends State<UserListView> {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<AppUser?>(context);
    // if (user == null) throw Exception("user not found");
    // final database = ProfileController().readUser();
    return 
    // StreamProvider<List<UserModel?>>.value(
    //   initialData: [],
    //   value: database.users,
       
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Liste des membres'),),
        body: FutureBuilder(
          future: ProfileController().readAllUsers(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (ctx, index){
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.CHATVIEW);
                      },
                      child: ListTile(
                        title: Text(snapshot.data![index].username.toString()),
                      ),
                    );
                  },

                );
              }
            }return Container();
          } 
          ),
      );
    // );
  }
}

// class UserTile extends StatelessWidget {
//   final UserModel? user;

//   UserTile(this.user);

//   @override
//  Widget build(BuildContext context) {
//     final user = Provider.of<AppUser?>(context);
//     if (user == null) throw Exception("user not found");
//     final database = DatabaseService(user.uid);
//     return StreamProvider<List<UserModel?>>.value(
//       initialData: [],
//       value: database.users,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.blueGrey,
//           elevation: 0.0,
//           title: Text('Water Social'),
//           actions: <Widget>[
//             StreamBuilder<UserModel?>(
//               stream: database.user,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   UserModel? userData = snapshot.data;
//                   if (userData == null) return SplashScreen();
//                   return TextButton.icon(
//                     icon: Icon(
//                       Icons.wine_bar,
//                       color: Colors.white,
//                     ),
//                     label: Text('drink', style: TextStyle(color: Colors.white)),
//                     onPressed: () async {
//                       // await database.saveUser(userData.name!, userData.waterCounter + 1);
//                     },
//                   );
//                 } else {
//                   return SplashScreen();
//                 }
//               },
//             ),
//             TextButton.icon(
//               icon: Icon(
//                 Icons.person,
//                 color: Colors.white,
//               ),
//               label: Text('logout', style: TextStyle(color: Colors.white)),
//               onPressed: () async {
//                 // await _auth.signOut();
//               },
//             )
//           ],
//         ),
//         body: UserList(),
//       ),
//     );
//   }
// }