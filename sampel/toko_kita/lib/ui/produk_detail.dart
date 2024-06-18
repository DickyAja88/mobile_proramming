import 'package:flutter/material.dart';
import 'package:toko_kita/ui/produk_form.dart';
import 'package:toko_kita/model/produk.dart';

// ignore: must_be_immutable
class ProdukDetail extends StatefulWidget{
  Produk? produk;

  ProdukDetail ({super.key, this.produk});
  @override
  // ignore: library_private_types_in_public_api
  _ProdukDetailState createState() => _ProdukDetailState();

}

class _ProdukDetailState extends State<ProdukDetail>{
  @override
  Widget build (BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Produk'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                "Kode: ${widget.produk!.kodeProduk}",
                style: const TextStyle(fontSize: 18.0),
              ),
              Text(
                "Kode: ${widget.produk!.namaProduk}",
                style: const TextStyle(fontSize: 18.0),
              ),Text(
                "Kode: ${widget.produk!.hargaProduk}",
                style: const TextStyle(fontSize: 18.0),
              ),
              _tombolHapusEdit()
            ],
          ),
        )
    );
  }

  Widget _tombolHapusEdit(){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          child: const Text("Edit"),
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProdukForm(
                      produk: widget.produk!,
                    )
                )
            );
          },
        ),
        OutlinedButton(
            child: const Text("Delete"),
            onPressed: () => confirmHapush()
        )
      ],
    );
  }

  void confirmHapush(){
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProdukForm(
                      produk: widget.produk!,
                    )
                )
            )
          },
        ),
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: ()=>Navigator.pop(context),
        )
      ],
    );
    showDialog(context: context, builder: (context)=> alertDialog);
  }
}