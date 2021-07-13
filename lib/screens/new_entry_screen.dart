import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../db/entry_dto.dart';
import '../widgets/app_bar_widget.dart';

class NewEntryScreen extends StatefulWidget {

  static const routeName = 'newEntryScreen';

  @override
  _NewEntryScreenState createState() => _NewEntryScreenState();

}

class _NewEntryScreenState extends State<NewEntryScreen> {

  File _image;
  final _entryValues = EntryDTO();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _image = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBarWidget(),
      body: Form(
        key: formKey,
        child: formContent(context),
      )
    );
  }

  Widget formContent(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Semantics(
              child: Image.file(
                _image,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              hint: 'Photo that will be uploaded.',
              label: 'Photo that will be uploaded.',
            ),

            SizedBox(height: 10.0),

            numberInput(),

            SizedBox(height: 10.0),

            uploadButton(context),

          ],
        ),
      ),
    );
  }

  Widget numberInput() {
    return Semantics(
      child: TextFormField(
        // https://stackoverflow.com/questions/49577781/how-to-create-number-input-field-in-flutter
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Enter number of wasted items:',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ], // Only numbers can be entered
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter a number.';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          _entryValues.quantity = int.parse(value);
        },
      ),
      label: 'Enter number of wasted items.',
      hint: 'Enter number of wasted items.',
    );
  }

  Widget uploadButton(BuildContext context) {
    return Semantics(
      child: ButtonTheme(
        // https://stackoverflow.com/questions/50293503/how-to-set-the-width-of-a-raisedbutton-in-flutter
        minWidth: 200,
        height: 100,
        child: RaisedButton(
          child: Icon(
            Icons.cloud_upload,
            size: 90,
          ),
          onPressed: () async { 
            if (formKey.currentState.validate()) {
              formKey.currentState.save();

              await addLatitudeAndLongitudeToEntryValues();
              addDateToEntryValues();

              StorageReference storageReference =
                FirebaseStorage.instance.ref().child(uniqueName());
              StorageUploadTask uploadTask = storageReference.putFile(_image);
              await uploadTask.onComplete;
              _entryValues.imageURL = await storageReference.getDownloadURL();

              Firestore.instance.collection('photos').add({
                'imageURL': _entryValues.imageURL,
                'quantity': _entryValues.quantity,
                'latitude': _entryValues.latitude,
                'longitude': _entryValues.longitude,
                'dateTime': _entryValues.dateTime,
              });

              Navigator.of(context).pop();
            }
          }
        ),
      ),
      hint: 'Upload.',
      label: 'Upload.',
      onTapHint: 'Upload.',
      button: true,
    );
  }

  Future addLatitudeAndLongitudeToEntryValues() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        _entryValues.latitude = 0.0;
        _entryValues.longitude = 0.0;
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        _entryValues.latitude = 0.0;
        _entryValues.longitude = 0.0;
        return;
      }
    }

    _locationData = await location.getLocation();

    _entryValues.latitude = _locationData.latitude;
    _entryValues.longitude = _locationData.longitude;
  }

  void addDateToEntryValues() {
    _entryValues.dateTime = DateTime.now();
  }

  String uniqueName() {
    return DateFormat('yyyy-MM-dd HH-mm-ss.S').format(new DateTime.now());
  }

}
