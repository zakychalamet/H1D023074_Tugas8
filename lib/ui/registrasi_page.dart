import 'package:flutter/material.dart';
import 'package:tokokita/ui/login_page.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();
  final _passwordKonfirmasiTextboxController = TextEditingController();

  @override
  void dispose() {
    _namaTextboxController.dispose();
    _emailTextboxController.dispose();
    _passwordTextboxController.dispose();
    _passwordKonfirmasiTextboxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registrasi - Zaky",
          style: TextStyle(color: Colors.white),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                _namaTextField(),
                const SizedBox(height: 24),
                _emailTextField(),
                const SizedBox(height: 24),
                _passwordTextField(),
                const SizedBox(height: 24),
                _passwordKonfirmasiTextField(),
                const SizedBox(height: 32),
                _buttonRegistrasi(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _namaTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nama",
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
          controller: _namaTextboxController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Nama harus diisi";
            }
            if (value.length < 3) {
              return "Nama harus diisi minimal 3 karakter";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _emailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email",
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
          keyboardType: TextInputType.emailAddress,
          controller: _emailTextboxController,
          validator: (value) {
            // Validasi harus diisi
            if (value == null || value.isEmpty) {
              return 'Email harus diisi';
            }
            // Validasi email
            Pattern pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regex = RegExp(pattern.toString());
            if (!regex.hasMatch(value)) {
              return "Email tidak valid";
            }
            return null;
          },
        ),
      ],
    );
  }

  // Membuat Textbox password
  Widget _passwordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Password",
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
          obscureText: true,
          controller: _passwordTextboxController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Password harus diisi";
            }
            if (value.length < 6) {
              return "Password harus diisi minimal 6 karakter";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _passwordKonfirmasiTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Konfirmasi Password",
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
          obscureText: true,
          controller: _passwordKonfirmasiTextboxController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Konfirmasi Password harus diisi";
            }
            if (value != _passwordTextboxController.text) {
              return "Konfirmasi Password tidak sama";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buttonRegistrasi() {
    return SizedBox(
      width: double.infinity,
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  });
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
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
            : const Text(
                "Registrasi",
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}
