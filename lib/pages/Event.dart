import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future _data;
  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("events").getDocuments();
    return qn.documents;
  }

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  post: post,
                )));
  }

  @override
  void initState() {
    super.initState();
    _data = getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _data,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading ..."),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      leading: const Icon(Icons.event),
                      title: Text(snapshot.data[index].data["title"]),
                      subtitle: Text(snapshot.data[index].data["location"]),
                      onTap: () => navigateToDetail(snapshot.data[index]),
                    );
                  });
            }
          }),
    );
  }
}

class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;

  DetailPage({this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.data["title"]),
      ),
      body: Container(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Wrap(
                      children: <Widget>[
                        Text(
                          widget.post.data["title"],
                          style: new TextStyle(fontSize: 30.0),
                        ),
                        Spacer(),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 30.0),
                    child: Wrap(
                      children: <Widget>[
                        Icon(
                          Icons.map_rounded,
                          color: Colors.green,
                        ),
                        SizedBox(width: 8.0),
                        Text(widget.post.data["location"]),
                        Spacer(),
                        //Icon(Icons.people),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Wrap(
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          color: Colors.green,
                        ),
                        Text(
                          widget.post.data["date"],
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Spacer(),
                        //Icon(Icons.info_outline),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Wrap(
                      children: <Widget>[
                        Icon(
                          Icons.info_outline,
                          color: Colors.green,
                        ),
                        Text(
                          widget.post.data["about"],
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Spacer(),
                        //Icon(Icons.info_outline),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
