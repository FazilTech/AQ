import 'package:aq/services/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImagePost extends StatelessWidget {
  final String imageUrl;

  const ImagePost({
    super.key,
    required this.imageUrl
    });

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(
      builder: (context, storageService, child) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
        child: Column(
          children: [
            // delete button
            IconButton(
              onPressed: ()=> storageService.deleteImages(imageUrl), 
              icon: Icon(
                Icons.delete
              )
            ),

            // image post
            Image.network(
              imageUrl,
              scale: 10,
              loadingBuilder: (context, child, loadingProgress) {
                // loading..
                if (loadingProgress != null){
                  return SizedBox(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null 
                        ? loadingProgress.cumulativeBytesLoaded / 
                        loadingProgress.expectedTotalBytes! 
                        : null,
                      ),
                    ),
                  );
                }
                else{
                  return child;
                }
              },
              )
          ],
        ),
      )
    );
  }
}