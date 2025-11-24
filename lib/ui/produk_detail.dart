import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/ui/produk_page.dart';

class ProdukDetail extends StatefulWidget {
  final Produk? produk;

  const ProdukDetail({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Produk - Zaky',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                "Kode : ${widget.produk?.kodeProduk ?? '-'}",
                style: const TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Nama : ${widget.produk?.namaProduk ?? '-'}",
                style: const TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Harga : Rp. ${widget.produk?.hargaProduk.toString().replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]}.',
                    ) ?? '0'}",
                style: const TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _tombolHapusEdit(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProdukForm(
                    produk: widget.produk,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              "EDIT",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => confirmHapus(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              "DELETE",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        // Tombol batal
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context); 
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ProdukPage(),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: const Text("Ya"),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (context) => alertDialog,
    );
  }
}