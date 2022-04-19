import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/contact_helper.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;

  const ContactPage({Key? key, this.contact}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _userEdited = false;

  Contact? _editedContact;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact!.toMap());

      _nameController.text = _editedContact!.name as String;
      _emailController.text = _editedContact!.email as String;
      _phoneController.text = _editedContact!.phone as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editedContact!.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          GestureDetector(
            child: Container(
              width: 140.0,
              height: 140.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: _editedContact!.img != null
                      ? FileImage(File(_editedContact!.img!))
                      : const AssetImage('images/person.png') as ImageProvider,
                ),
              ),
            ),
          ),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Nome"),
            onChanged: (text) {
              _userEdited = true;
              setState(() {
                _editedContact!.name = text;
              });
            },
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email"),
            onChanged: (text) {
              _userEdited = true;
              _editedContact!.email = text;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: "Phone"),
            onChanged: (text) {
              _userEdited = true;
              _editedContact!.phone = text;
            },
            keyboardType: TextInputType.phone,
          )
        ]),
      ),
    );
  }
}
