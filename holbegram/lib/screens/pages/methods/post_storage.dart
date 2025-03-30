import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../../screens/auth/methods/user_storage.dart';

class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String caption,
    String uid,
    String username,
    String profImage,
    Uint8List image,
  ) async {
    String res = "Some error occurred";
    try {
      String postUrl = await StorageMethods().uploadImageToStorage(
        true,
        'posts',
        image,
      );

      String postId = const Uuid().v1();

      await _firestore.collection('posts').doc(postId).set({
        'caption': caption,
        'uid': uid,
        'username': username,
        'postId': postId,
        'datePublished': DateTime.now(),
        'postUrl': postUrl,
        'profImage': profImage,
        'likes': [],
      });
      res = "Ok";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> deletePost(String postId, String publicId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      // Optional: If you're managing images via Cloudinary, call the delete API.
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }
}
