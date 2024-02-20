import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:google_fonts/google_fonts.dart';

import '../repositories/repository.dart';
import '../widgets/custom_painter0.dart';

class DiscoverFilesScreen extends StatefulWidget {
  const DiscoverFilesScreen({super.key});

  @override
  State<DiscoverFilesScreen> createState() => _DiscoverFilesScreenState();
}

class _DiscoverFilesScreenState extends State<DiscoverFilesScreen> {
  String? chosenGroup;

  int? filesNumber;

  bool isLoading = true;
  bool noFilesFound = true;

  List allUrls = [];

  List<String> groupsNames = [];
  List groupsIds = [];
  List ownersIds = [];
  List ownersNames = [];

  bool loadingGroups = false;
  bool isLoadingGroups = true;

  Future loadGroups() async {
    setState(() {
      loadingGroups = true;
    });
    await Repository()
        .listGroups('', groupsNames, groupsIds, ownersNames, ownersIds);
  }

  Future listFiles() async {
    allUrls.clear();

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

    Reference ref = FirebaseStorage.instance.ref(finalPath);
    ListResult fileList = await ref.listAll();

    filesNumber = fileList.items.length;
    for (var file in fileList.items) {
      var destination = file.fullPath;
      ref = FirebaseStorage.instance.ref(destination);
      String fileUrl = await ref.getDownloadURL();
      allUrls.add(fileUrl);
    }

    setState(() {
      isLoading = false;
      if (allUrls.isNotEmpty) {
        noFilesFound = false;
      } else {
        noFilesFound = true;
      }
    });
  }

  Future loadImages() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
      listFiles();
    }
  }

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
        if (mounted) {
          loadImages();
        }
      });
    }
    filesNumber = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.125,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: isLoading
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.width * 0.6,
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: MediaQuery.of(context).size.width * 0.5,
                              child: const FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  'Loading...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
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
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.width * 0.2,
                            child: const FittedBox(
                              fit: BoxFit.contain,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    : noFilesFound
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.6,
                                ),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: const FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      'No images',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
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
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.width * 0.5,
                                child: const FittedBox(
                                  fit: BoxFit.contain,
                                  child: Icon(
                                    Icons.hide_image_outlined,
                                    size: 40,
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
                              ),
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.025,
                              right: MediaQuery.of(context).size.width * 0.025,
                            ),
                            child: GridView.builder(
                              itemCount: filesNumber,
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: FullScreenWidget(
                                    backgroundIsTransparent: true,
                                    backgroundColor: Colors.transparent,
                                    child: Hero(
                                      tag: index,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                            allUrls[allUrls.length - 1 - index],
                                            filterQuality: FilterQuality.none,
                                            errorBuilder: (context, child,
                                                loadingProgress) {
                                          return Center(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  'Error',
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                      color: Colors
                                                          .redAccent.shade400,
                                                      fontSize: 25,
                                                      shadows: const [
                                                        Shadow(
                                                            color: Colors.black,
                                                            blurRadius: 1,
                                                            offset: Offset(
                                                                0.5, 0.5)),
                                                        Shadow(
                                                            color: Colors.black,
                                                            blurRadius: 1,
                                                            offset: Offset(
                                                                -0.5, 0.5)),
                                                        Shadow(
                                                            color: Colors.black,
                                                            blurRadius: 1,
                                                            offset: Offset(
                                                                0.5, -0.5)),
                                                        Shadow(
                                                            color: Colors.black,
                                                            blurRadius: 1,
                                                            offset: Offset(
                                                                -0.5, -0.5)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }, loadingBuilder: (context, child,
                                                loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.1),
                                                child:
                                                    const CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          }
                                        }),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
              Expanded(
                flex: 1,
                child: CustomPaint(
                  size: Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.width,
                  ),
                  painter: RPSCustomPainter(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Text(
                            'Select a group',
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              color: Colors.white,
                              shadows: const [
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
                                          child: Text(
                                            value,
                                            style: GoogleFonts.lato(),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        if (newValue != chosenGroup) {
                                          if (mounted) {
                                            setState(() {
                                              chosenGroup = newValue.toString();
                                            });
                                            loadImages();
                                          }
                                        }
                                      })
                                  : Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        child: Text(
                                          'You don\'t have any groups :(',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.white,
                                            shadows: const [
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
                                    )
                              : Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.height *
                                          0.01),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.08,
                                    height: MediaQuery.of(context).size.width *
                                        0.08,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.06),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Browse',
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
    ));
  }
}
