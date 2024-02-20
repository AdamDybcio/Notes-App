import 'dart:io';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../repositories/repository.dart';
import '../widgets/add_files_screen/add_files_button_widget.dart';
import '../widgets/add_files_screen/choose_group_widget.dart';
import '../widgets/add_files_screen/no_groups_to_choose_widget.dart';
import '../widgets/custom_painter0.dart';

class AddFilesScreen extends StatefulWidget {
  final dynamic userData;
  const AddFilesScreen({
    Key? key,
    this.userData,
  }) : super(key: key);

  @override
  State<AddFilesScreen> createState() => _AddFilesScreenState();
}

class _AddFilesScreenState extends State<AddFilesScreen>
    with TickerProviderStateMixin {
  String? chosenGroup;

  bool isLoadingGroups = true;

  String sendingInfo = 'Images sent: ';
  int sendingNumber = 0;

  @override
  void initState() {
    if (mounted) {
      loadGroups().then((_) {
        if (groupsNames.isEmpty) {
          if (mounted) {
            setState(() {
              chosenGroup = null;
              isLoadingGroups = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              chosenGroup = groupsNames[0];
              isLoadingGroups = false;
            });
          }
        }
      });
    }
    super.initState();
  }

  final ImagePicker imagePicker = ImagePicker();

  List<XFile>? imageFileList = [];

  bool isLoading = false;

  File file = File('');

  int filesNumber = 0;

  List<String> groupsNames = [];
  List groupsIds = [];
  List ownersIds = [];
  List ownersNames = [];

  bool loadingGroups = false;

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  Future loadGroups() async {
    setState(() {
      loadingGroups = true;
    });
    await Repository()
        .listGroups('', groupsNames, groupsIds, ownersNames, ownersIds);
  }

  Future saveImages() async {
    var finalPath = '';
    var ref1 = await FirebaseFirestore.instance.collection('groups').get();

    var groupIndex = groupsNames.indexWhere((name) => name == chosenGroup);
    var groupId = groupsIds[groupIndex];

    for (var doc2 in ref1.docs) {
      var ref2 =
          await FirebaseFirestore.instance.doc('groups/${doc2.id}').get();
      var ref3 = ref2.data();
      if (doc2.id == groupId && ref3?['name'] == groupsNames[groupIndex]) {
        finalPath = 'groups/${doc2.id}/images';
        break;
      }
    }

    filesNumber = imageFileList!.length;

    for (var index = 0; index < filesNumber; index++) {
      file = File(imageFileList![index].path);

      final fileName = '${widget.userData['login'].toString().toLowerCase()}'
          '${DateTime.now().month}'
          '${DateTime.now().day}'
          '${DateTime.now().hour}'
          '${DateTime.now().minute}'
          '${DateTime.now().second}'
          '.png';

      final destination = finalPath;

      final ref = FirebaseStorage.instance.ref('$destination/$fileName');

      await ref.putFile(file).then((_) async {
        FirebaseFirestore.instance.collection(finalPath).doc(fileName).set({
          'owner': FirebaseAuth.instance.currentUser!.uid,
        }).then((_) {
          print('Image number has been sent: ${index + 1}');
          setState(() {
            sendingNumber = sendingNumber + 1;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.075,
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      itemCount: imageFileList!.isEmpty
                          ? 1
                          : (imageFileList!.length + 1),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: index == imageFileList!.length
                                ? Colors.redAccent.shade400.withOpacity(0.9)
                                : Colors.black,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: (imageFileList!.isEmpty ||
                                      index == (imageFileList!.length))
                                  ? IconButton(
                                      splashColor: Colors.redAccent.shade400,
                                      splashRadius: 30,
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                              color: Colors.black,
                                              blurRadius: 1,
                                              offset: Offset(0.5, 0.5)),
                                          Shadow(
                                              color: Colors.black,
                                              blurRadius: 1,
                                              offset: Offset(-0.5, 0.5)),
                                          Shadow(
                                              color: Colors.black,
                                              blurRadius: 1,
                                              offset: Offset(0.5, -0.5)),
                                          Shadow(
                                              color: Colors.black,
                                              blurRadius: 1,
                                              offset: Offset(-0.5, -0.5)),
                                        ],
                                      ),
                                      iconSize: 75,
                                      onPressed: () {
                                        selectImages();
                                      },
                                    )
                                  : IconButton(
                                      splashColor: Colors.redAccent.shade400,
                                      onPressed: () {
                                        setState(() {
                                          imageFileList!.removeAt(index);
                                        });
                                      },
                                      splashRadius: 30,
                                      icon: Image.file(
                                        File(
                                          imageFileList![index].path,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomPaint(
                    size: Size(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.width,
                    ),
                    painter: RPSCustomPainter(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.025,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            const ChooseGroupWidget(),
                            isLoadingGroups == false
                                ? chosenGroup != null
                                    ? DropdownButton(
                                        underline: const SizedBox(),
                                        style: GoogleFonts.lato(
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 1,
                                                  offset: Offset(0.5, 0.5)),
                                              Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 1,
                                                  offset: Offset(-0.5, 0.5)),
                                              Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 1,
                                                  offset: Offset(0.5, -0.5)),
                                              Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 1,
                                                  offset: Offset(-0.5, -0.5)),
                                            ],
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.arrow_drop_down_circle_outlined,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                                color: Colors.black,
                                                blurRadius: 1,
                                                offset: Offset(0.5, 0.5)),
                                            Shadow(
                                                color: Colors.black,
                                                blurRadius: 1,
                                                offset: Offset(-0.5, 0.5)),
                                            Shadow(
                                                color: Colors.black,
                                                blurRadius: 1,
                                                offset: Offset(0.5, -0.5)),
                                            Shadow(
                                                color: Colors.black,
                                                blurRadius: 1,
                                                offset: Offset(-0.5, -0.5)),
                                          ],
                                        ),
                                        value: chosenGroup.toString(),
                                        items: groupsNames.map((String value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            alignment: Alignment.center,
                                            child: Text(
                                              value,
                                              style: GoogleFonts.lato(),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            chosenGroup = newValue.toString();
                                          });
                                        })
                                    : Padding(
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          child: const NoGroupsToChooseWidget(),
                                        ),
                                      )
                                : Padding(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.height *
                                            0.01),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.08,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.08,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            if (chosenGroup != null)
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    imageFileList!.isEmpty || isLoading
                                        ? Colors.grey.withOpacity(0.8)
                                        : Colors.white,
                                  ),
                                ),
                                onPressed: imageFileList!.isEmpty || isLoading
                                    ? null
                                    : () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await saveImages().then((_) {
                                          setState(() {
                                            sendingNumber = 0;
                                            isLoading = false;
                                            sendingInfo = 'Images sent: ';
                                            imageFileList!.clear();
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              duration:
                                                  const Duration(seconds: 3),
                                              content: Text(
                                                'Images sent successfully.',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.lato(
                                                  textStyle: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ));
                                          });
                                        });
                                      },
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: isLoading
                                      ? Row(
                                          children: [
                                            Text(
                                              '$sendingInfo${sendingInfo == 'Done!' ? '' : sendingNumber}',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                  fontSize: 20,
                                                  color: imageFileList!.isEmpty
                                                      ? Colors.black45
                                                      : Colors.black,
                                                  shadows: const [
                                                    Shadow(
                                                        color: Colors.white,
                                                        blurRadius: 1,
                                                        offset:
                                                            Offset(0.5, 0.5)),
                                                    Shadow(
                                                        color: Colors.white,
                                                        blurRadius: 1,
                                                        offset:
                                                            Offset(-0.5, 0.5)),
                                                    Shadow(
                                                        color: Colors.white,
                                                        blurRadius: 1,
                                                        offset:
                                                            Offset(0.5, -0.5)),
                                                    Shadow(
                                                        color: Colors.white,
                                                        blurRadius: 1,
                                                        offset:
                                                            Offset(-0.5, -0.5)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          ],
                                        )
                                      : AddFilesButtonWidget(
                                          imageFileList: imageFileList),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.06),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Add notes',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                            color: Colors.black,
                            blurRadius: 1,
                            offset: Offset(0.5, 0.5)),
                        Shadow(
                            color: Colors.black,
                            blurRadius: 1,
                            offset: Offset(-0.5, 0.5)),
                        Shadow(
                            color: Colors.black,
                            blurRadius: 1,
                            offset: Offset(0.5, -0.5)),
                        Shadow(
                            color: Colors.black,
                            blurRadius: 1,
                            offset: Offset(-0.5, -0.5)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
