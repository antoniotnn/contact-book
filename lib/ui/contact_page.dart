import 'dart:io';

//import 'package:contact_book/widgets/image_source_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  final _nameFocus = FocusNode();

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
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact!.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact!.name != null &&
                _editedContact!.name!.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
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
                        : const AssetImage('images/person.png')
                            as ImageProvider,
                    fit: BoxFit.cover
                  ),
                ),
              ),
              onTap: () {
                _showPhotoSourceOptions(context, _editedContact);// ignore: invalid_use_of_visible_for_testing_member
                // ImagePicker.platform.pickImage(source: ImageSource.gallery)
                //   .then((file) {
                //     if(file == null) return;
                //     setState(() {
                //       _editedContact!.img = file.path;
                //     });
                //   }
                // );
                // showModalBottomSheet(
                //   context: context,
                //   builder: (context) => ImageSourceSheet(
                    
                //     onImageSelected: (image) {
                //       // ignore: avoid_print
                //       //print('tipo da imagem : $image');
                //       if(image==null) {
                //         return;
                //       }
                //       //_editedContact!.img = image.path;

                //     },
                //   ),
                // );
              },
            ),
            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
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
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Descartar alterações?'),
            content: const Text('Se sair, as alterações serão perdidas.'),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Sim'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  void _showPhotoSourceOptions(BuildContext context, Contact? _editedContact) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      child: const Text(
                        'Câmera',
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // ignore: invalid_use_of_visible_for_testing_member
                        ImagePicker.platform.pickImage(source: ImageSource.camera) //preferredCameraDevice: CameraDevice.front
                          .then((file) {
                            if(file == null) return;
                            setState(() {
                              _editedContact!.img = file.path;
                            });
                          }
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      child: const Text(
                        'Galeria',
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // ignore: invalid_use_of_visible_for_testing_member
                        ImagePicker.platform.pickImage(source: ImageSource.gallery)
                          .then((file) {
                            if(file == null) return;
                            setState(() {
                              _editedContact!.img = file.path;
                            });
                          }
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }

}
