import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukDetail extends StatefulWidget {
  final Produk produk;

  const ProdukDetail({super.key, required this.produk});

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Produk Fathan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Kode : ${widget.produk.kodeProduk}",
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              "Nama : ${widget.produk.namaProduk}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Harga : Rp. ${widget.produk.hargaProduk}",
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProdukForm(produk: widget.produk),
              ),
            );
          },
          child: const Text("EDIT", style: TextStyle(color: Colors.white)),
        ),

        const SizedBox(width: 10),

        // TOMBOL DELETE
        OutlinedButton(
          style: OutlinedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => _confirmHapus(),
          child: const Text("DELETE", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _confirmHapus() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: const Text("Yakin ingin menghapus data ini?"),
        actions: [
          // tombol YA
          OutlinedButton(
            onPressed: () => _hapusProduk(),
            child: const Text("Ya"),
          ),

          // tombol BATAL
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
        ],
      ),
    );
  }

  Future<void> _hapusProduk() async {
    try {
      await ProdukBloc.deleteProduk(id: int.parse(widget.produk.id!));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProdukPage()),
      );
    } catch (e) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => const WarningDialog(
          description: "Hapus gagal, silahkan coba lagi",
        ),
      );
    }
  }
}
