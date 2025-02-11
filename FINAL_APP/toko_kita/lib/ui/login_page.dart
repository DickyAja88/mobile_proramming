import 'package:flutter/material.dart';
import 'package:toko_kita/ui/registrasi_page.dart';
import 'package:toko_kita/blocs/login_bloc.dart';
import 'package:toko_kita/helpers/user_info.dart';
import 'package:toko_kita/ui/produk_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toko_kita/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureText = true;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  void dispose() {
    _emailTextboxController.dispose();
    _passwordTextboxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome to',
          style: GoogleFonts.pacifico(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          )
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ), 
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                      'assets/shop.png',
                      fit: BoxFit.cover,
                  ),
                ),
                Text(
                  'Toko kita',
                  style: GoogleFonts.playfairDisplay(
                    fontStyle: FontStyle.italic,
                    color: Colors.blue,
                    fontSize: 18,
                  ),
                ),
                 const SizedBox(
                  height: 30,
                ),
                _emailTextField(),
                _passwordTextField(),
                _buttonLogin(),
                Text(
                  'OR',
                  style: GoogleFonts.openSans(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 const SizedBox(
                  height: 20,
                ),
                Text(
                  "Don't have an account?",
                  style: GoogleFonts.openSans(),
                ),
                _menuRegistrasi(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0), // Menambahkan margin horizontal dan vertical
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Email",
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: "Email",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        controller: _emailTextboxController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Email harus diisi';
          }
          return null;
        },
      ),
    );
  }

  Widget _passwordTextField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0), 
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Password",
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: "Password",
           enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          ),
          suffix: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              semanticLabel: _obscureText ? 'show password' : 'hide password',
              size: 20.0, 
             color: _obscureText ? Colors.blue : Colors.grey,
            ),
          ),
        ),
        keyboardType: TextInputType.text,
        obscureText: _obscureText,
        controller: _passwordTextboxController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Password harus diisi";
          }
          return null;
        },
      ),
    );
  }

  Widget _buttonLogin() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.all(20),
          backgroundColor: Colors.blue,
        ),
        child: Text("Login", style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) _submit();
          }
        },
      ),
    );
  }


  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      LoginBloc.login(
        email: _emailTextboxController.text,
        password: _passwordTextboxController.text,
      ).then((value) async {
        await UserInfo().setToken(value.token.toString());
        await UserInfo().setUserID(int.parse(value.userID.toString()));
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const ProdukPage()),
        );
      }).catchError((error) {
        // ignore: avoid_print
        print("Error: $error");
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
            description: "Login gagal, silahkan coba lagi",
          ),
        );
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }


  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child:  Text(
          'Registrasi',
          style: GoogleFonts.openSans(
            color: Colors.blue
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()),
          );
        },
      ),
    );
  }
}
