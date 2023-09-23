import 'package:chat_app_firebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserById(String uid) async {
    UserModel? userModel;
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection("Users").doc(uid).get();
      
      if(documentSnapshot != null){
        userModel = UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      }
      return userModel;
  }

}
