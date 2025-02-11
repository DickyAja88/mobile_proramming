import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toko_kita/blocs/registrasi_bloc.dart';
import 'package:toko_kita/widget/success_dialog.dart';
import 'package:toko_kita/widget/warninG_dialog.dart';


class RegistrasiPage extends StatefulWidget{
  const RegistrasiPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrasiPageState createState() => _RegistrasiPageState();


}

class _RegistrasiPageState extends State<RegistrasiPage>{
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final TextEditingController _namaTextboxController = TextEditingController();
  final TextEditingController _emailTextboxController = TextEditingController();
  final TextEditingController _passwordTextboxController = TextEditingController();
  final TextEditingController _confirmPasswordTextboxController = TextEditingController();
  bool _isLoading = false;


  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text(
          'Register your self',
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
            padding:const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  _namaTextField(),
                  _emailTextField(),
                  _passwordTextField(),
                  _passwordKonfirmasiTextField(),
                  _buttonRegistrasi()
                ],
              ),
            ),
          ),
        )
    );
  }

  Widget _namaTextField(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Nama",
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: "Nama",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          ),
        ),
        keyboardType: TextInputType.text,
        controller: _namaTextboxController,
        validator: (value) {
          if (value!.length < 3) {
            return "Nama harus diisi minimal 3 karakter";
          }
          return null;
        },
      ),
    );
  }

  Widget _emailTextField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
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
          String pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@'
              r'((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(value)) {
            return 'Email tidak valid';
          }
          return null;
        },
      ),
    );
  }

  Widget _passwordTextField(){
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
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            child: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              semanticLabel: _obscurePassword ? 'show password' : 'hide password',
              size: 20.0,
              color: _obscurePassword ? Colors.blue : Colors.grey,
            ),
          ),
        ),
        keyboardType: TextInputType.text,
        obscureText: _obscurePassword,
        controller: _passwordTextboxController,
        validator: (value) {
          if (value!.length < 6) {
            return "Password harus diisi minimal 6 karakter";
          }
          return null;
        },
      ),
    );
  }

  Widget _passwordKonfirmasiTextField(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Konfirmasi Password",
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: "Konfirmasi Password",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
            child: Icon(
              _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
              semanticLabel: _obscureConfirmPassword ? 'show password' : 'hide password',
              size: 20.0,
              color: _obscureConfirmPassword ? Colors.blue : Colors.grey,
            ),
          ),
        ),
        keyboardType: TextInputType.text,
        obscureText: _obscureConfirmPassword,
        controller: _confirmPasswordTextboxController,
        validator: (value) {
          if (value != _passwordTextboxController.text) {
            return "Konfirmasi Password tidak sama";
          }
          return null;
        },
      ),
    );
  }

  Widget _buttonRegistrasi() {
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
        child:  Text("Daftar", style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
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
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    RegistrasiBloc.registrasi(
      nama: _namaTextboxController.text,
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then((value) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SuccessDialog(
          description: "Registrasi berhasil, silahkan login",
          okClick: () {
            Navigator.pop(context);
          },
        ),
      );
    }, onError: (error) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Registrasi gagal, silahkan coba lagi",
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

}