import 'package:flutter/material.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/ui/registrasi_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  void dispose() {
    _emailTextboxController.dispose();
    _passwordTextboxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login - Zaky',
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
                const SizedBox(height: 40),
                _emailTextField(),
                const SizedBox(height: 24),
                _passwordTextField(),
                const SizedBox(height: 32),
                _buttonLogin(),
                const SizedBox(height: 24),
                _menuRegistrasi(),
              ],
            ),
          ),
        ),
      ),
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
            if (value == null || value.isEmpty) {
              return 'Email harus diisi';
            }
            return null;
          },
        ),
      ],
    );
  }

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
            return null;
          },
        ),
      ],
    );
  }

  Widget _buttonLogin() {
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
                        builder: (context) => const ProdukPage(),
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
                "Login",
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }

  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegistrasiPage(),
            ),
          );
        },
        child: const Text(
          "Registrasi",
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}