import 'dart:io';
import 'package:aq/components/my_button.dart';
import 'package:aq/pages/prediction_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FlashpPage extends StatefulWidget {
  const FlashpPage({super.key});

  @override
  State<FlashpPage> createState() => _FlashpPageState();
}

class _FlashpPageState extends State<FlashpPage> {
  File? _image;
  String _prediction = "";
  double _confidence = 0.0;
  bool _loading = false;

  final ImagePicker _picker = ImagePicker();

  // Pick an image from Gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _prediction = "";
        _confidence = 0.0;
      });
    }
  }

  // Capture image using Camera
  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _prediction = "";
        _confidence = 0.0;
      });
    }
  }

  // Send image to Flask backend
  Future<void> _predictImage() async {
    if (_image == null) return;

    setState(() {
      _loading = true;
    });

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("http://192.168.55.132:5000/predict"), // Change to your local IP
    );
    request.files.add(await http.MultipartFile.fromPath("image", _image!.path));

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      setState(() {
        _prediction = jsonResponse["prediction"];
        _confidence = jsonResponse["confidence"];
        _loading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        _loading = false;
        _prediction = "Error: Could not get prediction";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Water Quality Detection")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!, height: 200)
                : Icon(Icons.image, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyButton(
                  color: const Color.fromRGBO(0, 53, 102, 1),
                  onTap: _pickImageFromGallery, 
                  text: "Pick Pic"
                  ),
                const SizedBox(width: 10),
                MyButton(
                  color: const Color.fromRGBO(0, 53, 102, 1),
                  onTap: _captureImage, 
                  text: "Capture"
                  ),
              ],
            ),
            const SizedBox(height: 10),
            _image != null
                ? ElevatedButton(
                    onPressed: _predictImage,
                    child: _loading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Predict"),
                  )
                : SizedBox(),
            SizedBox(height: 20),
            _prediction.isNotEmpty
                ? Text(
                    "Prediction: $_prediction\nConfidence: ${(_confidence * 100).toStringAsFixed(2)}%",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}