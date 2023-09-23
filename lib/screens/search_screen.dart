import 'package:chat_app_firebase/consts/consts.dart';
import 'package:chat_app_firebase/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SearchScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const SearchScreen(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController emailCOntroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Search..'),
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(children: [
          TextField(
            decoration: InputDecoration(
              labelText: "Enter Email...",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CupertinoButton(
              child: Text('Searh'),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {})
        ]),
      )),
    );
  }
}
