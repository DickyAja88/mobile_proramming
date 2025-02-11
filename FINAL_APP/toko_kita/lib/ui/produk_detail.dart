
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toko_kita/blocs/produk_bloc.dart';
import 'package:toko_kita/ui/produk_form.dart';
import 'package:toko_kita/model/produk.dart';

class ProdukDetail extends StatefulWidget {
  final int produkId;

  const ProdukDetail({Key? key, required this.produkId}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
  Produk? _produk;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchProdukDetail();
  }

  void _scrollListener() {
    if (_scrollController.offset > kToolbarHeight && !_isScrolled) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_scrollController.offset <= kToolbarHeight && _isScrolled) {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  Future<void> _fetchProdukDetail() async {
    try {
      Produk? produk = await ProdukBloc.getDetailProduk(widget.produkId);
      setState(() {
        _produk = produk;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _produk == null
                  ? const Center(child: Text('Produk tidak ditemukan'))
                  : CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 200.0,
                          pinned: true,
                          backgroundColor: _isScrolled ? Colors.blue : Colors.transparent,
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back, color: _isScrolled ? Colors.white : Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                if (_produk != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProdukForm(
                                        produk: _produk!,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text("Edit", style: TextStyle(color: _isScrolled ? Colors.white : Colors.white)),
                            ),
                            TextButton(
                              onPressed: () => _confirmHapus(),
                              child: Text("Delete", style: TextStyle(color: _isScrolled ? Colors.white : Colors.white)),
                            ),
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            background: Stack(
                              fit: StackFit.expand,
                              children: [
                                _produk?.gambarUrl != null
                                    ? Image.network(
                                        _produk!.gambarUrl!,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.error_outline, color: Colors.red, size: 50),
                                                SizedBox(height: 10),
                                                Text('Gambar tidak dapat dimuat', style: TextStyle(color: Colors.red)),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : const Center(child: Icon(Icons.error_outline)),
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.transparent, Colors.black54],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(16.0),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formatCurrency.format(_produk?.hargaProduk ?? 0),
                                          style: GoogleFonts.openSans(
                                            fontSize: 25,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          (_produk?.stok != null && _produk!.stok! > 0)
                                              ? '${_produk?.stok} barang'
                                              : 'barang habis',
                                          style: GoogleFonts.openSans(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      _produk?.namaProduk ?? 'Tidak ada nama produk',
                                      style: GoogleFonts.openSans(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    Text(
                                      'Deskripsi:',
                                      style: GoogleFonts.openSans(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Kode Produk: ${_produk?.kodeProduk ?? "Tidak ada kode produk"}',
                                      style: GoogleFonts.openSans(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    Text(
                                      _produk?.deskripsi ?? 'Tidak ada deskripsi',
                                      style: GoogleFonts.openSans(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }

  void _confirmHapus() {
    final alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            if (_produk != null) {
              _hapusProduk(_produk!);
            }
          },
        ),
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }

  void _hapusProduk(Produk produk) {
    ProdukBloc.deleteProduk(id: produk.id).then((status) {
      if (status) {
        Navigator.pop(context);
        Navigator.pop(context, true);
      } else {
        print("Gagal menghapus produk");
      }
    });
  }
}
