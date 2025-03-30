import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/user_provider.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.docs;

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final post = Post.fromSnap(data[index]);

            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(8),
                height: 540,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                post.profImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(post.username),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Post Deleted")),
                              );
                            },
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Caption
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(post.caption),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Post Image
                    Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: NetworkImage(post.postUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Interaction Icons
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                            const Icon(Icons.favorite_border),
                            const Icon(Icons.chat_bubble_outline),
                            const Icon(Icons.send),
                            IconButton(
                            icon: Icon(
                                post.bookmarkedBy.contains(userProvider.getUser.uid)
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                            ),
                            onPressed: () async {
                                final docRef = FirebaseFirestore.instance.collection('posts').doc(post.postId);
                                final currentBookmarks = post.bookmarkedBy;

                                if (currentBookmarks.contains(userProvider.getUser.uid)) {
                                await docRef.update({
                                    'bookmarkedBy': FieldValue.arrayRemove([userProvider.getUser.uid])
                                });
                                } else {
                                await docRef.update({
                                    'bookmarkedBy': FieldValue.arrayUnion([userProvider.getUser.uid])
                                });
                                }
                            },
                            ),
                        ],
                      ),

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
