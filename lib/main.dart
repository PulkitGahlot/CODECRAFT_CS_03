import 'package:cryptographer_tool/password_check_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'process_screen.dart';
import 'image_process_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cryptographer Tool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void navigateToTextProcess(BuildContext context, String mode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProcessScreen(mode: mode),
      ),
    );
  }

  void navigateToImageProcess(BuildContext context, String mode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageProcessScreen(mode: mode),
      ),
    );
  }


  void navigateToPasswordScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordCheckScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cryptographer',style: GoogleFonts.roboto(color: Colors.white,)),
        backgroundColor: Colors.blueGrey,      
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.fromLTRB(20, 0, 20, 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(0, 30, 0, 36),
                    child: Row(children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          height: 180,
                          padding: EdgeInsets.all(9),
                          // margin: EdgeInsets.symmetric(horizontal: 20),
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
                          child: Text("""Your Go to Cryptograpy tool Armed with Text as well as Image Encrypter and Decrypter!!""",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.oswald(fontSize: 25,),),
                        ),
                      ),],
                    ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.4,
                  height: MediaQuery.of(context).size.width * 0.24,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: () => navigateToTextProcess(context, 'encrypt'),
                    child: Text('Encrypt Text',style: GoogleFonts.roboto(fontSize: 32)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.4,
                  height: MediaQuery.of(context).size.width * 0.24,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: () => navigateToTextProcess(context, 'decrypt'),
                    child:  Text('Decrypt Text',style: GoogleFonts.roboto(fontSize: 32)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.4,
                  height: MediaQuery.of(context).size.width * 0.24,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: () => navigateToImageProcess(context, 'encrypt'),
                    child: Text('Encrypt Image',style: GoogleFonts.roboto(fontSize: 32)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.4,
                  height: MediaQuery.of(context).size.width * 0.24,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: () => navigateToImageProcess(context, 'decrypt'),
                    child:  Text('Decrypt Image',style: GoogleFonts.roboto(fontSize: 32)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.4,
                  height: MediaQuery.of(context).size.width * 0.24,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: () => navigateToPasswordScreen(context),
                    child:  Text('Check Password',style: GoogleFonts.roboto(fontSize: 32)),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      ),
    );
  }
}