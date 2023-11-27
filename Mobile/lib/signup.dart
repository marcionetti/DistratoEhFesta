import 'dart:developer';
import './dashboard.dart';
import 'package:flutter/material.dart';
import './Widget/bezierContainer.dart';
import './loginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import './global.dart' as global;
import 'package:checkbox_formfield/checkbox_formfield.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _tName = TextEditingController();
  final _tLogin = TextEditingController();
  final _tSenha = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _NameField() {
    return TextFormField(
        controller: _tName,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Informar Nome';
          }
          return null;
        },
        keyboardType: TextInputType.text,
        style: TextStyle(color: Color(0xfff7892b)),
        decoration: InputDecoration(
            labelText: "Nome",
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xfff7892b),
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 4.0,
                  color: Color.fromARGB(255, 105, 57, 14),
                ),
              ],
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: Color.fromARGB(255, 105, 57, 14)),
              // borderRadius: BorderRadius.circular(15),
            ),
            fillColor: Color(0xfff3f3f4),
            filled: true));
  }

  Widget _LoginField() {
    return TextFormField(
        controller: _tLogin,
        validator: (value) {
          RegExp regex = RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
          if (value == null || value.isEmpty) {
            return 'Informar senha';
          } else {
            if (!regex.hasMatch(value)) {
              return 'Informar e-mail válido.';
            }
          }
          return null;
        },
        keyboardType: TextInputType.text,
        style: TextStyle(color: Color(0xfff7892b)),
        decoration: InputDecoration(
            labelText: "E-mail",
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xfff7892b),
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 4.0,
                  color: Color.fromARGB(255, 105, 57, 14),
                ),
              ],
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: Color.fromARGB(255, 105, 57, 14)),
              // borderRadius: BorderRadius.circular(15),
            ),
            fillColor: Color(0xfff3f3f4),
            filled: true));
  }

  Widget _PassField() {
    return TextFormField(
        controller: _tSenha,
        validator: (value) {
          RegExp regex = RegExp(
              r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[$*&@#])(?:([0-9a-zA-Z$*&@#])(?!\1)){8,}$');
          if (value == null || value.isEmpty) {
            return 'Informar senha';
          } else {
            if (!regex.hasMatch(value)) {
              return 'Senha precisa conter:\n   8 caracteres no mínimo\n   1 Letra Maiúscula no mínimo\n   1 Número no mínimo\n   1 Símbolo no mínimo.';
            }
          }
          return null;
        },
        keyboardType: TextInputType.text,
        style: TextStyle(color: Color(0xfff7892b)),
        obscureText: true,
        decoration: InputDecoration(
            labelText: "Senha",
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xfff7892b),
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 4.0,
                  color: Color.fromARGB(255, 105, 57, 14),
                ),
              ],
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: Color.fromARGB(255, 105, 57, 14)),
              // borderRadius: BorderRadius.circular(15),
            ),
            fillColor: Color(0xfff3f3f4),
            filled: true));
  }

  Widget _ConfirmField() {
    return CheckboxListTileFormField(
      activeColor: Color(0xfff7892b),
      title: Text(
        ' Eu aceito os Termos de Serviço ',
        style: GoogleFonts.sourceSansPro(
          textStyle: Theme.of(context).textTheme.headline1,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color.fromARGB(255, 238, 120, 17),
          backgroundColor: Color.fromARGB(100, 245, 239, 235),
          shadows: [
            Shadow(
              blurRadius: 1.5,
              color: Color.fromARGB(255, 77, 49, 5),
              offset: Offset(1.0, 1.0),
            ),
          ],
        ),
      ),
      validator: (value) {
        if (value == false) {
          return 'Necessário aceitar o Termos de Serviço para continuar!';
        }
        return null;
        // else {
        //
        //   }
      },
      onChanged: (value) {
        if (value) {
          print("ListTile Checked :)");
          print(value);
        } else {
          print("ListTile Not Checked :(");
          print(value);
        }
      },
      autovalidateMode: AutovalidateMode.always,
      contentPadding: EdgeInsets.all(1),
    );
  }

  _enviaLogin(context, Nome, Email, Senha, lnkFacebook) async {
    print("_enviaLogin");
    final response = await http.post(
      Uri.parse(global.baseUrl + 'APILogin/addLogin'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': global.Token,
      },
      body: jsonEncode(
        <String, String>{
          'Nome': Nome,
          'Email': Email,
          'Senha': Senha,
          'lnkFacebook': lnkFacebook,
        },
      ),
    );
    print("resp");
    final resp = jsonDecode(response.body);
    inspect(resp);
    if (resp['status'] == '200') {
      // print("Sucesso");
      final data = resp['data'][0];
      global.logUser['id'] = data['ID'];
      global.logUser['cod'] = data['Cod'];
      global.logUser['nome'] = data['Nome'];
      global.logUser['email'] = data['Email'];
      global.logUser['img'] = data['imgpessoa'];
      // print(global.logUser);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DashBoard()));
    } else if (resp['status'] == 401) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: new Text("Erro 20156"),
                content: Text("Erro ao se conectar com o servidor!"),
                actions: <Widget>[
                  // define os botões na base do dialogo
                  new TextButton(
                    child: new Text("Fechar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: new Text("Confirmação"),
                content: Text("!! Erro ao enviar comentário !!!"),
                actions: <Widget>[
                  // define os botões na base do dialogo
                  new TextButton(
                    child: new Text("Fechar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
    }
  }

  _getUserFB(context, final nome, final email, final senha) async {
    print("_getUserFB");
    print(global.baseUrl + '/APILogin/' + email);
    final response = await http
        .get(Uri.parse(global.baseUrl + '/APILogin/' + email), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': global.Token,
    });
    // print("response");
    // inspect(response.body);
    final resp = jsonDecode(response.body);
    print("resp");
    print(resp);
    // print(resp['status']);

    if (resp['status'] == '200') {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: new Text("E-mail Inválido"),
                content: Text("E-mail já cadastrado no sistema!"),
                actions: <Widget>[
                  // define os botões na base do dialogo
                  new TextButton(
                    child: new Text("Fechar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
      // print(nsenha);
    } else if (resp['status'] == 401) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: new Text("Erro 20156"),
                content: Text("Erro ao se conectar com o servidor!"),
                actions: <Widget>[
                  // define os botões na base do dialogo
                  new TextButton(
                    child: new Text("Fechar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
    } else {
      // print("Cadastrar usuário");
      _enviaLogin(context, nome, email, '', senha);
    }

    return jsonDecode(response.body);
  }

  _getUser(context, final nome, final email, final senha) async {
    // print("_getUser");
    print(global.baseUrl + '/APILogin/' + email);
    final response = await http
        .get(Uri.parse(global.baseUrl + '/APILogin/' + email), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': global.Token,
    });
    // print("response");
    // inspect(response.body);
    final resp = jsonDecode(response.body);
    // print("resp");
    // print(resp);
    // print(resp['status']);

    if (resp['status'] == '200') {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: new Text("E-mail Inválido"),
                content: Text("E-mail já cadastrado no sistema!"),
                actions: <Widget>[
                  // define os botões na base do dialogo
                  new TextButton(
                    child: new Text("Fechar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
      // print(nsenha);
    } else if (resp['status'] == 401) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: new Text("Erro 20156"),
                content: Text("Erro ao se conectar com o servidor!"),
                actions: <Widget>[
                  // define os botões na base do dialogo
                  new TextButton(
                    child: new Text("Fechar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
    } else {
      // print("Cadastrar usuário");
      _enviaLogin(context, nome, email, senha, '');
    }

    return jsonDecode(response.body);
  }

  _onClickLogin(BuildContext context) {
    final nome = _tName.text;
    final login = _tLogin.text;
    final senha = _tSenha.text;
    if (_formKey.currentState!.validate()) {
      // var response = _getUser(login, senha);
      // debugPrint(response);
      var response = _getUser(
        context,
        nome,
        login,
        senha,
      );
      return;
    }
  }

  Widget _submitButton() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SignInButtonBuilder(
            text: 'Criar',
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * 0.1),
            icon: Icons.save,
            onPressed: () {
              _onClickLogin(context);
            },
            backgroundColor: Color(0xfff7892b),
            width: 95,
          )
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('ou'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  _FBLoginButton(BuildContext context) async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: [
        'email',
        'public_profile',
        'user_birthday',
        'user_friends',
      ],
    ); // by default we request the email and the public profile
// or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final userData = await FacebookAuth.instance.getUserData();
      print("FB Login OK");
      print(userData['email']);
      var response = _getUserFB(
          context, userData['name'], userData['email'], userData['id']);
    } else {
      print(result.status);
      print(result.message);
    }
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SignInButton(
            Buttons.FacebookNew,
            text: "Entrar com Facebook",
            onPressed: () {
              _FBLoginButton(context);
            },
          )
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'EhFesta',
        style: GoogleFonts.portLligatSans(
          textStyle: Theme.of(context).textTheme.headline1,
          fontSize: 80,
          fontWeight: FontWeight.w900,
          color: Color(0xfff7892b),
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Color.fromARGB(255, 51, 34, 3),
              offset: Offset(5.0, 5.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _NameField(),
        SizedBox(height: 10),
        _LoginField(),
        SizedBox(height: 10),
        _PassField(),
        SizedBox(height: 10),
        _ConfirmField(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Container(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        global.baseUrl + '/resources/images/ehfesta3.jpeg'),
                    opacity: 0.3,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _title(),
                      SizedBox(height: 40),
                      _emailPasswordWidget(),
                      SizedBox(height: 20),
                      _submitButton(),
                      _divider(),
                      _facebookButton(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
