import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';
import '../../home.dart';
import '../methods/post_storage.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  Uint8List? _image;
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void selectImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => _image = bytes);
    }
  }

  void selectImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => _image = bytes);
    }
  }

  void postImage(String uid, String username, String profImage) async {
    if (_image == null || _captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add an image and caption.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    String res = await PostStorage().uploadPost(
      _captionController.text,
      uid,
      username,
      profImage,
      _image!,
    );
    setState(() => _isLoading = false);

    if (res == "Ok") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Posted successfully!")),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Userd user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(218, 226, 37, 24),
        title: const Text('New Post'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () => postImage(user.uid, user.username, user.photoUrl),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            _isLoading ? const LinearProgressIndicator() : const SizedBox.shrink(),
            const SizedBox(height: 20),
            _image != null
                ? Image.memory(
                    _image!,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image, size: 150),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.photo_camera), onPressed: selectImageFromCamera),
                const SizedBox(width: 20),
                IconButton(icon: const Icon(Icons.photo_library), onPressed: selectImageFromGallery),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _captionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: "Write a caption...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
