// import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:gallery_saver/gallery_saver.dart';

class ImageProcessScreen extends StatefulWidget {
  final String mode;
  const ImageProcessScreen({super.key, required this.mode});

  @override
  _ImageProcessScreenState createState() => _ImageProcessScreenState();
}

class _ImageProcessScreenState extends State<ImageProcessScreen> {
  File? _selectedImage;
  Uint8List? _outputImage;
  final picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _outputImage = null;
      });
    }
  }

  Future<void> _processImage() async {
    if (_selectedImage == null) return;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://cryptographer-backend.onrender.com/image_cipher'),
    );

    request.fields['mode'] = widget.mode;
    request.fields['key'] = '10';
    request.files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final imageBytes = await response.stream.toBytes();
      setState(() {
        _outputImage = imageBytes;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to process image")),
      );
    }
  }


  //--------------------mediastoreapi method---------------------
  static const platform = MethodChannel('cryptographer.image/save');

  Future<void> _downloadImage() async {
    if (_outputImage == null) return;

    try {
      final result = await platform.invokeMethod('saveImageToGallery', {
        "bytes": _outputImage,
        "name": 'encrypted_image_${DateTime.now().millisecondsSinceEpoch}.png',
      });

      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image saved to gallery")),
        );
      } else {
        throw Exception("Saving failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save image: $e")),
      );
    }
  }



  //----------------------image_gallery_saver method--------------------------------
  // Future<void> _downloadImage() async {
  //   if (_outputImage == null) return;

  //   final result = await ImageGallerySaver.saveImage(
  //     _outputImage!,
  //     name: 'encrypted_image_${DateTime.now().millisecondsSinceEpoch}',
  //     quality: 100,
  //   );

  //   if (result['isSuccess'] == true || result['filePath'] != null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Image saved to Gallery")),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to save image")),
  //     );
  //   }
  // }



  // -----------------------permission_handler method--------------------------
  //   Future<void> _downloadImage() async {
  //   if (_outputImage == null) return;

  //   // Request storage permission
  //   final status = await Permission.storage.request();
  //   if (!status.isGranted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Storage permission denied")),
  //     );
  //     return;
  //   }

  //   final downloadsDir = Directory('/storage/emulated/0/Download');
  //   final file = File('${downloadsDir.path}/encrypted_image_${DateTime.now().millisecondsSinceEpoch}.png');
  //   await file.writeAsBytes(_outputImage!);

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("Image saved to Downloads")),
  //   );
  // }


  // ---------------------------gallery_saver method--------------------------------

  //   Future<void> _downloadImage() async {
  //   if (_outputImage == null) return;
  //   final tempDir = await getTemporaryDirectory();
  //   final file = File('${tempDir.path}/output.png');
  //   await file.writeAsBytes(_outputImage!);
  //   await GallerySaver.saveImage(file.path);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("Image saved to gallery")),
  //   );
  // }



  // -----------------------save to application loaction method------------------------------------------------
  // Future<void> _downloadImage() async {
  //   if (_outputImage == null) return;
  //   final dir = await getApplicationDocumentsDirectory();
  //   final file = File('${dir.path}/output.png');
  //   await file.writeAsBytes(_outputImage!);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("Image saved to documents")),
  //   );
  // }

  void _shareImage() async {
    if (_outputImage == null) return;

    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/shared_image.png');
      await file.writeAsBytes(_outputImage!);
      final xFile = XFile(file.path);
      await Share.shareXFiles([xFile], text: 'Check out this image!');
      // await SharePlus.instance.share(XFile(file.path));//, text: 'Check out this image!');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to share image: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == 'encrypt' ? 'Encrypt Image' : 'Decrypt Image',style:const TextStyle(color: Colors.white),),
      backgroundColor: Colors.blueGrey, iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(alignment: 
              Alignment.center,
              height: 60, 
              padding: EdgeInsets.all(9),
              decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [  
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 8,
                                offset: Offset(2, 4),
                              ),
                            ],
                            border: Border.all(color: Colors.indigo),
                          ),
                          child: Text("""NOTE: Image Encryption & Decryption takes time. Please wait for some time to get your converted image""",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.oswald(fontSize: 12,),),
                        
            ),const SizedBox(height: 16,),
            if (_selectedImage != null)
              Column(
                children: [
                  Image.file(_selectedImage!, height: 160),
                  SizedBox(height: 16),
                ],
              ),
            if (_outputImage != null)
              Column(
                children: [
                  Image.memory(_outputImage!, height: 160),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(icon: Icon(Icons.download), onPressed: _downloadImage),
                      IconButton(icon: Icon(Icons.share), onPressed: _shareImage),
                    ],
                  ),
                ],
              ),
            Spacer(),
            Row(
              children: [Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    onPressed: () => _getImage(ImageSource.camera),
                    child: Text("Capture Image",style: GoogleFonts.roboto(fontSize: 26),),
                  ),
                ),
              ),]
            ),
            SizedBox(height: 12),
            Row(
              children: [Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    onPressed: () => _getImage(ImageSource.gallery),
                    child: Text("Import From Device", style: GoogleFonts.roboto(fontSize: 26),),
                  ),
                ),
              ),]
            ),
            SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    onPressed: _processImage,
                    child: Text("Convert",style: TextStyle(fontSize: 26),),
                  ),
                ),
              ),
              // const SizedBox(height: 20,),
              ],
            )
          ],
        ),
      ),
    );
  }
}