import 'package:aq/components/image_post.dart';
import 'package:aq/services/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {

  @override
  void initState(){
    super.initState();

    fetchImages();
  }

  // fetch images
  Future<void> fetchImages() async{
    await Provider.of<StorageService>(context, listen: false).fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(
        builder: (context, StorageService, child){
          // list of image urls
          final List<String> imageUrls = StorageService.imageUrls;

          // home page UI
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: ()=> StorageService.uploadImage(),
              child: const Icon(Icons.add),
              ),
              body: ListView.builder(
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  // get each induvidial image
                  final String imageUrl = imageUrls[index];

                  // image post UI
                  return ImagePost(
                    imageUrl: imageUrl
                    );
                },
              ),
        );
      }
    );
  }
}