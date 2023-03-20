import 'package:newappfirebase/modules/auth/models/user_model.dart';


class ChatModel{
  final String userUid;
  final UserModel peer;

  ChatModel(this.userUid, this.peer);

  String getChatGroupId() {
    if (userUid.hashCode <= peer.id.hashCode) {
      return '$userUid-${peer.id}';
    } else {
      return '${peer.id}-$userUid';
    }
  }
}