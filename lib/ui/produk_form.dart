import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;

  const ProdukForm({super.key, this.produk}); // ✔ super parameter

  @override
  State<ProdukForm> createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late String judul;
  late String tombolSubmit;

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupForm();
  }

  void _setupForm() {
    if (widget.produk != null) {
      judul = "UBAH PRODUK";
      tombolSubmit = "UBAH";
      _kodeProdukTextboxController.text = widget.produk!.kodeProduk ?? "";
      _namaProdukTextboxController.text = widget.produk!.namaProduk ?? "";
      _hargaProdukTextboxController.text =
          widget.produk!.hargaProduk.toString();
    } else {
      judul = "TAMBAH PRODUK";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _kodeProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Kode Produk"),
      controller: _kodeProdukTextboxController,
      validator: (value) =>
          (value == null || value.isEmpty) ? "Kode Produk harus diisi" : null,
    );
  }

  Widget _namaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Produk"),
      controller: _namaProdukTextboxController,
      validator: (value) =>
          (value == null || value.isEmpty) ? "Nama Produk harus diisi" : null,
    );
  }

  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Harga"),
      controller: _hargaProdukTextboxController,
      keyboardType: TextInputType.number,
      validator: (value) =>
          (value == null || value.isEmpty) ? "Harga harus diisi" : null,
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      onPressed: _isLoading ? null : _submitForm,
      child: Text(tombolSubmit),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    if (widget.produk == null) {
      await _simpanProduk();
    } else {
      await _ubahProduk();
    }

    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _simpanProduk() async {
    Produk produkBaru = Produk(id: null);
    produkBaru.kodeProduk = _kodeProdukTextboxController.text;
    produkBaru.namaProduk = _namaProdukTextboxController.text;
    produkBaru.hargaProduk =
        int.parse(_hargaProdukTextboxController.text);

    try {
      await ProdukBloc.addProduk(produk: produkBaru);

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
          description: "Simpan gagal, silahkan coba lagi",
        ),
      );
    }
  }

  Future<void> _ubahProduk() async {
    Produk updated = Produk(id: widget.produk!.id);
    updated.kodeProduk = _kodeProdukTextboxController.text;
    updated.namaProduk = _namaProdukTextboxController.text;
    updated.hargaProduk =
        int.parse(_hargaProdukTextboxController.text);

    try {
      await ProdukBloc.updateProduk(produk: updated);

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
          description: "Permintaan ubah data gagal, silahkan coba lagi",
        ),
      );
    }
  }
}
