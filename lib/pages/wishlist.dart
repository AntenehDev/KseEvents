import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:KseEvents/controllers/authentications.dart';
import 'package:KseEvents/main.dart';

class WishlistPage extends StatefulWidget {
  final String uid;

  WishlistPage({Key key, @required this.uid}) : super(key: key);

  @override
  _WishlistPageState createState() => _WishlistPageState(uid);
}

class _WishlistPageState extends State<WishlistPage> {
  final String uid;
  _WishlistPageState(this.uid);

  var whishlistcollections = Firestore.instance.collection('whishlists');
  String whishlist;

  void showdialog(bool isUpdate, DocumentSnapshot ds) {
    GlobalKey<FormState> formkey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:
                isUpdate ? Text("Update Wishlist") : Text("Add Wishlist Event"),
            content: Form(
              key: formkey,
              autovalidate: true,
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Wishlist Event",
                ),
                validator: (_val) {
                  if (_val.isEmpty) {
                    return "Can't Be Empty";
                  } else {
                    return null;
                  }
                },
                onChanged: (_val) {
                  whishlist = _val;
                },
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                color: Colors.black,
                onPressed: () {
                  if (formkey.currentState.validate()) {
                    formkey.currentState.save();
                    if (isUpdate) {
                      whishlistcollections
                          .document(uid)
                          .collection('whishlist')
                          .document(ds.documentID)
                          .updateData({
                        'whishlist': whishlist,
                        'time': DateTime.now(),
                      });
                    } else {
                      //  insert
                      whishlistcollections
                          .document(uid)
                          .collection('whishlist')
                          .add({
                        'whishlist': whishlist,
                        'time': DateTime.now(),
                      });
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Add",
                  style: TextStyle(
                    fontFamily: "tepeno",
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => showdialog(false, null),
        child: Icon(
          Icons.add,
          color: Colors.green,
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Wishlist",
          style: TextStyle(
            fontFamily: "tepeno",
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.green,
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () => signOutUser().then((value) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false);
            }),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: whishlistcollections
            .document(uid)
            .collection('whishlist')
            .orderBy('time')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.documents[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      ds['whishlist'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "tepeno",
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    onLongPress: () {
                      // delete
                      whishlistcollections
                          .document(uid)
                          .collection('whishlist')
                          .document(ds.documentID)
                          .delete();
                    },
                    onTap: () {
                      // == Update
                      showdialog(true, ds);
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return CircularProgressIndicator();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
