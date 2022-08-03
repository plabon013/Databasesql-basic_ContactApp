import 'dart:io';

import 'package:contact_app/db/db_helper.dart';
import 'package:contact_app/model/contact_model.dart';
import 'package:contact_app/provider/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewContactPage extends StatefulWidget {
  static const String routeName = '/new_contact';

  // const NewContactPage({Key? key}) : super(key: key);


  @override
  State<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  final nameControler = TextEditingController();
  final numberControler = TextEditingController();
  final emailControler = TextEditingController();
  final addressControler = TextEditingController();
  String? _dob;
  String? _genderGroupValue;
  String? _imagePath;
  ImageSource _imagesource = ImageSource.camera;
  final from_key = GlobalKey<FormState>();

  @override
  void dispose() {
    nameControler.dispose();
    numberControler.dispose();
    emailControler.dispose();
    addressControler.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Contact'),
        actions: [IconButton(onPressed: _savecontact, icon: Icon(Icons.save))],
      ),
      body: Form(
        key: from_key,
        child: ListView(
          children: [
            TextFormField(
              controller: nameControler,
              decoration: InputDecoration(
                  labelText: 'Name', prefixIcon: Icon(Icons.person)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                if (value.length > 20) {
                  return 'Name must be in 20 character';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: numberControler,
              decoration: InputDecoration(
                  labelText: 'Number', prefixIcon: Icon(Icons.numbers)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                if (value.length > 20) {
                  return 'Name must be in 20 character';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: emailControler,
              decoration: InputDecoration(
                  labelText: 'email', prefixIcon: Icon(Icons.email)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                if (value.length > 20) {
                  return 'Name must be in 20 character';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: addressControler,
              decoration: InputDecoration(
                  labelText: 'Address', prefixIcon: Icon(Icons.navigation)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                if (value.length > 20) {
                  return 'Name must be in 20 character';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              child: Row(
                children: [
                  TextButton(
                      onPressed: _selectDate, child: Text('Select Date')),
                  Text(_dob == null ? 'No Date Choosen' : _dob!),
                ],
              ),
            ),
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Select Gender'),
                  Radio<String>(
                      value: 'Male',
                      groupValue: _genderGroupValue,
                      onChanged: (value) {
                        setState(() {
                          _genderGroupValue = value;
                        });
                      }),
                  Text('Male'),
                  Radio<String>(
                      value: 'Female',
                      groupValue: _genderGroupValue,
                      onChanged: (value) {
                        setState(() {
                          _genderGroupValue = value;
                        });
                      }),
                  Text('Female'),
                  Radio<String>(
                      value: 'Other',
                      groupValue: _genderGroupValue,
                      onChanged: (value) {
                        setState(() {
                          _genderGroupValue = value;
                        });
                      }),
                  Text('Other'),
                ],
              ),
            ),
            Card(
                elevation: 5,
                child: _imagePath == null
                    ? Image.asset(
                        'Images/download.png',
                        height: 100,
                        width: 100,
                        fit: BoxFit.contain,
                      )
                    : Image.file(
                        File(_imagePath!),
                        height: 100,
                        width: 100,
                        fit: BoxFit.contain,
                      )),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      _imagesource = ImageSource.camera;
                      _getImage();
                    },
                    child: Text('Camera')),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      _imagesource = ImageSource.gallery;
                      _getImage();
                    },
                    child: Text('Gellary')),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _savecontact() async {
    if (from_key.currentState!.validate()) {
      final contact = ContactModel(
        name: nameControler.text,
        number: numberControler.text,
        email: emailControler.text,
        address: addressControler.text,
        dob: _dob,
        gender: _genderGroupValue,
        image: _imagePath,
      );

      print(contact.toString());
      final status =
          await Provider.of<ContactProvider>(context, listen: false).addNewContact(contact);
      if (status) {
        Navigator.pop(context);
      }
    }
  }

  void _selectDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1914),
        lastDate: DateTime.now());
    if (selectedDate != null) {
      setState(() {
        _dob = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  void _getImage() async {
    final selectImage = await ImagePicker().pickImage(source: _imagesource);
    if (selectImage != null) {
      setState(() {
        _imagePath = selectImage.path;
      });
    }
  }
}
