import 'package:flutter/material.dart';
import 'package:toko_kita/model/produk.dart';
import 'package:toko_kita/ui/produk_page.dart';
import 'package:toko_kita/blocs/produk_bloc.dart';
import 'package:toko_kita/widget/warning_dialog.dart';


// ignore: must_be_immutable
class ProdukForm extends StatefulWidget{
  Produk? produk;

  ProdukForm ({super.key, this.produk});

  @override
  // ignore: library_private_types_in_public_api
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "Tambah Produk";
  String tombolSubmit = "Simpan";

  final _kodeProdukTextBoxController = TextEditingController();
  final _namaProdukTextBoxController = TextEditingController();
  final _hargaProdukTextBoxController = TextEditingController();

  @override
  void initState(){
    super.initState();
    isUpdate();
  }

  isUpdate(){
    if(widget.produk != null){
      setState(() {
        judul = "Ubah Produk";
        tombolSubmit = "Ubah";
        _kodeProdukTextBoxController.text = widget.produk!.kodeProduk!;
        _namaProdukTextBoxController.text = widget.produk!.namaProduk!;
        _hargaProdukTextBoxController.text = widget.produk!.hargaProduk.toString();
      });
    }else{
      judul = "Tambah Produk";
      tombolSubmit = "Simpan";
    }

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(title: Text(judul)),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _kodeProdukTextField(),
                    _namaProdukTextField(),
                    _hargaProdukTextField(),
                    _buttonSubmit(),
                    if (_isLoading) const CircularProgressIndicator(),
                  ],
                ),
              )
          ),
        )
    );
  }

  Widget _kodeProdukTextField(){
    return TextFormField(
      decoration: const InputDecoration(labelText: "Kode Produk"),
      keyboardType: TextInputType.text,
      controller: _kodeProdukTextBoxController,
      validator: (value){
        if(value!.isEmpty){
          return "Kode Produk harus diisi";
        }
        return null;
      },
    );
  }

  Widget _namaProdukTextField(){
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Produk"),
      keyboardType: TextInputType.text,
      controller: _namaProdukTextBoxController,
      validator: (value){
        if(value!.isEmpty){
          return "Nama Produk harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Textbox Harga Produk
  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Harga"),
      keyboardType: TextInputType.number,
      controller: _hargaProdukTextBoxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Harga harus diisi";
        }
        return null;
      },
    );
  }

// Membuat Tombol Simpan/Ubah
  Widget _buttonSubmit() {
    return OutlinedButton(
      child: Text(tombolSubmit),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            if (widget.produk != null) {
              // kondisi update produk
              ubah();
            } else {
              // kondisi tambah produk
              simpan();
            }
          }
        }
      },
    );
  }

  void simpan() {
    setState(() {
      _isLoading = true;
    });

    Produk createProduk = Produk(id: null);
    createProduk.kodeProduk = _kodeProdukTextBoxController.text;
    createProduk.namaProduk = _namaProdukTextBoxController.text;
    createProduk.hargaProduk = int.parse(_hargaProdukTextBoxController.text);

    ProdukBloc.addProduk(produk: createProduk).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => const ProdukPage(),
      ));
    }, onError: (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Simpan gagal, silahkan coba lagi",
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void ubah() {
    setState(() {
      _isLoading = true;
    });

    Produk updateProduk = Produk(id: widget.produk!.id);
    updateProduk.kodeProduk = _kodeProdukTextBoxController.text;
    updateProduk.namaProduk = _namaProdukTextBoxController.text;
    updateProduk.hargaProduk = int.parse(_hargaProdukTextBoxController.text);

    ProdukBloc.updateProduk(produk: updateProduk).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => const ProdukPage(),
      ));
    }, onError: (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Permintaan ubah data gagal, silahkan coba lagi",
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }




}