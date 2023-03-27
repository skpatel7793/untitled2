import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class gallary extends StatefulWidget {
  const gallary({Key? key}) : super(key: key);

  @override
  State<gallary> createState() => _gallaryState();
}

class _gallaryState extends State<gallary> {

  String url = "https://cdn.pixabay.com/photo/2017/10/24/20/33/autumn-2886063_960_720.png";
  var listOfFiles;
  var progress;


  getNetworkImageSavedInGallery() async {
    final dir = await getExternalStorageDirectory();
    ///save picture folder dir
    String fileName = url.split("/").last;
    final dirPath1 = "${dir!.path.split("/Android").first}/Pictures/$fileName";
    print("dirPath1___________ $dirPath1");
    await Dio().download(url, dirPath1, onReceiveProgress: (value1, value2) async {
      setState(() {
        progress = (value1 / value2);
      });
      if (progress == 1.0) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Network Image Save In Gallery")));
      }
    });
  }
  requestPermission() async {
    try {
      Map<Permission, PermissionStatus> status = await [Permission.storage].request();
      print("status___________ ${Permission.storage}");
      final info = status[Permission.storage].toString();
      print("info___________ ${info}");
    } catch (e) {
      print("e______________ $e");
    }
  }

  getImageFromGalleyToApp() async {
    Directory? dir = await getExternalStorageDirectory();
    print("dir__________${dir!.path}");
    final dirPath = "${dir.path.split("/Android").first}/Pictures/";
    print("dirPath__________$dirPath");
    var files = await FileManager(root: Directory(dirPath),  )
        .filesTree(extensions: ["png", "jpeg", "jpg"]);
    files.forEach((element) {
      setState(() {
        listOfFiles.add(element);
      });
      
      print("listOfFiles_________ ${listOfFiles.length}");
    });
    print("files__________${files.length}");
    /* List Founds = await fm.search("myFile",
        searchFilter: SimpleFileFilter(allowedExtensions: [],fileOnly: true),sortedBy: FileManagerSorting.Size).toList();
    print("founds   ${Founds.length}");
    return Founds;
*/
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [

            ElevatedButton(onPressed: (){
              getNetworkImageSavedInGallery();
            }, child: Text("save to gallry")),
            ElevatedButton(onPressed: (){
              getImageFromGalleyToApp();
            }, child: Text("retrive in app"))

            ]


        ),
      ),


    );
  }
}
