import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../login_screen.dart';
import '../methods/auth_methods.dart';
import '../methods/user_storage.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;

  // Select from Gallery
  void selectImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
  }

  // Select from Camera
  void selectImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Profile Picture"),
        backgroundColor: const Color.fromARGB(218, 226, 37, 24),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),

          // Profile Image (if selected)
          Center(
            child: _image != null
                ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  )
                : const CircleAvatar(
                    radius: 64,
                    backgroundImage: AssetImage('assets/images/logo.webp'),
                  ),
          ),

          const SizedBox(height: 20),

          // Pick from Camera & Gallery
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.photo_camera),
                onPressed: selectImageFromCamera,
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.photo_library),
                onPressed: selectImageFromGallery,
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Continue Button
          ElevatedButton(
            onPressed: () async {
              if (_image != null) {
                String res = await AuthMethods().signUpUser(
                  email: widget.email,
                  password: widget.password,
                  username: widget.username,
                  file: _image!,
                );

                if (res == "success") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Account created successfully")),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(res)),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select an image")),
                );
              }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                const Color.fromARGB(218, 226, 37, 24),
              ),
            ),
            child: const Text(
              "Continue",
              style: TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(height: 20),

          // Username Preview
          Text(
            "Username: ${widget.username}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
