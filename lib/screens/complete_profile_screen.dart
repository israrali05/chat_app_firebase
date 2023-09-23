// ignore_for_file: sort_child_properties_last

import 'dart:io';

import 'package:chat_app_firebase/consts/consts.dart';
import 'package:chat_app_firebase/models/user_model.dart';
import 'package:chat_app_firebase/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfileScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const CompleteProfileScreen(
      {super.key, required this.firebaseUser, required this.userModel});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  CroppedFile? imageFile;
  TextEditingController fullNameController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickImage = await ImagePicker().pickImage(source: source);

    if (pickImage != null) {
      cropImage(pickImage);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20,
    );

    if (croppedFile != null) {
      setState(() {
        imageFile = croppedFile;
      });
    }
  }

  // Dialog Show Functions
  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Upload an Image"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                leading: const Icon(Icons.photo),
                title: const Text("Select from Gallery"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text("Select from Cmaera"),
              ),
            ]),
          );
        });
  }

  //  check Values Functions
  void checkvalues() {
    String fullName = fullNameController.text.trim();
    if (fullName == "" || imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Fill All Fields!"),
      ));
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.userModel.uid.toString())
        .putFile(File(imageFile!.path));
    TaskSnapshot snapshot = await uploadTask;

    String imgUrl = await snapshot.ref.getDownloadURL();
    String fullName = fullNameController.text.trim();

    widget.userModel.fullname = fullName;
    widget.userModel.profilepic = imgUrl;
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Profile Updated SuccessFully.."),
      ));
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HomeScreen(
          firebaseUser: widget.firebaseUser,
          userModel: widget.userModel,
        );
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Profile"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          children: [
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                showPhotoOptions();
              },
              child: CircleAvatar(
                backgroundImage:
                    imageFile != null ? FileImage(File(imageFile!.path)) : null,
                radius: 50,
                child: imageFile != null
                    ? null
                    : const Icon(
                        Icons.person,
                        size: 50,
                      ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
                child: const Text("Submit"),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  checkvalues();
                })
          ],
        ),
      ),
    );
  }
}
