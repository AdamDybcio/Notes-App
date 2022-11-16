import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Repository {
  Future listGroups(String? removeGroupId, List allGroupsList,
      List allGroupsIdsList, List allOwnersList, List allOwnersIdsList) async {
    String? removeId = removeGroupId;
    allGroupsList.clear();
    allGroupsIdsList.clear();
    allOwnersIdsList.clear();
    allOwnersList.clear();

    var ref = await FirebaseFirestore.instance.collection('groups').get();

    if (ref.docs.isNotEmpty) {
      for (var doc2 in ref.docs) {
        if (doc2.id != removeGroupId) {
          var ref2 =
              await FirebaseFirestore.instance.doc('groups/${doc2.id}').get();
          var ref3 = ref2.data();
          var refA = await FirebaseFirestore.instance
              .collection('groups/${doc2.id}/members')
              .get();
          for (var doc in refA.docs) {
            if (doc.id == FirebaseAuth.instance.currentUser!.uid) {
              allGroupsIdsList.add(doc2.id);
              allGroupsList.add(ref3?['name']);
              allOwnersIdsList.add(ref3?['owner']);
              var ref5 = await FirebaseFirestore.instance
                  .doc('users/${ref3?['owner']}')
                  .get();
              var ref6 = ref5.data();
              allOwnersList.add(ref6?['login']);
            }
          }
        }
      }
    }

    allOwnersList.removeWhere((element) => element == null);
    allGroupsList.removeWhere((element) => element == null);
    allGroupsIdsList.removeWhere((element) => element == null);
    allOwnersIdsList.removeWhere((element) => element == null);

    return [allGroupsList, allGroupsIdsList, allOwnersList, allOwnersIdsList];
  }

  Future checkIfNewUser(bool isNewUser) async {
    var ref = await FirebaseFirestore.instance.collection('users').get().then(
          (value) => value.docs.where(
            (element) => (element.id == FirebaseAuth.instance.currentUser!.uid),
          ),
        );
    var ref2 =
        await FirebaseFirestore.instance.doc('users/${ref.first.id}').get();
    if (ref2.data()!.values.first == '') {
      isNewUser = true;
    } else {
      isNewUser = false;
    }
    return isNewUser;
  }
}
