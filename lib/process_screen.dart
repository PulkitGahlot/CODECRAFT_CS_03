import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart'; // For clipboard

class ProcessScreen extends StatefulWidget {
  final String mode; // 'encrypt' or 'decrypt'

  const ProcessScreen({super.key, required this.mode});

  @override
  _ProcessScreenState createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _shiftController = TextEditingController();
  String _outputText = "";

  Future<void> _processText() async {
    final response = await http.post(
      Uri.parse('https://cryptographer-backend.onrender.com/cipher'), // Use PC IP if on physical device
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "text": _inputController.text,
        "shift": int.tryParse(_shiftController.text) ?? 0,
        "mode": widget.mode
      }),
    );

    // ---------------------To get the result from python backend-------------------
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _outputText = data['result'];
      });
    } else {
      setState(() {
        _outputText = "Error: Unable to process";
      });
    }
  }

  void _pasteFromClipboard() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    if (data != null) {
      _inputController.text = data.text ?? '';
    }
  }

  void _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _outputText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied to clipboard")),
    );
  }

  // --------------------Share Button Function-------------------------
  void _shareOutput() {
    // This requires share_plus or similar package
     if( _outputText.isNotEmpty){
       Share.share(_outputText);
     }else{
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Nothing to share")),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.mode == 'encrypt' ? 'Encryption' : 'Decryption',style:const TextStyle(color: Colors.white),),
      backgroundColor: Colors.blueGrey, iconTheme: IconThemeData(color: Colors.white),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                        labelText: widget.mode == 'encrypt' ? 'Enter Plain Text' : 'Enter Cipher Text',
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 5,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.paste),
                    onPressed: _pasteFromClipboard,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Output',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: _outputText),
                      maxLines: 5,
                    ),
                  ),
                  // const SizedBox(width: 8,),
                  Column(
                    children: [IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: _copyToClipboard,
                    ),IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: _shareOutput,
                  ),]
                  ),
                  
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Expanded(
                    // child: 
                    TextField(
                      controller: _shiftController,
                      decoration: const InputDecoration(
                        labelText: 'Shift Key',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                    ),
                  // ),
                  const SizedBox(height: 200),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.24,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      onPressed: _processText,
                      child: Text('Convert',style: GoogleFonts.roboto(fontSize: 32),),
                    ),
                  )
                ],
              )
            ],
          ),
        ),),
      ),
    );
  }
}