## H1D023074_Tugas7

<br>
<br>
Nama: Ahmad Zaky <br>
NIM: H1D023074 <br>
Shift Awal: A <br>
Shift Baru: D <br>
<br>

## 📸 Screenshot & UI

### 1. Halaman Login
![image alt](https://github.com/zakychalamet/H1D023074_Tugas8/blob/480616dd16fd8fce07913e1716780c631dad3242/pics/Screenshot%202025-12-02%20155906.png)

**Deskripsi**: Form login meminta input email dan password. Setelah submit, aplikasi akan melakukan validasi dan request ke server.

### 2. Halaman Registrasi
![image alt](https://github.com/zakychalamet/H1D023074_Tugas8/blob/480616dd16fd8fce07913e1716780c631dad3242/pics/Screenshot%202025-12-02%20155839.png)

**Deskripsi**: Form registrasi untuk pembuatan akun baru dengan validasi data.

### 3. Halaman List Produk (Home)
![image alt](https://github.com/zakychalamet/H1D023074_Tugas8/blob/480616dd16fd8fce07913e1716780c631dad3242/pics/Screenshot%202025-12-02%20153116.png)

**Deskripsi**: Menampilkan daftar semua produk dalam ListView. Klik [➕] untuk tambah produk, klik item untuk lihat detail.

### 4. Halaman Detail Produk
![image alt](https://github.com/zakychalamet/H1D023074_Tugas8/blob/480616dd16fd8fce07913e1716780c631dad3242/pics/Screenshot%202025-12-02%20153103.png)

**Deskripsi**: Menampilkan detail lengkap produk dengan tombol EDIT dan DELETE.

### 6. Halaman Form Edit Produk
![image alt](https://github.com/zakychalamet/H1D023074_Tugas8/blob/480616dd16fd8fce07913e1716780c631dad3242/pics/Screenshot%202025-12-02%20153052.png)

**Deskripsi**: Form untuk mengedit data produk.

### 5. Halaman Form Tambah Produk
![image alt](https://github.com/zakychalamet/H1D023074_Tugas8/blob/480616dd16fd8fce07913e1716780c631dad3242/pics/Screenshot%202025-12-02%20152220.png)

**Deskripsi**: Form untuk menginput data produk baru dengan validasi field.

### 6. Dialog Success
![image alt](https://github.com/zakychalamet/H1D023074_Tugas8/blob/480616dd16fd8fce07913e1716780c631dad3242/pics/Screenshot%202025-12-02%20152101.png)


### 7. Dialog Warning
![image alt](https://github.com/zakychalamet/H1D023074_Tugas8/blob/147c12c35ee1abdc426099f07b4befd2a627a394/pics/Screenshot%202025-12-02%20161926.png)

---

### 🔐 Proses Login

#### A. Membuka & Mengisi Form Login

**Screenshot & Penjelasan:**

Form login muncul saat pertama kali membuka aplikasi. User perlu memasukkan email dan password yang sudah terdaftar.

```dart
// filepath: lib/ui/login_page.dart
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _emailTextField(),      // Input email
              _passwordTextField(),   // Input password
              _buttonLogin(),         // Tombol login
              const SizedBox(height: 30),
              _menuRegistrasi(),      // Link ke registrasi
            ],
          ),
        ),
      ),
    );
  }
```

**Langkah-langkah:**
1. User membuka aplikasi dan melihat form login
2. Input email: `user@example.com`
3. Input password: `password123`
4. Tekan tombol "Login"

#### B. Validasi Form

Form memiliki validasi untuk memastikan email dan password tidak kosong:

```dart
// filepath: lib/ui/login_page.dart
Widget _emailTextField() {
  return TextFormField(
    decoration: const InputDecoration(labelText: "Email"),
    controller: _emailTextboxController,
    keyboardType: TextInputType.emailAddress,
    validator: (value) =>
        (value == null || value.isEmpty) ? "Email harus diisi" : null,
  );
}

Widget _passwordTextField() {
  return TextFormField(
    decoration: const InputDecoration(labelText: "Password"),
    obscureText: true,  // Menyembunyikan password
    controller: _passwordTextboxController,
    validator: (value) =>
        (value == null || value.isEmpty) ? "Password harus diisi" : null,
  );
}
```

**Penjelasan:**
- `validator`: Fungsi yang mengecek validitas input
- `obscureText: true`: Menyembunyikan karakter password (●●●●●)
- Jika field kosong, akan menampilkan error message

#### C. Proses Submit Login

Ketika user menekan tombol "Login", aplikasi melakukan:

```dart
// filepath: lib/ui/login_page.dart
Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) return;  // Cek validasi
  
  setState(() => _isLoading = true);  // Tampilkan loading

  try {
    // 1. Kirim request ke server
    final value = await LoginBloc.login(
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    );

    if (!mounted) return;

    if (value.code == 200) {
      // 2. Jika login berhasil, simpan token
      await UserInfo().setToken(value.token.toString());
      await UserInfo().setUserID(int.parse(value.userID.toString()));

      if (!mounted) return;

      // 3. Navigate ke halaman produk
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProdukPage()),
      );
    } else {
      // Login gagal - tampilkan warning dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const WarningDialog(
          description: "Login gagal, silahkan coba lagi",
        ),
      );
    }
  } catch (e) {
    if (!mounted) return;
    // Error handling
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const WarningDialog(
        description: "Terjadi kesalahan, silahkan coba lagi",
      ),
    );
  }

  if (mounted) {
    setState(() => _isLoading = false);
  }
}
```

#### D. Login Bloc - Request ke Server

```dart
// filepath: lib/bloc/login_bloc.dart
class LoginBloc {
  static Future<Login> login({String? email, String? password}) async {
    String apiUrl = ApiUrl.login;  // URL: http://localhost:8080/login

    var body = {"email": email, "password": password};

    // Kirim POST request
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    
    return Login.fromJson(jsonObj);
  }
}
```

**Response Sukses (Code 200):**
```json
{
  "code": 200,
  "status": true,
  "data": {
    "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "user": {
      "id": 1,
      "email": "user@example.com",
      "name": "John Doe"
    }
  }
}
```

#### E. Simpan Token (SharedPreferences)

```dart
// filepath: lib/helpers/user_info.dart
class UserInfo {
  Future setToken(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("token", value);
  }

  Future<String?> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token");
  }
}
```

Token disimpan di local storage dan digunakan untuk setiap request ke API.

---

### 📝 Proses Registrasi

#### A. Membuka Halaman Registrasi

Dari halaman login, klik link "Registrasi" untuk membuka form registrasi.

```dart
// filepath: lib/ui/login_page.dart
Widget _menuRegistrasi() {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RegistrasiPage()),
      );
    },
    child: const Text("Registrasi", style: TextStyle(color: Colors.blue)),
  );
}
```

#### B. Mengisi Form Registrasi

```dart
// filepath: lib/ui/registrasi_page.dart
class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrasi", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _namaTextField(),           // Input nama
                _emailTextField(),          // Input email
                _passwordTextField(),       // Input password
                _passwordKonfirmasiTextField(), // Konfirmasi password
                const SizedBox(height: 20),
                _buttonRegistrasi(),        // Tombol registrasi
              ],
            ),
          ),
        ),
      ),
    );
  }
```

#### C. Validasi Data

**1. Validasi Nama**
```dart
// filepath: lib/ui/registrasi_page.dart
Widget _namaTextField() {
  return TextFormField(
    decoration: const InputDecoration(labelText: "Nama"),
    controller: _namaTextboxController,
    validator: (value) {
      if (value == null || value.trim().length < 3) {
        return "Nama harus diisi minimal 3 karakter";
      }
      return null;
    },
  );
}
```
**Penjelasan:** Nama minimal 3 karakter dan tidak boleh kosong.

**2. Validasi Email**
```dart
// filepath: lib/ui/registrasi_page.dart
Widget _emailTextField() {
  return TextFormField(
    decoration: const InputDecoration(labelText: "Email"),
    keyboardType: TextInputType.emailAddress,
    controller: _emailTextboxController,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Email harus diisi';
      }

      final regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@'
        r'((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|'
        r'(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
      );

      if (!regex.hasMatch(value)) {
        return "Email tidak valid";
      }
      return null;
    },
  );
}
```
**Penjelasan:** Mengecek format email dengan regex pattern standar.

**3. Validasi Password**
```dart
// filepath: lib/ui/registrasi_page.dart
Widget _passwordTextField() {
  return TextFormField(
    decoration: const InputDecoration(labelText: "Password"),
    obscureText: true,
    controller: _passwordTextboxController,
    validator: (value) {
      if (value == null || value.length < 6) {
        return "Password minimal 6 karakter";
      }
      return null;
    },
  );
}
```
**Penjelasan:** Password minimal 6 karakter.

**4. Validasi Konfirmasi Password**
```dart
// filepath: lib/ui/registrasi_page.dart
Widget _passwordKonfirmasiTextField() {
  return TextFormField(
    decoration: const InputDecoration(labelText: "Konfirmasi Password"),
    obscureText: true,
    validator: (value) {
      if (value != _passwordTextboxController.text) {
        return "Konfirmasi Password tidak sama";
      }
      return null;
    },
  );
}
```
**Penjelasan:** Password konfirmasi harus sama dengan password yang diinput.

#### D. Submit Registrasi

```dart
// filepath: lib/ui/registrasi_page.dart
Future<void> _submit() async {
  setState(() {
    _isLoading = true;
  });

  try {
    // 1. Kirim data registrasi ke server
    await RegistrasiBloc.registrasi(
      nama: _namaTextboxController.text,
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    );

    if (!mounted) return;

    // 2. Jika berhasil, tampilkan success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessDialog(
        description: "Registrasi berhasil, silahkan login",
        okClick: () => Navigator.pop(context),
      ),
    );
  } catch (error) {
    if (!mounted) return;

    // 3. Jika gagal, tampilkan warning dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const WarningDialog(
        description: "Registrasi gagal, silahkan coba lagi",
      ),
    );
  }

  if (mounted) {
    setState(() {
      _isLoading = false);
    });
  }
}
```

#### E. Registrasi Bloc

```dart
// filepath: lib/bloc/registrasi_bloc.dart
class RegistrasiBloc {
  static Future<Registrasi> registrasi({
    String? nama,
    String? email,
    String? password,
  }) async {
    String apiUrl = ApiUrl.registrasi;  // http://localhost:8080/registrasi

    var body = {"nama": nama, "email": email, "password": password};

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return Registrasi.fromJson(jsonObj);
  }
}
```

**Request Body:**
```json
{
  "nama": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

**Response Sukses:**
```json
{
  "code": 200,
  "status": true,
  "data": "Registrasi berhasil"
}
```


### 📦 Proses CRUD Produk

#### 1. CREATE (Tambah Produk)

##### A. Buka Form Tambah Produk

Dari halaman produk, klik icon [➕] di AppBar:

```dart
// filepath: lib/ui/produk_page.dart
appBar: AppBar(
  title: const Text(
    'List Produk Fathan',
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.blue,
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        child: const Icon(Icons.add, size: 26.0, color: Colors.white),
        onTap: () {
          // Navigate ke ProdukForm untuk tambah produk baru
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProdukForm()),
          );
        },
      ),
    ),
  ],
),
```

##### B. Form Input Data Produk

```dart
// filepath: lib/ui/produk_form.dart
class ProdukForm extends StatefulWidget {
  final Produk? produk;  // null untuk create, filled untuk update

  const ProdukForm({super.key, this.produk});

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
```

##### C. Validasi Form Tambah Produk

```dart
// filepath: lib/ui/produk_form.dart
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
```

**Penjelasan:**
- Semua field harus diisi
- Harga hanya menerima input angka

##### D. Submit Tambah Produk

```dart
// filepath: lib/ui/produk_form.dart
Future<void> _simpanProduk() async {
  // 1. Buat object produk baru
  Produk produkBaru = Produk(id: null);
  produkBaru.kodeProduk = _kodeProdukTextboxController.text;
  produkBaru.namaProduk = _namaProdukTextboxController.text;
  produkBaru.hargaProduk = int.parse(_hargaProdukTextboxController.text);

  try {
    // 2. Kirim ke server via API
    await ProdukBloc.addProduk(produk: produkBaru);

    if (!mounted) return;

    // 3. Jika berhasil, kembali ke halaman list
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProdukPage()),
    );
  } catch (e) {
    if (!mounted) return;

    // 4. Jika gagal, tampilkan warning dialog
    showDialog(
      context: context,
      builder: (_) => const WarningDialog(
        description: "Simpan gagal, silahkan coba lagi",
      ),
    );
  }
}
```

##### E. Produk Bloc - Tambah Produk

```dart
// filepath: lib/bloc/produk_bloc.dart
class ProdukBloc {
  static Future<bool> addProduk({required Produk produk}) async {
    String apiUrl = ApiUrl.createProduk;  // http://localhost:8080/produk

    var body = {
      "kode_produk": produk.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk.toString(),
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);

    return jsonObj['status'];
  }
}
```

**Request:**
```
POST /produk
Authorization: Bearer {token}
Content-Type: application/x-www-form-urlencoded

kode_produk=PRD-002&nama_produk=Monitor&harga=2500000
```

**Response:**
```json
{
  "code": 200,
  "status": true,
  "data": "Produk berhasil ditambahkan"
}
```

---

#### 2. READ (Lihat Daftar & Detail Produk)

##### A. Tampilkan Daftar Produk

```dart
// filepath: lib/ui/produk_page.dart
class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List Produk Fathan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProdukForm()),
                );
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout();

                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      // 1. Ambil data produk dari server
      body: FutureBuilder<List>(
        future: ProdukBloc.getProduks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) debugPrint(snapshot.error.toString());

          return snapshot.hasData
              ? ListProduk(list: snapshot.data)  // Tampilkan list
              : const Center(child: CircularProgressIndicator());  // Loading
        },
      ),
    );
  }
}
```

##### B. Produk Bloc - Get Semua Produk

```dart
// filepath: lib/bloc/produk_bloc.dart
class ProdukBloc {
  static Future<List<Produk>> getProduks() async {
    String apiUrl = ApiUrl.listProduk;  // http://localhost:8080/produk

    var response = await Api().get(apiUrl);  // GET request dengan token
    var jsonObj = json.decode(response.body);

    List listProduk = jsonObj['data'];
    return listProduk.map((e) => Produk.fromJson(e)).toList();
  }
}
```

**Request:**
```
GET /produk
Authorization: Bearer {token}
```

**Response:**
```json
{
  "code": 200,
  "status": true,
  "data": [
    {
      "id": 1,
      "kode_produk": "PRD-001",
      "nama_produk": "Laptop Dell",
      "harga": 7500000
    },
    {
      "id": 2,
      "kode_produk": "PRD-002",
      "nama_produk": "Monitor LG",
      "harga": 2500000
    }
  ]
}
```

##### C. Tampilkan Item Produk

```dart
// filepath: lib/ui/produk_page.dart
class ListProduk extends StatelessWidget {
  final List? list;

  const ListProduk({super.key, this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list?.length ?? 0,
      itemBuilder: (context, i) => ItemProduk(produk: list![i]),
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;

  const ItemProduk({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Klik item -> navigate ke detail
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProdukDetail(produk: produk)),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(produk.namaProduk ?? '-'),
          subtitle: Text(produk.hargaProduk.toString()),
        ),
      ),
    );
  }
}
```

##### D. Tampilkan Detail Produk

```dart
// filepath: lib/ui/produk_detail.dart
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
```

---

#### 3. UPDATE (Edit Produk)

##### A. Tombol Edit di Detail Produk

```dart
// filepath: lib/ui/produk_detail.dart
Widget _tombolHapusEdit() {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      OutlinedButton(
        style: OutlinedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: () {
          // Klik EDIT -> navigate ke ProdukForm dengan data produk
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
      // ... DELETE button
    ],
  );
}
```

##### B. Form Edit (Reuse ProdukForm)

Form sudah ter-fill dengan data produk lama:

```dart
// filepath: lib/ui/produk_form.dart
void _setupForm() {
  if (widget.produk != null) {
    judul = "UBAH PRODUK";
    tombolSubmit = "UBAH";
    _kodeProdukTextboxController.text = widget.produk!.kodeProduk ?? "";
    _namaProdukTextboxController.text = widget.produk!.namaProduk ?? "";
    _hargaProdukTextboxController.text =
        widget.produk!.hargaProduk.toString();  // Data ter-fill
  } else {
    judul = "TAMBAH PRODUK";
    tombolSubmit = "SIMPAN";
  }
}
```

##### C. Submit Update Produk

```dart
// filepath: lib/ui/produk_form.dart
Future<void> _ubahProduk() async {
  // 1. Buat object produk dengan data terupdate
  Produk updated = Produk(id: widget.produk!.id);
  updated.kodeProduk = _kodeProdukTextboxController.text;
  updated.namaProduk = _namaProdukTextboxController.text;
  updated.hargaProduk = int.parse(_hargaProdukTextboxController.text);

  try {
    // 2. Kirim update ke server
    await ProdukBloc.updateProduk(produk: updated);

    if (!mounted) return;

    // 3. Jika berhasil, kembali ke list
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProdukPage()),
    );
  } catch (e) {
    if (!mounted) return;

    // 4. Jika gagal, tampilkan warning
    showDialog(
      context: context,
      builder: (_) => const WarningDialog(
        description: "Permintaan ubah data gagal, silahkan coba lagi",
      ),
    );
  }
}
```

##### D. Produk Bloc - Update Produk

```dart
// filepath: lib/bloc/produk_bloc.dart
class ProdukBloc {
  static Future<bool> updateProduk({required Produk produk}) async {
    String apiUrl = ApiUrl.updateProduk(int.parse(produk.id!));
    // URL: http://localhost:8080/produk/1

    var body = {
      "kode_produk": produk.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk.toString(),
    };

    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);

    return jsonObj['status'];
  }
}
```

**Request:**
```
PUT /produk/1
Authorization: Bearer {token}
Content-Type: application/json

{
  "kode_produk": "PRD-001-UPDATED",
  "nama_produk": "Laptop Dell XPS",
  "harga": "8000000"
}
```

**Response:**
```json
{
  "code": 200,
  "status": true,
  "data": "Produk berhasil diubah"
}
```

---

#### 4. DELETE (Hapus Produk)

##### A. Tombol Delete di Detail Produk

```dart
// filepath: lib/ui/produk_detail.dart
OutlinedButton(
  style: OutlinedButton.styleFrom(backgroundColor: Colors.red),
  onPressed: () => _confirmHapus(),  // Buka dialog konfirmasi
  child: const Text("DELETE", style: TextStyle(color: Colors.white)),
),
```

##### B. Dialog Konfirmasi Hapus

```dart
// filepath: lib/ui/produk_detail.dart
void _confirmHapus() {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        // Tombol YA
        OutlinedButton(
          onPressed: () => _hapusProduk(),
          child: const Text("Ya"),
        ),

        // Tombol BATAL
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
      ],
    ),
  );
}
```

##### C. Submit Hapus Produk

```dart
// filepath: lib/ui/produk_detail.dart
Future<void> _hapusProduk() async {
  try {
    // 1. Kirim request delete ke server
    await ProdukBloc.deleteProduk(id: int.parse(widget.produk.id!));

    if (!mounted) return;

    // 2. Jika berhasil, kembali ke list
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProdukPage()),
    );
  } catch (e) {
    if (!mounted) return;

    // 3. Jika gagal, tampilkan warning
    showDialog(
      context: context,
      builder: (_) => const WarningDialog(
        description: "Hapus gagal, silahkan coba lagi",
      ),
    );
  }
}
```

##### D. Produk Bloc - Delete Produk

```dart
// filepath: lib/bloc/produk_bloc.dart
class ProdukBloc {
  static Future<bool> deleteProduk({required int id}) async {
    String apiUrl = ApiUrl.deleteProduk(id);
    // URL: http://localhost:8080/produk/1

    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);

    return jsonObj['data'];
  }
}
```

**Request:**
```
DELETE /produk/1
Authorization: Bearer {token}
```

**Response:**
```json
{
  "code": 200,
  "status": true,
  "data": true,
  "message": "Produk berhasil dihapus"
}
```

## 🔗 API Endpoints

### Authentication
```
POST /api/auth/register
POST /api/auth/login
POST /api/auth/logout
```

### Products
```
GET /api/products              # Get all products
GET /api/products/{id}         # Get single product
POST /api/products             # Create product
PUT /api/products/{id}         # Update product
DELETE /api/products/{id}      # Delete product
```

---

## 💡 Penjelasan Kode

### 1. Model Layer (`model/`)

**login.dart** - Merepresentasikan response login dari server

**registrasi.dart** - Merepresentasikan response registrasi

**produk.dart** - Merepresentasikan data produk dengan mapping dari JSON

### 2. Bloc Layer (`bloc/`)

**login_bloc.dart** - Menangani logika login, memanggil API

**registrasi_bloc.dart** - Menangani logika registrasi

**produk_bloc.dart** - Menangani semua operasi CRUD produk (GET, POST, PUT, DELETE)

**logout_bloc.dart** - Menangani logout dan clear session

### 3. UI Layer (`ui/`)

**login_page.dart** - Halaman login dengan validasi form

**registrasi_page.dart** - Halaman registrasi dengan validasi lengkap

**produk_page.dart** - Halaman list produk dengan drawer menu

**produk_form.dart** - Form reusable untuk tambah & edit produk

**produk_detail.dart** - Halaman detail produk dengan tombol edit & delete

### 4. Helper Layer (`helpers/`)

**api.dart** - Class untuk handle HTTP requests (GET, POST, PUT, DELETE) dengan token

**api_url.dart** - Constants untuk semua API endpoints

**api_exception.dart** - Custom exception classes untuk error handling

**user_info.dart** - Manage token di SharedPreferences

### 5. Widget Layer (`widget/`)

**success_dialog.dart** - Custom dialog untuk success notification

**warning_dialog.dart** - Custom dialog untuk error notification

---

