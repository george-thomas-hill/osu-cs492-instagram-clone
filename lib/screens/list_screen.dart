import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'new_entry_screen.dart';
import '../models/food_waste_post.dart';
import '../screens/details_screen.dart';
import '../widgets/app_bar_widget.dart';

class ListScreen extends StatefulWidget {

  static const routeName = '/';

  @override
  _ListScreenState createState() => _ListScreenState();

}

class _ListScreenState extends State<ListScreen> {

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fab(),
      body: streamBuilderWidget(context),
    );
  }

  Widget fab() {
    return Semantics(
      child: FloatingActionButton(
        onPressed: addPhoto,
        child: Icon(Icons.add),
      ),
      label: 'Add photo.',
      hint: 'Add photo.',
      onTapHint: 'Add photo.',
      button: true,
    );
  }

  void addPhoto() async {
    await getImage();
    Navigator.of(context).pushNamed(
      NewEntryScreen.routeName,
      arguments: _image,
    );
  }

  Widget streamBuilderWidget(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('photos')
        .orderBy('dateTime', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.documents.length > 0) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              var post = snapshot.data.documents[index];

              var foodWastePost = FoodWastePost(
                post['imageURL'],
                post['quantity'],
                post['latitude'],
                post['longitude'],
                formatTheDate(post['dateTime']),
              );

              return Semantics(
                child: ListTile(
                  title: Text(foodWastePost.date),
                  trailing: Text(
                    foodWastePost.quantity.toString(),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      DetailsScreen.routeName,
                      arguments: foodWastePost,
                    );
                  },
                ),
                hint: 'Tap to open.',
                label: 'Tap to open.',
                onTapHint: 'Tap to open.',
              );
            }
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

  String formatTheDate(Timestamp timestamp) {
    // https://stackoverflow.com/questions/50632217/dart-flutter-converting-timestamp
    var formater = DateFormat('EEEE, MMMM dd, yyyy');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    return formater.format(date);
  }

}
