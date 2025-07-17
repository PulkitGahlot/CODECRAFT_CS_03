import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class PasswordCheckScreen extends StatefulWidget {
  const PasswordCheckScreen({super.key});

  @override
  _PasswordCheckScreenState createState() => _PasswordCheckScreenState();
}

class _PasswordCheckScreenState extends State<PasswordCheckScreen> {
  final TextEditingController _controller = TextEditingController();
  String _strength = "";


  // ----------------To send request to python backend render api---------------------------
  Future<void> _checkStrength() async {
    final response = await http.post(
      Uri.parse("https://cryptographer-backend.onrender.com/check_password"),
      body: {'password': _controller.text},
    );

    // --------------------To Get the result from python backend--------------------------
    if (response.statusCode == 200) {
      final data=jsonDecode(response.body);
      setState(() {
        _strength = data['strength'];
      });
    } else {
      setState(() {
        _strength = "Error checking password";
      });
    }
  }

  // ---------------to Change Color accordingly------------------
  Color getStrengthColor(String strength) {
  switch (strength.toLowerCase()) {
    case 'very strong':
    case 'strong':
      return Colors.green;
    case 'medium':
      return Colors.orange;
    case 'weak':
      return Colors.red;
    default:
      return Colors.black;
    }
  }

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Password Strength Checker",style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.blueGrey, iconTheme: IconThemeData(color: Colors.white),),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              obscureText: _isObscure,
              decoration: InputDecoration(labelText: "Enter Password", border: OutlineInputBorder(), suffixIcon: IconButton(icon: Icon(_isObscure?Icons.visibility:Icons.visibility_off) ,onPressed: () {setState(() {
                _isObscure = !_isObscure;
              });})),
            ),
            Spacer(),
            Text("Strength: $_strength", style: GoogleFonts.roboto(fontSize: 25, color: getStrengthColor(_strength))),
            SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.24,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8))),
                onPressed: _checkStrength,
                child: Text("Check", style: GoogleFonts.roboto(fontSize: 32),),
              ),
            ),
            // SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}
