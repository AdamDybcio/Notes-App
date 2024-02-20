// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:animated_background/animated_background.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../repositories/repository.dart';
import '../screens/add_files_screen.dart';
import '../screens/discover_files_screen.dart';
import '../screens/write_note_screen.dart';
import '../widgets/clock_widget.dart';
import '../widgets/custom_painter0.dart';
import 'login_screen_old.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  final userData;
  bool isNewUser;
  HomeScreen(
    this.isNewUser, {
    Key? key,
    this.userData,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int isOnPage = 0;

  int? groupsNumber;
  bool isLoadingGroups = false;

  bool noGroupsFound = true;

  List allGroups = [];
  List allGroupIds = [];
  List allOwnersIds = [];
  List allOwnersNames = [];

  bool creatingNewGroup = false;
  late TextEditingController newGroupController;
  late FocusNode newGroupFocusNode;
  bool hideFloatingButton = false;

  List detailsVisible = [];

  late TextEditingController newUserController;
  late FocusNode newUserFocusNode;

  late bool isNewUser;

  List isOnInfoMode = [];
  late TextEditingController newUserInGroupController;
  late FocusNode newUserInGroupFocusNode;

  bool wantsToRemoveGroup = false;

  List users = [];
  List usersNames = [];
  bool isLoadingDetails = false;

  bool isLoadingNewNickname = false;

  bool isAddingNewUser = false;
  bool addUserNotEmpty = false;

  String groupOwner = '';

  Future loadGroups(String? removeGroupId) async {
    setState(() {
      isLoadingGroups = true;
    });
    await Repository()
        .listGroups(
            removeGroupId, allGroups, allGroupIds, allOwnersNames, allOwnersIds)
        .then((_) {
      setState(() {
        groupsNumber = allGroups.length;
        if (allGroups.isNotEmpty) {
          noGroupsFound = false;
        } else {
          noGroupsFound = true;
        }
      });
    });
  }

  Future addNewGroup() async {
    if (!allGroups.contains(newGroupController.text.toString().trim())) {
      var ref = await FirebaseFirestore.instance.collection('groups').add({
        'name': newGroupController.text.toString(),
        'owner': FirebaseAuth.instance.currentUser!.uid.toString(),
      }).then((value) {
        var id = value.id;
        FirebaseFirestore.instance
            .collection('groups/$id/members')
            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
            .set({}).then((_) {
          if (mounted) {
            loadGroups('').then((_) {
              setState(() {
                isLoadingGroups = false;
              });
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
                content: Text(
                  'Group added.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ));
            });
          }
        });
      });
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        content: Text(
          'You already have a group with this name.',
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ));
    }
  }

  Future addNewUsername() async {
    var ref = await FirebaseFirestore.instance.collection('users').get().then(
          (value) => value.docs.where(
            (element) => (element.id == FirebaseAuth.instance.currentUser!.uid),
          ),
        );
    var ref2 =
        await FirebaseFirestore.instance.doc('users/${ref.first.id}').get();
    var ref3 =
        await FirebaseFirestore.instance.doc('users/${ref.first.id}').set({
      'login': ref2.data()!.values.last,
      'nickname': newUserController.text.trim().toString(),
    }).then((_) {
      setState(() {
        isNewUser = false;
      });
    });
  }

  Future loadGroupDetails(String groupName) async {
    var groupIndex = 0;
    int length = allGroups.length;
    for (int i = 0; i < length; i++) {
      if (allGroups[i].toString() == groupName.toString()) {
        groupIndex = i;
      }
    }
    var finalGroupId = allGroupIds[groupIndex];
    var ref =
        await FirebaseFirestore.instance.doc('groups/$finalGroupId').get();
    var ref2 = await FirebaseFirestore.instance
        .collection('groups/$finalGroupId/members')
        .get();
    var ref3 = ref2.docs.forEach((doc) {
      users.add(doc.id);
    });
    for (var userId in users) {
      var ref4 = await FirebaseFirestore.instance.doc('users/$userId').get();
      var ref5 = ref4.data();
      usersNames.add('${ref5?['nickname']} (${ref5?['login']})');
    }
    var refB = ref['owner'];
    groupOwner = refB;
  }

  Future kickUserFromGroup(String user) async {
    Navigator.of(context).pop();

    String userId = user;

    setState(() {
      users = [];
      usersNames = [];
    });

    var groupId = '';

    var ref1 = await FirebaseFirestore.instance.collection('groups').get();
    var ref2 = ref1.docs;

    for (var doc in ref2) {
      var ref3 = await FirebaseFirestore.instance.doc('groups/${doc.id}').get();
      var ref4 = ref3.data();
      if ((ref4!['owner'] == FirebaseAuth.instance.currentUser!.uid) &&
          ref4['name'] == isOnInfoMode[0]) {
        groupId = ref3.id;
      }
    }

    var refA = await FirebaseFirestore.instance
        .collection('group/$groupId/members')
        .get()
        .then((value) async {
      var refB = value.docs.where((doc) => doc.id == userId);
      var refC = await FirebaseFirestore.instance
          .doc('groups/$groupId/members/${refB.first.id}')
          .delete()
          .then((value) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          content: Text(
            'A user has been kicked out of the group.',
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
  }

  Future leaveGroup() async {
    Navigator.of(context).pop();

    setState(() {
      detailsVisible = [];
      users = [];
      usersNames = [];
      isLoadingGroups = true;
      groupOwner = '';
    });

    var groupId = '';

    var ref1 = await FirebaseFirestore.instance.collection('groups').get();
    var ref2 = ref1.docs;

    for (var doc in ref2) {
      var ref3 = await FirebaseFirestore.instance.doc('groups/${doc.id}').get();
      var ref4 = ref3.data();
      if ((ref4!['owner'] != FirebaseAuth.instance.currentUser!.uid) &&
          ref4['name'] == isOnInfoMode[0]) {
        groupId = ref3.id;
      }
    }

    var refA = await FirebaseFirestore.instance
        .collection('groups/$groupId/members')
        .get()
        .then((value) async {
      var refB = value.docs
          .where((doc) => doc.id == FirebaseAuth.instance.currentUser!.uid);
      var refC = await FirebaseFirestore.instance
          .doc('groups/$groupId/members/${refB.first.id}')
          .delete()
          .then((value) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          content: Text(
            'You left the group.',
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
  }

  Future removePerson() async {
    Navigator.of(context).pop();
  }

  Future removeGroup() async {
    Navigator.of(context).pop();

    setState(() {
      detailsVisible = [];
      users = [];
      usersNames = [];
      isLoadingGroups = true;
      groupOwner = '';
    });
    var removeGroupId = '';
    var ref1 = await FirebaseFirestore.instance.collection('groups').get();
    var ref2 = ref1.docs;
    for (var doc in ref2) {
      var ref3 = await FirebaseFirestore.instance.doc('groups/${doc.id}').get();
      var ref4 = ref3.data();
      if ((ref4!['owner'] == FirebaseAuth.instance.currentUser!.uid) &&
          ref4['name'] == isOnInfoMode[0]) {
        removeGroupId = doc.id;
      }
    }
    await FirebaseFirestore.instance.doc('groups/$removeGroupId').delete().then(
      (value) {
        loadGroups(removeGroupId).then((value) {
          setState(() {
            isLoadingGroups = false;
            isOnInfoMode = [];
          });
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            content: Text(
              'Group deleted.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ));
        });
      },
    );
  }

  Future addUserToGroup(String userLogin) async {
    String finalUserId = userLogin;
    var groupId = '';
    var userId = '';
    bool isAlreadyInGroup = false;
    var def1 = await FirebaseFirestore.instance.collection('groups').get();
    var def2 = def1.docs.forEach((doc) {
      if (doc['name'] == isOnInfoMode[0]) {
        groupId = doc.id;
      }
    });
    var ref1 = await FirebaseFirestore.instance.collection('users').get();
    var pef1 = await FirebaseFirestore.instance
        .collection('groups/$groupId/members')
        .get();
    var ref2 = ref1.docs.forEach((doc) {
      if (doc['login'] == finalUserId) {
        userId = doc.id;
      }
    });
    var pef2 = pef1.docs.forEach((doc) {
      if (doc.id == userId) {
        isAlreadyInGroup = true;
      }
    });
    if (userId != '' && isAlreadyInGroup == false) {
      await FirebaseFirestore.instance
          .collection('groups/$groupId/members')
          .doc(userId)
          .set({}).then((_) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          content: Text(
            'User added.',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ));
      });
    } else if (userId != '' && isAlreadyInGroup == true) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        content: Text(
          'The user is already in the group.',
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        content: Text(
          'There is no such user.',
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ));
    }
  }

  @override
  void initState() {
    isNewUser = widget.isNewUser;
    newGroupController = TextEditingController();
    newGroupFocusNode = FocusNode();
    newUserController = TextEditingController();
    newUserFocusNode = FocusNode();
    newUserInGroupController = TextEditingController();
    newUserInGroupFocusNode = FocusNode();
    groupsNumber = 0;
    if (mounted) {
      loadGroups('').then((_) {
        setState(() {
          isLoadingGroups = false;
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    newGroupFocusNode.dispose();
    newUserFocusNode.dispose();
    newUserInGroupFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        newGroupFocusNode.unfocus();
        newUserFocusNode.unfocus();
        newUserInGroupFocusNode.unfocus();
        setState(() {
          hideFloatingButton = false;
        });
      },
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 31, 29, 29),
          floatingActionButton: (hideFloatingButton || isNewUser == true)
              ? null
              : FloatingActionButton(
                  backgroundColor: Colors.redAccent.shade400.withOpacity(1),
                  splashColor: Colors.redAccent.shade400.withOpacity(1),
                  onPressed: (isOnPage == 4)
                      ? null
                      : () {
                          setState(() {
                            isOnPage = 4;
                          });
                        },
                  child: Icon(
                    Icons.add,
                    size: 40,
                    color: (isOnPage == 4) ? Colors.white : Colors.black,
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: Container(
            color: const Color.fromARGB(255, 31, 29, 29).withOpacity(0),
            child: AnimatedBottomNavigationBar(
              backgroundColor: Colors.redAccent.shade400.withOpacity(0.9),
              inactiveColor: Colors.black,
              activeColor: Colors.white,
              iconSize: 30,
              icons: [
                Icons.home,
                if (!isNewUser) Icons.note_add,
                if (!isNewUser) Icons.school,
                Icons.logout,
              ],
              activeIndex: isOnPage == 4 ? 5 : isOnPage,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.verySmoothEdge,
              leftCornerRadius: 32,
              rightCornerRadius: 32,
              onTap: (index) {
                setState(() {
                  creatingNewGroup = false;
                  detailsVisible = [];
                });
                if (index == 0) {
                  if (mounted) {
                    setState(() {
                      isOnInfoMode = [];
                    });
                    loadGroups('').then((_) {
                      setState(() {
                        isLoadingGroups = false;
                      });
                    });
                  }
                  setState(() {
                    isOnPage = 0;
                  });
                }
                if (index == 1) {
                  if (isNewUser) {
                    FirebaseAuth.instance.signOut().then((_) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                    });
                  } else {
                    setState(() {
                      isOnPage = 1;
                    });
                  }
                }
                if (index == 2) {
                  setState(() {
                    isOnPage = 2;
                  });
                }
                if (index == 3) {
                  FirebaseAuth.instance.signOut().then((_) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                  });
                }
              },
            ),
          ),
          body: AnimatedBackground(
            vsync: this,
            behaviour: RandomParticleBehaviour(
              options: ParticleOptions(
                spawnMaxRadius: 125,
                spawnMinRadius: 50,
                spawnMinSpeed: 1,
                particleCount: 12,
                spawnMaxSpeed: 3,
                minOpacity: 0.3,
                spawnOpacity: 0.4,
                baseColor: Colors.redAccent.shade400,
              ),
            ),
            child: isOnPage == 0
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.075,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.05,
                              left: MediaQuery.of(context).size.width * 0.1,
                              right: MediaQuery.of(context).size.width * 0.1),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomPaint(
                                  size: Size(
                                    MediaQuery.of(context).size.height * 0.15,
                                    MediaQuery.of(context).size.height * 0.15,
                                  ),
                                  painter: RPSCustomPainter(),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'Notes',
                                            style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 1,
                                                      offset: Offset(0.5, 0.5)),
                                                  Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 1,
                                                      offset:
                                                          Offset(-0.5, 0.5)),
                                                  Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 1,
                                                      offset:
                                                          Offset(0.5, -0.5)),
                                                  Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 1,
                                                      offset:
                                                          Offset(-0.5, -0.5)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'Storage',
                                            style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 1,
                                                      offset: Offset(0.5, 0.5)),
                                                  Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 1,
                                                      offset:
                                                          Offset(-0.5, 0.5)),
                                                  Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 1,
                                                      offset:
                                                          Offset(0.5, -0.5)),
                                                  Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 1,
                                                      offset:
                                                          Offset(-0.5, -0.5)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Expanded(
                                flex: 1,
                                child: SizedBox(),
                              ),
                              const Expanded(
                                flex: 3,
                                child: ClockWidget(),
                              ),
                            ],
                          ),
                        ),
                        if (isNewUser)
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.005,
                                left: MediaQuery.of(context).size.width * 0.1,
                                right: MediaQuery.of(context).size.width * 0.1),
                            child: Stack(
                              children: [
                                CustomPaint(
                                  size: Size(
                                    MediaQuery.of(context).size.width * 0.8,
                                    MediaQuery.of(context).size.height * 0.55,
                                  ),
                                  painter: RPSCustomPainter(),
                                ),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.height *
                                          0.025,
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    'Welcome to Notes Storage!',
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                  )),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    'To unlock all features,\nyou must first enter your nickname.',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
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
                                                  )),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05,
                                                vertical: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02,
                                              ),
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  filled: true,
                                                  prefixIcon:
                                                      Icon(Icons.person),
                                                  labelText: 'Your nickname',
                                                  fillColor: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                ),
                                                controller: newUserController,
                                                focusNode: newUserFocusNode,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    'Remember, you can set a nickname only once!',
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
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
                                                  )),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                            ),
                                            child: isLoadingNewNickname
                                                ? const CircularProgressIndicator(
                                                    color: Colors.white,
                                                  )
                                                : IconButton(
                                                    onPressed: () {
                                                      if (newUserController.text
                                                          .toString()
                                                          .isNotEmpty) {
                                                        setState(() {
                                                          isLoadingNewNickname =
                                                              true;
                                                        });
                                                        if (mounted) {
                                                          addNewUsername()
                                                              .then((_) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .hideCurrentSnackBar();
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          3),
                                                              content: Text(
                                                                'Welcome, ${newUserController.text}!',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    GoogleFonts
                                                                        .lato(
                                                                  textStyle:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ));
                                                          }).then((_) {
                                                            setState(() {
                                                              newUserController
                                                                  .text = '';
                                                              isLoadingNewNickname =
                                                                  false;
                                                            });
                                                          });
                                                        }
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons.done,
                                                      shadows: [
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
                                                    color: Colors.green,
                                                    iconSize: 35,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (!isNewUser)
                          Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height * 0.03),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Your groups',
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
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.025,
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent.shade400
                                              .withOpacity(0.9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: IconButton(
                                            onPressed: isLoadingDetails ||
                                                    isLoadingGroups
                                                ? null
                                                : () {
                                                    if (isOnInfoMode.isEmpty) {
                                                      newGroupFocusNode
                                                          .unfocus();
                                                      if (mounted) {
                                                        loadGroups('')
                                                            .then((_) {
                                                          setState(() {
                                                            isLoadingGroups =
                                                                false;
                                                          });
                                                        });
                                                      }
                                                      setState(() {
                                                        isOnInfoMode = [];
                                                        detailsVisible = [];
                                                        users = [];
                                                        usersNames = [];
                                                        groupOwner = '';
                                                        hideFloatingButton =
                                                            false;
                                                      });
                                                    } else {
                                                      newUserInGroupFocusNode
                                                          .unfocus();
                                                      setState(() {
                                                        isLoadingDetails = true;
                                                        users = [];
                                                        usersNames = [];
                                                        groupOwner = '';
                                                      });
                                                      if (mounted) {
                                                        loadGroupDetails(
                                                                isOnInfoMode[0])
                                                            .then((_) {
                                                          setState(() {
                                                            isLoadingDetails =
                                                                false;
                                                            newUserInGroupController
                                                                .text = '';
                                                            addUserNotEmpty =
                                                                false;
                                                          });
                                                        });
                                                      }
                                                    }
                                                  },
                                            icon: const Icon(
                                              Icons.refresh,
                                              color: Colors.white,
                                              size: 30,
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
                            ),
                          ),
                        if (!isNewUser)
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.005,
                                left: MediaQuery.of(context).size.width * 0.1,
                                right: MediaQuery.of(context).size.width * 0.1),
                            child: Stack(
                              children: [
                                CustomPaint(
                                  size: isOnInfoMode.isNotEmpty
                                      ? Size(
                                          MediaQuery.of(context).size.width *
                                              0.8,
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                        )
                                      : Size(
                                          MediaQuery.of(context).size.width *
                                              0.8,
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                        ),
                                  painter: RPSCustomPainter(),
                                ),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.height *
                                          0.025,
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      height: isOnInfoMode.isNotEmpty
                                          ? MediaQuery.of(context).size.height *
                                              0.35
                                          : MediaQuery.of(context).size.height *
                                              0.2,
                                      child: isLoadingGroups
                                          ? Center(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                child:
                                                    const CircularProgressIndicator(
                                                        color: Colors.white),
                                              ),
                                            )
                                          : groupsNumber == 0
                                              ? Center(
                                                  child: Text(
                                                    'You are not in any group :(',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      shadows: [
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
                                                    )),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              : isOnInfoMode.isNotEmpty
                                                  ? Padding(
                                                      padding: EdgeInsets.all(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.025,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              FittedBox(
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    right: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.025,
                                                                  ),
                                                                  child:
                                                                      IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      newUserInGroupFocusNode
                                                                          .unfocus();
                                                                      setState(
                                                                          () {
                                                                        isOnInfoMode =
                                                                            [];
                                                                        detailsVisible =
                                                                            [];
                                                                        users =
                                                                            [];
                                                                        usersNames =
                                                                            [];
                                                                        groupOwner =
                                                                            '';
                                                                        creatingNewGroup =
                                                                            false;
                                                                        hideFloatingButton =
                                                                            false;
                                                                        isLoadingGroups =
                                                                            true;
                                                                      });
                                                                      if (mounted) {
                                                                        loadGroups('')
                                                                            .then((_) {
                                                                          setState(
                                                                              () {
                                                                            isLoadingGroups =
                                                                                false;
                                                                          });
                                                                        });
                                                                      }
                                                                    },
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .navigate_before,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 30,
                                                                      shadows: [
                                                                        Shadow(
                                                                            color: Colors
                                                                                .black,
                                                                            blurRadius:
                                                                                1,
                                                                            offset:
                                                                                Offset(0.5, 0.5)),
                                                                        Shadow(
                                                                            color: Colors
                                                                                .black,
                                                                            blurRadius:
                                                                                1,
                                                                            offset:
                                                                                Offset(-0.5, 0.5)),
                                                                        Shadow(
                                                                            color: Colors
                                                                                .black,
                                                                            blurRadius:
                                                                                1,
                                                                            offset:
                                                                                Offset(0.5, -0.5)),
                                                                        Shadow(
                                                                            color: Colors
                                                                                .black,
                                                                            blurRadius:
                                                                                1,
                                                                            offset:
                                                                                Offset(-0.5, -0.5)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  border:
                                                                      Border(
                                                                    top:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 1,
                                                                    ),
                                                                    bottom:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 1,
                                                                    ),
                                                                    left:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 1,
                                                                    ),
                                                                    right:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 1,
                                                                    ),
                                                                  ),
                                                                ),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.35,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.075,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.all(MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.01),
                                                                    child: Text(
                                                                      isOnInfoMode[
                                                                          0],
                                                                      style: GoogleFonts
                                                                          .lato(
                                                                        textStyle:
                                                                            const TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold,
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
                                                              FittedBox(
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    left: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.025,
                                                                  ),
                                                                  child:
                                                                      IconButton(
                                                                    onPressed:
                                                                        isLoadingDetails
                                                                            ? null
                                                                            : () {
                                                                                hideFloatingButton = false;
                                                                                newUserInGroupFocusNode.unfocus();
                                                                                showAlertDialog(BuildContext context) {
                                                                                  Widget cancelButton = TextButton(
                                                                                    child: Text(
                                                                                      "Cancel",
                                                                                      style: GoogleFonts.lato(
                                                                                        textStyle: const TextStyle(
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                  );
                                                                                  Widget continueButton = TextButton(
                                                                                    onPressed: FirebaseAuth.instance.currentUser!.uid == groupOwner
                                                                                        ? () {
                                                                                            if (mounted) {
                                                                                              setState(() {
                                                                                                creatingNewGroup = false;
                                                                                                isLoadingGroups = true;
                                                                                              });
                                                                                              removeGroup().then((_) {
                                                                                                setState(() {
                                                                                                  isLoadingGroups = false;
                                                                                                });
                                                                                              });
                                                                                            }
                                                                                          }
                                                                                        : () {
                                                                                            if (mounted) {
                                                                                              leaveGroup().then((_) {
                                                                                                setState(() {
                                                                                                  creatingNewGroup = false;
                                                                                                  isLoadingGroups = true;
                                                                                                  isOnInfoMode = [];
                                                                                                  detailsVisible = [];
                                                                                                  users = [];
                                                                                                  usersNames = [];
                                                                                                  groupOwner = '';
                                                                                                });
                                                                                                loadGroups('').then((_) {
                                                                                                  setState(() {
                                                                                                    isLoadingGroups = false;
                                                                                                  });
                                                                                                });
                                                                                              });
                                                                                            }
                                                                                          },
                                                                                    child: Text(
                                                                                      FirebaseAuth.instance.currentUser!.uid == groupOwner ? "Delete the group" : "Leave the group",
                                                                                      style: GoogleFonts.lato(
                                                                                        textStyle: const TextStyle(
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                  AlertDialog alert = AlertDialog(
                                                                                    title: Text(
                                                                                      "Warning",
                                                                                      textAlign: TextAlign.center,
                                                                                      style: GoogleFonts.lato(
                                                                                        textStyle: const TextStyle(
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    content: Text(
                                                                                      FirebaseAuth.instance.currentUser!.uid == groupOwner ? "Are you sure you want to delete the group '${isOnInfoMode[0]}'?" : "Are you sure you want to leave the group '${isOnInfoMode[0]}'?",
                                                                                      textAlign: TextAlign.center,
                                                                                      style: GoogleFonts.lato(
                                                                                        textStyle: const TextStyle(
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    actions: [
                                                                                      cancelButton,
                                                                                      continueButton,
                                                                                    ],
                                                                                  );
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return alert;
                                                                                    },
                                                                                  );
                                                                                }

                                                                                showAlertDialog(context);
                                                                              },
                                                                    icon: Icon(
                                                                      isLoadingDetails
                                                                          ? null
                                                                          : FirebaseAuth.instance.currentUser!.uid == groupOwner
                                                                              ? Icons.delete
                                                                              : Icons.logout,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 30,
                                                                      shadows: const [
                                                                        Shadow(
                                                                            color: Colors
                                                                                .black,
                                                                            blurRadius:
                                                                                1,
                                                                            offset:
                                                                                Offset(0.5, 0.5)),
                                                                        Shadow(
                                                                            color: Colors
                                                                                .black,
                                                                            blurRadius:
                                                                                1,
                                                                            offset:
                                                                                Offset(-0.5, 0.5)),
                                                                        Shadow(
                                                                            color: Colors
                                                                                .black,
                                                                            blurRadius:
                                                                                1,
                                                                            offset:
                                                                                Offset(0.5, -0.5)),
                                                                        Shadow(
                                                                            color: Colors
                                                                                .black,
                                                                            blurRadius:
                                                                                1,
                                                                            offset:
                                                                                Offset(-0.5, -0.5)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.5,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.05,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                FittedBox(
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  child: Text(
                                                                    'Group members',
                                                                    style:
                                                                        GoogleFonts
                                                                            .lato(
                                                                      textStyle:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold,
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
                                                                if (addUserNotEmpty)
                                                                  if (!isLoadingDetails)
                                                                    FittedBox(
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                      child:
                                                                          IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          newUserInGroupFocusNode
                                                                              .unfocus();
                                                                          setState(
                                                                              () {
                                                                            isLoadingDetails =
                                                                                true;
                                                                            users =
                                                                                [];
                                                                            usersNames =
                                                                                [];
                                                                            groupOwner =
                                                                                '';
                                                                            hideFloatingButton =
                                                                                false;
                                                                          });
                                                                          if (mounted) {
                                                                            addUserToGroup(newUserInGroupController.text.trim().toString()).then((_) {
                                                                              loadGroupDetails(isOnInfoMode[0]).then((_) {
                                                                                setState(() {
                                                                                  isLoadingDetails = false;
                                                                                  newUserInGroupController.text = '';
                                                                                  addUserNotEmpty = false;
                                                                                });
                                                                              });
                                                                            });
                                                                          }
                                                                        },
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .person_add,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              30,
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
                                                            ),
                                                          ),
                                                          Container(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.005,
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  horizontal: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.05,
                                                                  vertical: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.02,
                                                                ),
                                                                child:
                                                                    TextFormField(
                                                                  onChanged:
                                                                      (value) {
                                                                    if (value
                                                                            .isNotEmpty ||
                                                                        value !=
                                                                            '') {
                                                                      setState(
                                                                          () {
                                                                        addUserNotEmpty =
                                                                            true;
                                                                      });
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        addUserNotEmpty =
                                                                            false;
                                                                      });
                                                                    }
                                                                  },
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      hideFloatingButton =
                                                                          true;
                                                                    });
                                                                  },
                                                                  onSaved: (_) {
                                                                    setState(
                                                                        () {
                                                                      hideFloatingButton =
                                                                          false;
                                                                    });
                                                                  },
                                                                  onEditingComplete:
                                                                      () {
                                                                    newUserInGroupFocusNode
                                                                        .unfocus();
                                                                    setState(
                                                                        () {
                                                                      hideFloatingButton =
                                                                          false;
                                                                    });
                                                                  },
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    filled:
                                                                        true,
                                                                    prefixIcon:
                                                                        Icon(Icons
                                                                            .person_add),
                                                                    labelText:
                                                                        'User login',
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        10,
                                                                  ),
                                                                  controller:
                                                                      newUserInGroupController,
                                                                  focusNode:
                                                                      newUserInGroupFocusNode,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.6,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.132,
                                                            child: isLoadingDetails
                                                                ? const Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  )
                                                                : ListView.builder(
                                                                    itemCount: usersNames.length,
                                                                    itemBuilder: ((context, index) {
                                                                      return Container(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.6,
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.05,
                                                                        child:
                                                                            FittedBox(
                                                                          fit: BoxFit
                                                                              .scaleDown,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                usersNames[index],
                                                                                style: GoogleFonts.lato(
                                                                                  textStyle: TextStyle(
                                                                                    color: users[index] == FirebaseAuth.instance.currentUser!.uid ? Colors.orange : Colors.white,
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    shadows: const [
                                                                                      Shadow(color: Colors.black, blurRadius: 1, offset: Offset(0.5, 0.5)),
                                                                                      Shadow(color: Colors.black, blurRadius: 1, offset: Offset(-0.5, 0.5)),
                                                                                      Shadow(color: Colors.black, blurRadius: 1, offset: Offset(0.5, -0.5)),
                                                                                      Shadow(color: Colors.black, blurRadius: 1, offset: Offset(-0.5, -0.5)),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              if (users[index] == groupOwner)
                                                                                const Icon(
                                                                                  Icons.add_moderator,
                                                                                  color: Colors.white,
                                                                                  shadows: [
                                                                                    Shadow(color: Colors.black, blurRadius: 1, offset: Offset(0.5, 0.5)),
                                                                                    Shadow(color: Colors.black, blurRadius: 1, offset: Offset(-0.5, 0.5)),
                                                                                    Shadow(color: Colors.black, blurRadius: 1, offset: Offset(0.5, -0.5)),
                                                                                    Shadow(color: Colors.black, blurRadius: 1, offset: Offset(-0.5, -0.5)),
                                                                                  ],
                                                                                ),
                                                                              if (users[index] != FirebaseAuth.instance.currentUser!.uid)
                                                                                if (FirebaseAuth.instance.currentUser!.uid == groupOwner)
                                                                                  IconButton(
                                                                                    onPressed: isLoadingDetails
                                                                                        ? null
                                                                                        : () {
                                                                                            hideFloatingButton = false;
                                                                                            newUserInGroupFocusNode.unfocus();
                                                                                            showAlertDialog(BuildContext context) {
                                                                                              Widget cancelButton = TextButton(
                                                                                                child: Text(
                                                                                                  "Cancel",
                                                                                                  style: GoogleFonts.lato(
                                                                                                    textStyle: const TextStyle(
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  Navigator.of(context).pop();
                                                                                                },
                                                                                              );
                                                                                              Widget continueButton = TextButton(
                                                                                                onPressed: () {
                                                                                                  setState(() {
                                                                                                    isLoadingDetails = true;
                                                                                                  });
                                                                                                  if (mounted) {
                                                                                                    kickUserFromGroup(users[index]).then((_) {
                                                                                                      loadGroupDetails(isOnInfoMode[0]).then((_) {
                                                                                                        setState(() {
                                                                                                          isLoadingDetails = false;
                                                                                                        });
                                                                                                      });
                                                                                                    });
                                                                                                  }
                                                                                                },
                                                                                                child: Text(
                                                                                                  "Kick",
                                                                                                  style: GoogleFonts.lato(
                                                                                                    textStyle: const TextStyle(
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                              AlertDialog alert = AlertDialog(
                                                                                                title: Text(
                                                                                                  "Warning",
                                                                                                  textAlign: TextAlign.center,
                                                                                                  style: GoogleFonts.lato(
                                                                                                    textStyle: const TextStyle(
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                content: Text(
                                                                                                  "Are you sure you want to kick the user ${usersNames[index]} from group '${isOnInfoMode[0]}'?",
                                                                                                  textAlign: TextAlign.center,
                                                                                                  style: GoogleFonts.lato(
                                                                                                    textStyle: const TextStyle(
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                actions: [
                                                                                                  cancelButton,
                                                                                                  continueButton,
                                                                                                ],
                                                                                              );
                                                                                              showDialog(
                                                                                                context: context,
                                                                                                builder: (BuildContext context) {
                                                                                                  return alert;
                                                                                                },
                                                                                              );
                                                                                            }

                                                                                            showAlertDialog(context);
                                                                                          },
                                                                                    icon: const Icon(
                                                                                      Icons.person_remove,
                                                                                      color: Colors.white,
                                                                                      shadows: [
                                                                                        Shadow(color: Colors.black, blurRadius: 1, offset: Offset(0.5, 0.5)),
                                                                                        Shadow(color: Colors.black, blurRadius: 1, offset: Offset(-0.5, 0.5)),
                                                                                        Shadow(color: Colors.black, blurRadius: 1, offset: Offset(0.5, -0.5)),
                                                                                        Shadow(color: Colors.black, blurRadius: 1, offset: Offset(-0.5, -0.5)),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    })),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : ListView.builder(
                                                      itemCount: groupsNumber,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding: EdgeInsets
                                                              .all(MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.025),
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.6,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.05,
                                                            child: ListTile(
                                                              trailing: detailsVisible
                                                                      .contains(
                                                                          allGroups[
                                                                              index])
                                                                  ? IconButton(
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .info,
                                                                        color: Colors
                                                                            .white,
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
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          isLoadingDetails =
                                                                              true;
                                                                          isOnInfoMode
                                                                              .add(allGroups[index]);
                                                                        });
                                                                        if (mounted) {
                                                                          loadGroupDetails(allGroups[index])
                                                                              .then((_) {
                                                                            setState(() {
                                                                              isLoadingDetails = false;
                                                                            });
                                                                          });
                                                                        }
                                                                      },
                                                                    )
                                                                  : null,
                                                              title: Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Colors
                                                                      .orange,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20)),
                                                                ),
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.1,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fitWidth,
                                                                  child:
                                                                      TextButton(
                                                                    child:
                                                                        Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.6,
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.05,
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        child:
                                                                            Text(
                                                                          '${allGroups[index].toString()} (${allOwnersNames[index]})',
                                                                          style: GoogleFonts.lato(
                                                                              textStyle: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                20,
                                                                            shadows: [
                                                                              Shadow(color: Colors.black, blurRadius: 1, offset: Offset(0.5, 0.5)),
                                                                              Shadow(color: Colors.black, blurRadius: 1, offset: Offset(-0.5, 0.5)),
                                                                              Shadow(color: Colors.black, blurRadius: 1, offset: Offset(0.5, -0.5)),
                                                                              Shadow(color: Colors.black, blurRadius: 1, offset: Offset(-0.5, -0.5)),
                                                                            ],
                                                                          )),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        if (detailsVisible
                                                                            .contains(allGroups[index])) {
                                                                          detailsVisible
                                                                              .remove(allGroups[index]);
                                                                        } else {
                                                                          detailsVisible
                                                                              .add(allGroups[index]);
                                                                        }
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (!isNewUser)
                          if (!creatingNewGroup)
                            if (isOnInfoMode.isEmpty)
                              Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height * 0.03),
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      creatingNewGroup = true;
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.redAccent.shade400
                                          .withOpacity(0.9),
                                    ),
                                  ),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'Create a new group',
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
                              ),
                        if (creatingNewGroup && isOnInfoMode.isEmpty)
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.05,
                                left: MediaQuery.of(context).size.width * 0.15,
                                right:
                                    MediaQuery.of(context).size.width * 0.15),
                            child: Stack(
                              children: [
                                CustomPaint(
                                  size: Size(
                                    MediaQuery.of(context).size.width * 0.7,
                                    MediaQuery.of(context).size.height * 0.2,
                                  ),
                                  painter: RPSCustomPainter(),
                                ),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.height *
                                          0.025,
                                    ),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                creatingNewGroup = false;
                                                newGroupController.text = '';
                                                hideFloatingButton = false;
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black,
                                                  offset: Offset(0.5, 0.5),
                                                  blurRadius: 1,
                                                ),
                                                Shadow(
                                                  color: Colors.black,
                                                  offset: Offset(0.5, -0.5),
                                                  blurRadius: 1,
                                                ),
                                                Shadow(
                                                  color: Colors.black,
                                                  offset: Offset(-0.5, 0.5),
                                                  blurRadius: 1,
                                                ),
                                                Shadow(
                                                  color: Colors.black,
                                                  offset: Offset(-0.5, -0.5),
                                                  blurRadius: 1,
                                                )
                                              ],
                                            ),
                                            color: Colors.white,
                                            iconSize: 35,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              if (newGroupController.text
                                                  .toString()
                                                  .isNotEmpty) {
                                                setState(() {
                                                  creatingNewGroup = false;
                                                });
                                                if (mounted) {
                                                  addNewGroup();
                                                }
                                              }
                                              setState(() {
                                                newGroupController.text = '';
                                                hideFloatingButton = false;
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.done,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black,
                                                  offset: Offset(0.5, 0.5),
                                                  blurRadius: 1,
                                                ),
                                                Shadow(
                                                  color: Colors.black,
                                                  offset: Offset(0.5, -0.5),
                                                  blurRadius: 1,
                                                ),
                                                Shadow(
                                                  color: Colors.black,
                                                  offset: Offset(-0.5, 0.5),
                                                  blurRadius: 1,
                                                ),
                                                Shadow(
                                                  color: Colors.black,
                                                  offset: Offset(-0.5, -0.5),
                                                  blurRadius: 1,
                                                )
                                              ],
                                            ),
                                            color: Colors.green,
                                            iconSize: 35,
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                'Create a group',
                                                style: GoogleFonts.lato(
                                                  color: Colors.white,
                                                  textStyle: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    shadows: [
                                                      Shadow(
                                                          color: Colors.black,
                                                          blurRadius: 1,
                                                          offset:
                                                              Offset(0.5, 0.5)),
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
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              vertical: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02,
                                            ),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                filled: true,
                                                prefixIcon: Icon(Icons.group),
                                                labelText: 'Group name',
                                                fillColor: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                              controller: newGroupController,
                                              focusNode: newGroupFocusNode,
                                              onTap: () {
                                                setState(() {
                                                  hideFloatingButton = true;
                                                });
                                              },
                                              onFieldSubmitted: ((value) {
                                                setState(() {
                                                  hideFloatingButton = false;
                                                });
                                              }),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  )
                : isOnPage == 1
                    ? WriteNoteScreen(
                        userData: widget.userData,
                      )
                    : isOnPage == 4
                        ? AddFilesScreen(
                            userData: widget.userData,
                          )
                        : const DiscoverFilesScreen(),
          )),
    );
  }
}
