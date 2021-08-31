import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasteagram/models/postData.dart';
import 'new_post.dart';
import 'details_page.dart';

class EntryLists extends StatefulWidget {
  const EntryLists({Key? key}) : super(key: key);

  @override
  _EntryListsState createState() => _EntryListsState();
}

class _EntryListsState extends State<EntryLists> {
  num? finalTotal;

  @override
  Widget build(BuildContext context) {
    final dbSend = WriteToDB();
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        num newCount = 0;
        if (snapshot.hasData) {
          for (var i = 0; i < snapshot.data!.docs.length; i++) {
            newCount += snapshot.data!.docs[i]['quantity'];
          }
        }
        if (snapshot.hasData && snapshot.data!.docs.length > 0) {
          return Scaffold(
            appBar: AppBar(title: Text('Wasteagram - $newCount')),
            body: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var post = snapshot.data!.docs[index];
                return ListTile(
                  title: Text(post['date'].toString(),
                      style: TextStyle(fontSize: 20)),
                  trailing: Text(post['quantity'].toString(),
                      style: TextStyle(fontSize: 20)),
                  onTap: () {
                    dbSend.date = post['date'].toString();
                    dbSend.imgurl = post['imgurl'].toString();
                    dbSend.quantity = post['quantity'];
                    dbSend.latitude = post['latitude'].toString();
                    dbSend.longitude = post['longitude'].toString();
                    print(dbSend.date);

                    Navigator.of(context)
                        .pushNamed(RowDetail.routeNames, arguments: dbSend);
                  },
                );
              },
            ),
            floatingActionButton: NewEntryButton(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget NewEntryButton() {
    return FloatingActionButton(
      child: Icon(Icons.camera_alt),
      onPressed: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NewPost()));
        ;
      },
    );
  }
}
