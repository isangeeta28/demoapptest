import 'dart:io';

import 'package:demoprojectapp/model/users.dart';
import 'package:demoprojectapp/provider/auth_provider.dart';
import 'package:demoprojectapp/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../resources/firestore_methods.dart';
import '../utilis/utils.dart';
import 'dart:typed_data';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  Uint8List? _file;
  File? videoFile;
  String videoUrl = '';
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Users? userDetails;

  getUserDetails() async {
    AuthProvider authProvider = context.read<AuthProvider>();
     userDetails = await authProvider.getUserDetails();
  }


  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            // SimpleDialogOption(
            //     padding: const EdgeInsets.all(20),
            //     child: const Text('Choose Video from Gallery'),
            //     onPressed: () async {
            //       Navigator.of(context).pop();
            //       File? file = await uploadVideoPost(videoFile!);
            //       setState(() {
            //         videoFile = file;
            //       });
            //     }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage({required String datauid, required String datausername, required String dataphotourl}) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        datauid,
        datausername,
        dataphotourl,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return _file == null
        ? Container(
      decoration: BoxDecoration(
         // borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(begin: Alignment.bottomRight, stops: [
            0.5,
            0.9
          ], colors: [
            Colors.pinkAccent.shade200,
            Colors.blue.shade200
          ])),
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
          Text("Add Post",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800
            ),),
          Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
              ),
              onPressed: () => _selectImage(context),
            ),
          )
                ],
              ),
        )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back,
                color: Colors.black,),
                onPressed: clearImage,
              ),
              title: const Text(
                'New Post ',
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: false,
              actions: <Widget>[
                IconButton(
                  onPressed: () => postImage(
                    datauid: userDetails?.id??"",
                    datausername : userDetails?.nickname??"",
                    dataphotourl :userDetails?.photoUrl??"",
                  ),
                  icon: Icon(Icons.check,
                  color: Colors.black,
                  size: 30,),
                )
              ],
            ),
            // POST FORM
            body: Column(
              children: <Widget>[
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter,
                                image: MemoryImage(_file!),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          );
  }
}
