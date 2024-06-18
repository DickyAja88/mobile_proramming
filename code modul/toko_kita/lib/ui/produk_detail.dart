import 'package:flutter/material.dart';
import 'package:toko_kita/blocs/produk_bloc.dart';
import 'package:toko_kita/ui/produk_form.dart';
import 'package:toko_kita/model/produk.dart';

// ignore: must_be_immutable
class ProdukDetail extends StatefulWidget{
  Produk? produk;

  ProdukDetail ({Key? key, this.produk}) : super(key: key);
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
                "nama: ${widget.produk!.namaProduk}",
                style: const TextStyle(fontSize: 18.0),
              ),
              Text(
                "harga: ${widget.produk!.hargaProduk}",
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
            onPressed: () => confirmHapus()
        )
      ],
    );
  }

  void confirmHapus(){
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            hapusProduk(widget.produk!);
          //  Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ProdukForm(
          //       produk: widget.produk!,
          //     )
          //   )
          //  );
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

  void hapusProduk(Produk produk){
    ProdukBloc.deleteProduk(id: produk.id).then((status){
      if(status){
          Navigator.pop(context);
          Navigator.pop(context, true); 
      }else{
        print("gagal menghapus produk");
      }
    });
  }
}
