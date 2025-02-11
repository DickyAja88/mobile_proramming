import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toko_kita/blocs/logout_bloc.dart';
import 'package:toko_kita/blocs/produk_bloc.dart';
import 'package:toko_kita/model/produk.dart';
import 'package:toko_kita/ui/login_page.dart';
import 'package:toko_kita/ui/produk_detail.dart';
import 'package:toko_kita/ui/produk_form.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toko_kita/ui/cari_produk.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
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

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ), 
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                try {
                  await LogoutBloc.logout(); // Menunggu logout selesai
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                } catch (e) {
                  print('Error during logout: $e'); // Tangani error jika terjadi
                  // Optional: Tampilkan pesan kepada pengguna bahwa logout gagal
                }
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: double.infinity,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                    ),
                    items: [
                      'assets/test.png',
                      'assets/test.png',
                      'assets/test.png'
                    ].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(i),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isScrolled
                            ? [Colors.blue, Colors.purple]
                            : [Colors.transparent, Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: _isScrolled ? Colors.blue : Colors.transparent,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),

            title: Container(
              height: 40.0,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CariProduk(searchQuery: _searchController.text),
                      ));
                    },
                    icon: Icon(Icons.search, color: Colors.white),
                  ),
                  hintText: "Cari Produk",
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),

            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProdukForm()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  // Implement cart functionality here
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _paymentPromotionSection(),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: FutureBuilder<List<Produk>>(
              future: ProdukBloc.getProduks(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return SliverToBoxAdapter(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          height: 100.0, // Sesuaikan tinggi dengan item produk Anda
                        ),
                      ),
                      childCount: 6, // Jumlah skeleton items yang ingin ditampilkan
                    ),
                  );
                }
                return SliverToBoxAdapter(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ItemProduk(produk: snapshot.data![index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshProdukList() async {
    setState(() {});
  }

  Widget _paymentPromotionSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPaymentOption(Icons.sell, "Penjualan", "20 produk"),
          _buildPaymentOption(Icons.discount, "Promosi", "%"),
          _buildPaymentOption(Icons.account_balance_wallet, "Saldo", "RP. 100000"),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(IconData icon, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        // Implement click logic here
      },
      child: Column(
        children: [
          Icon(icon, size: 30.0),
          const SizedBox(height: 5.0),
          Text(title, style: const TextStyle(fontSize: 12.0)),
          Text(subtitle, style: const TextStyle(fontSize: 10.0, color: Colors.grey)),
        ],
      ),
    );
  }
}

class ListProduk extends StatelessWidget {
  final List? list;

  const ListProduk({super.key, this.list});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemCount: list == null ? 0 : list!.length,
        itemBuilder: (context, i) {
          return ItemProduk(produk: list![i]);
        },
      ),
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;
  final NumberFormat formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');

  ItemProduk({super.key, required this.produk});

  String getShortDescription(String deskripsi, int maxLength) {
    return (deskripsi.length > maxLength) ? '${deskripsi.substring(0, maxLength)}...' : deskripsi;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        bool? refresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProdukDetail(produkId: produk.id!),
          ),
        );
        if (refresh == true) {
          (context.findAncestorStateOfType<_ProdukPageState>()?._refreshProdukList)!();
        }
      },
      child: SizedBox(
        height: 100,  // Adjust height to fit within the grid
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: AspectRatio(
                 aspectRatio: 3 / 2,
                  child: Container(
                    color: Colors.grey[300],
                    child: produk.gambarUrl != null
                        ? Image.network(
                            produk.gambarUrl!,
                            fit: BoxFit.cover,
                          )
                        : const Center(child: Icon(Icons.error_outline)),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0),
                child: Text(
                  produk.namaProduk ?? 'Nama Produk',
                  style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0),
                child: Text(
                    getShortDescription(produk.deskripsi ?? '', 20),
                    style: GoogleFonts.openSans(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0),
                child: Text(
                  (produk.stok != null && produk.stok != 0) ? '${produk.stok} barang' : 'barang habis',
                  style: GoogleFonts.openSans(fontSize: 14),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 8.0),
                  child: Text(
                  formatCurrency.format(produk.hargaProduk),
                  style: GoogleFonts.openSans(fontSize: 16, color: Colors.red),
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
