
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:toko_kita/model/produk.dart';
import 'package:toko_kita/ui/produk_page.dart';
import 'package:toko_kita/blocs/produk_bloc.dart';
import 'package:toko_kita/widget/warning_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image/image.dart' as img;


// ignore: must_be_immutable
class ProdukForm extends StatefulWidget {
  Produk? produk;

  ProdukForm({super.key, this.produk});

  @override
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
  final QuillController _deskripsiTextController = QuillController.basic();
  final _stokProdukTextBoxController = TextEditingController();

  File? _image;
  String? _existingImagePath;
  final ImagePicker _picker = ImagePicker();
  String? _error;

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  void isUpdate() {
  if (widget.produk != null) {
    setState(() {
      judul = "Ubah Produk";
      tombolSubmit = "Ubah";
      _kodeProdukTextBoxController.text = widget.produk!.kodeProduk!;
      _namaProdukTextBoxController.text = widget.produk!.namaProduk!;
      _hargaProdukTextBoxController.text = widget.produk!.hargaProduk.toString();
      String deskripsi = widget.produk!.deskripsi!;
      List<String> deskripsiList = deskripsi.split('\n');
      List<Map<String, dynamic>> deltaOperations = deskripsiList.map((line) {
          return {'insert': '$line\n'}; // Ensure each line ends with a newline character
        }).toList();
      _deskripsiTextController.document = Document.fromJson(deltaOperations);
      _stokProdukTextBoxController.text = widget.produk!.stok.toString();

    });
  }
}


  Future<void> _getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();
      final fileExtension = file.path.split('.').last;

      if (fileSize > 1024 * 1024) {
        setState(() {
          _error = 'File size harus kurang dari 1MB';
          _image = null;
        });
      } else if (!['jpg', 'jpeg', 'gif', 'png', 'webp'].contains(fileExtension.toLowerCase())) {
        setState(() {
          _error = 'File harus berupa jpg, jpeg, gif, png, atau webp';
          _image = null;
        });
      } else {
        final imageBytes = await pickedFile.readAsBytes();
        final image = img.decodeImage(imageBytes);

        if (image != null && (image.width > 2048 || image.height > 2048)) {
          setState(() {
            _error = 'Dimensi gambar maksimal 2048x2048';
            _image = null;
          });
        } else {
          setState(() {
            _image = file;
            _error = null;
          });
        }
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _headerContainer(context),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _kodeProdukTextField(),
                      _namaProdukTextField(),
                      _hargaProdukTextField(),
                      _gambarTextField(),
                      _deskripsiTextField(),
                      _stokTextField(),
                      _buttonSubmit(),
                      if (_isLoading) const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),// Warna latar belakang sesuai contoh gambar
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 10),
          Text(
            judul,
            style: GoogleFonts.openSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Buatlah produkmu semenarik mungkin sehingga semua orang menyukainya,',
            style: GoogleFonts.openSans(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  Widget _kodeProdukTextField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kode Produk', style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: "Kode Produk",
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.text,
              controller: _kodeProdukTextBoxController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Kode Produk harus diisi';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _namaProdukTextField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nama Produk', style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: "Nama Produk",
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.emailAddress,
              controller: _namaProdukTextBoxController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Nama Produk harus diisi';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _hargaProdukTextField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Harga', style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: "Harga",
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.number,
              controller: _hargaProdukTextBoxController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Harga harus diisi';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _stokTextField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Stok', style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: "Stok",
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.number,
              controller: _stokProdukTextBoxController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Stok harus diisi';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _gambarTextField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gambar',
            style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: GestureDetector(
              onTap: _getImageFromGallery,
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                dashPattern: const [16, 8],
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: _image == null && _existingImagePath == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _image != null
                              ? Image.file(_image!, fit: BoxFit.cover, width: double.infinity)
                              : Image.file(File(_existingImagePath!), fit: BoxFit.cover, width: double.infinity),
                        ),
                ),
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 5),
            Text(
              _error!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }


  Widget _deskripsiTextField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Menambahkan crossAxisAlignment
        children: [
          Text('Deskripsi', style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 100,
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: _deskripsiTextController,
                placeholder: "Masukkan Deskripsi",
                autoFocus: false,
                expands: false,
                padding: const EdgeInsets.all(10.0),
                scrollable: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonSubmit() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(20),
          backgroundColor: Colors.blue,
        ),
        child:  Text(tombolSubmit, style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) {
              if (widget.produk != null) {
                ubah() ;
              } else {
                simpan();
              }
            }
          }
        },
      ),
    );
  }

  void simpan() async {
    setState(() {
      _isLoading = true;
    });

    Produk createProduk = Produk(id: null);
    createProduk.kodeProduk = _kodeProdukTextBoxController.text;
    createProduk.namaProduk = _namaProdukTextBoxController.text;
    createProduk.hargaProduk = int.parse(_hargaProdukTextBoxController.text);
    createProduk.deskripsi = _deskripsiTextController.document.toPlainText();
    createProduk.stok = int.parse(_stokProdukTextBoxController.text);

    var result = await ProdukBloc.addProduk(produk: createProduk, image: _image);

    setState(() {
      _isLoading = false;
    });

    if (result==true) {
      // Jika berhasil, navigasi ke halaman produk tanpa pesan
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => ProdukPage(),
      ));
    } else {
      // Jika gagal, tampilkan pesan kesalahan
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Simpan Gagal'),
          content: const Text('Simpan gagal, silahkan coba lagi'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
}


void ubah() async {
  setState(() {
    _isLoading = true;
  });

  Produk updateProduk = Produk(id: widget.produk!.id);
  updateProduk.kodeProduk = _kodeProdukTextBoxController.text;
  updateProduk.namaProduk = _namaProdukTextBoxController.text;
  updateProduk.hargaProduk = int.parse(_hargaProdukTextBoxController.text);
  updateProduk.deskripsi = _deskripsiTextController.document.toPlainText();
  updateProduk.stok = int.parse(_stokProdukTextBoxController.text);

  var result = await ProdukBloc.updateProduk(produk: updateProduk, image: _image);

  setState(() {
    _isLoading = false;
  });

  if (result == true) {
    // Jika berhasil, navigasi ke halaman produk tanpa pesan
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => ProdukPage(),
    ));
  } else {
    // Jika gagal, tampilkan pesan kesalahan
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Ubah Gagal'),
        content: const Text('Permintaan ubah data gagal, silahkan coba lagi'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}



  // void ubah() {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   Produk updateProduk = Produk(id: widget.produk!.id);
  //   updateProduk.kodeProduk = _kodeProdukTextBoxController.text;
  //   updateProduk.namaProduk = _namaProdukTextBoxController.text;
  //   updateProduk.hargaProduk = int.parse(_hargaProdukTextBoxController.text);
  //   updateProduk.deskripsi = _deskripsiTextController.document.toPlainText();
  //   updateProduk.stok = int.parse(_stokProdukTextBoxController.text);

  //   ProdukBloc.updateProduk(produk: updateProduk).then((value) {
  //     Navigator.of(context).push(MaterialPageRoute(
  //       builder: (BuildContext context) => const ProdukPage(),
  //     ));
  //   }, onError: (error) {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) => const WarningDialog(
  //         description: "Permintaan ubah data gagal, silahkan coba lagi",
  //       ),
  //     );
  //   }).whenComplete(() {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });

  // }

  
  void handleBack(BuildContext context){
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text('konfirmasi'),
          content: const Text('Apakah anda ingin keluar dari form produk?'),
          actions: [
            TextButton(
              onPressed: ()=> Navigator.of(context).pop(false), 
              child: const Text('Batal')
            ),
            TextButton(
              onPressed: ()=> Navigator.of(context).pop(true), 
              child: const Text('Ya')
            ),
          ],
        )
      );
    }
  
  
  
  
}

