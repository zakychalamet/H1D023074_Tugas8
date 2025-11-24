import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;

  const ProdukForm({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukFormState createState() => _ProdukFormState();
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
    isUpdate();
  }

  @override
  void dispose() {
    _kodeProdukTextboxController.dispose();
    _namaProdukTextboxController.dispose();
    _hargaProdukTextboxController.dispose();
    super.dispose();
  }

  void isUpdate() {
    if (widget.produk != null) {
      judul = "Ubah Produk - Zaky";
      tombolSubmit = "UBAH";
      _kodeProdukTextboxController.text = widget.produk!.kodeProduk ?? '';
      _namaProdukTextboxController.text = widget.produk!.namaProduk ?? '';
      _hargaProdukTextboxController.text =
          widget.produk!.hargaProduk.toString();
    } else {
      judul = "Tambah Produk - Zaky";
      tombolSubmit = "Simpan";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          judul,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                _kodeProdukTextField(),
                const SizedBox(height: 24),
                _namaProdukTextField(),
                const SizedBox(height: 24),
                _hargaProdukTextField(),
                const SizedBox(height: 32),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _kodeProdukTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Kode Produk",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          keyboardType: TextInputType.text,
          controller: _kodeProdukTextboxController,
          style: widget.produk != null
              ? const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )
              : null,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Kode Produk harus diisi";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _namaProdukTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nama Produk",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          keyboardType: TextInputType.text,
          controller: _namaProdukTextboxController,
          style: widget.produk != null
              ? const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )
              : null,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Nama Produk harus diisi";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _hargaProdukTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Harga",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          keyboardType: TextInputType.number,
          controller: _hargaProdukTextboxController,
          style: widget.produk != null
              ? const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )
              : null,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Harga harus diisi";
            }
            if (int.tryParse(value) == null) {
              return "Harga harus berupa angka";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buttonSubmit() {
    return Center(
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.pop(context);
                  });
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                tombolSubmit,
                style: const TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}