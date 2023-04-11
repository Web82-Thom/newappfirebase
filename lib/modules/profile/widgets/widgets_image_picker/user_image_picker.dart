import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newappfirebase/modules/profile/controllers/image_picker_controller.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker(this.imagePickFn, {super.key});

  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  
  File? _pickedImage;
  final picker = ImagePicker();
  ImagePickerController imagePickerController = ImagePickerController();
  
  Future pickImage(ImageSource imageSource) async {
    final pickedImage = await picker.pickImage(
      source: imageSource,
      imageQuality: 50,
      maxWidth: 150,
    );

    setState(() {
      pickedImage != null?
      _pickedImage = File(pickedImage.path): null;
      Navigator.pop(context);
    });
    pickedImage != null?
    //DONNE LA VALEUR DU FILE WIDGET APPELER UserImagePicker(widget.imagePickFn)//
    widget.imagePickFn(File(pickedImage.path)): null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
          radius: 80,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 0,
              left: 130,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.amber,
                size: 45,
              ),
              onPressed: (){
                _showPopupUpdatePicture();
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showPopupUpdatePicture() {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title:const Center(
        child: Text(
          "Image de profil",
          style: TextStyle(fontSize: 18),
        ),
      ),
      content: FittedBox(
        child:
        Row(
          children: [
            IconButton(
              onPressed: () {
                pickImage(ImageSource.gallery);
              },
              icon: Icon(Icons.add_photo_alternate),
            ),
            IconButton(
              onPressed: ()  {
                pickImage(ImageSource.camera);
              },
              icon: Icon(Icons.add_a_photo),
            ),
          ],
        ), 
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
