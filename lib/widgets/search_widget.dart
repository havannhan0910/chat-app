import 'package:canary_chat/screens/main_screen/chat_screen.dart';
import 'package:canary_chat/services/firestore_service.dart';
import 'package:canary_chat/widgets/chat_room_list.dart';
import 'package:canary_chat/widgets/contact_list.dart';
import 'package:canary_chat/widgets/search_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _txtSearch = TextEditingController();

  final _firestore = FireStoreService();

  QuerySnapshot? snapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
        // height: double.infinity,
        // width: double.infinity,
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.centerEnd,
              children: [
                TextFormField(
                  controller: _txtSearch,
                  decoration: InputDecoration(
                    hintText: "Nhập tên",
                    labelText: "Tìm bạn bè...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _firestore.getUserByUserName(_txtSearch.text).then((value) {
                      setState(() {
                        snapshot = value;
                      });
                      _txtSearch.clear();
                    });

                    _firestore.getUserByEmail(_txtSearch.text).then((value) {
                      setState(() {
                        snapshot = value;
                      });
                      _txtSearch.clear();
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: snapshot != null
                  ? SearchList(searchSnapshot: snapshot!)
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
