import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import './global.dart' as global;
import 'dart:developer';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import './presentear.dart';
import './listaConvidados.dart';
import './comentarios.dart';
import 'conviteEdit.dart';
import './dashboard.dart';

class Convite extends StatelessWidget {
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Convite({this.conviteCod});

  final String? conviteCod;

  int Proprietario = 0;
  int ConStatus = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Convite"),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.edit_note),
        //     color: Colors.white,
        //     iconSize: 35,
        //     onPressed: Proprietario != 0
        //         ? () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) =>
        //                       ConviteEdit(conviteCod: conviteCod)),
        //             );
        //           }
        //         : null,
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Widget>(
            future: _buildCard(context, conviteCod),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return snapshot.data;
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  _getConvite(conviteCod) async {
    final response = await http.get(
        Uri.parse('${global.baseUrl}/APIConvites/' + conviteCod),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': global.Token,
        });
    final resp = jsonDecode(response.body);
    if (resp['status'] == '200') {
      final data = resp['data'];
      // print("url");
      // inspect(data);
      return data;
    }
    final data = [];
    return data;
  }

  Future<Widget> _buildCard(context, conviteCod) async {
    // print("Cod:$conviteCod");

    List products = await _getConvite(conviteCod);

    // inspect(products);

    final product = products[0];

    String? endereco = product["Endereco"];

    // int Proprietario = 0;

    ConStatus = product["Status"] == '1' ? 1 : 0;

    global.logUser['cod'] == product["cadUserID"]
        ? Proprietario = 1
        : Proprietario = 0;

    // inspect(product);
    if (products.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: MediaQuery.of(context).size.height),
              Text("Convite não encontrado!"),
              // _createAccountLabel(),
            ],
          ),
        ),
      );
    }

    Widget _labelText(txtLabel) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: txtLabel,
          style: GoogleFonts.sourceSansPro(
            textStyle: Theme.of(context).textTheme.headline1,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xfff7892b),
          ),
        ),
      );
    }

    Widget _fieldText(txtField) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: txtField,
          style: GoogleFonts.sourceSansPro(
            textStyle: Theme.of(context).textTheme.headline1,
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 15, 13, 11),
          ),
        ),
      );
    }

    _confPresenca(respUser, UserEmail, codConvite) async {
      // print("_confPresenca");
      final response = await http.post(
        Uri.parse(global.baseUrl + 'APIConfirmaConvites/Confirma'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': global.Token,
        },
        body: jsonEncode(
          <String, String>{
            'UserEmail': UserEmail,
            'codConvite': codConvite,
            'resp': respUser,
          },
        ),
      );
      final resp = jsonDecode(response.body);

      if (resp['status'] == '200') {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: new Text("Confirmação"),
                  content: Text("Resposta registrada!"),
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
                  content: Text("!! Erro no registro da confirmação !!!"),
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

    _promoveConvite(Codconvite) async {
      print("_promoveConvite");
      print(Codconvite);
      final response = await http.post(
        Uri.parse(global.baseUrl + 'APIConvites/PromoveConvite'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': global.Token,
        },
        body: jsonEncode(
          <String, String>{
            'CodConvite': Codconvite,
          },
        ),
      );
      print(response);
      final resp = jsonDecode(response.body);
      print(resp);
      if (resp['status'] == '200') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashBoard()));
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: new Text("Confirmação"),
                  content: Text("!! Erro ao promover Convite !!!"),
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

    _acompanhante(AcompNome, AcompEmail, AcompParent, AcompDetalhe, Convidado,
        ConvidadoEmail, Codconvite) async {
      print("_acompanahte");
      print(Proprietario);

      Convidado = Proprietario != 1 ? Convidado : "";
      print(Convidado);

      final response = await http.post(
        Uri.parse(global.baseUrl + 'APIConvidados/Acompanhante'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': global.Token,
        },
        body: jsonEncode(
          <String, String>{
            'CodConvite': Codconvite,
            'Convidado': Convidado,
            'ConvidadoEmail': ConvidadoEmail,
            'Nome': AcompNome,
            'Email': AcompEmail,
            'Parentesco': AcompParent,
            'Detalhe': AcompDetalhe,
          },
        ),
      );
      print(response);
      final resp = jsonDecode(response.body);
      print(resp);
      if (resp['status'] == '200') {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => DashBoard()));
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: new Text("Confirmação"),
                  content: Text("!! Erro ao salvar Acompanante!!!"),
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

    _enviaLink(dest, coment, userNome, codConvite) async {
      print("_enviaLink");
      print(jsonEncode(
        <String, String>{
          'dest': dest,
          'coment': coment,
          'userNome': userNome,
          'codConvite': codConvite,
        },
      ));
      try {
        final response = await http.post(
          Uri.parse(global.baseUrl + 'APIEnviarLink/EnviarLink'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': global.Token,
          },
          body: jsonEncode(
            <String, String>{
              'dest': dest,
              'coment': coment,
              'userNome': userNome,
              'codConvite': codConvite,
            },
          ),
        );
        final resp = jsonDecode(response.body);
        print("resp");
        print(resp);
        if (resp['status'] == '200') {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: new Text("Confirmação"),
                    content: Text("Convite Compartilhado"),
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
                    content: Text(resp['data']),
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
      } catch (e) {
        print("Erro ao enviar o link: $e");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Erro"),
            content: Text(
                "Ocorreu um erro ao enviar o link. Tente novamente mais tarde."),
            actions: <Widget>[
              TextButton(
                child: Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }

    Future<void> _dialogRSVP(BuildContext context) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmação de presença'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Confirmar
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff009d7c), // Background color
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.thumbsUp,
                    size: 20,
                  ),
                  label: Text('Confirmar', style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    var result = _confPresenca(
                        "1", global.logUser['email'], product["Cod"]);
                    Navigator.of(context).pop();
                    // print(result);
                  },
                ),
                SizedBox(height: 5),
                //Nao sei
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff52add5), // Background color
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.ban,
                    size: 20,
                  ),
                  label: Text('Não sei', style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    var result = _confPresenca(
                        "0", global.logUser['email'], product["Cod"]);
                    Navigator.of(context).pop();
                    // print(result);
                  },
                ),
                SizedBox(height: 5),
                //Nao poderei
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffdc3545), // Background color
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.thumbsDown,
                    size: 20,
                  ),
                  label: Text('Não poderei', style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    var result = _confPresenca(
                        "2", global.logUser['email'], product["Cod"]);
                    Navigator.of(context).pop();
                    // print(result);
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Fechar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    _btnRSVP() {
      return Center(
        child: Ink(
          decoration: BoxDecoration(
            color: Color(0xfffd7e14),
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            icon: FaIcon(FontAwesomeIcons.thumbsUp),
            color: Colors.white,
            onPressed: () {
              // print(global.logUser['cod']);
              _dialogRSVP(context);
            },
          ),
        ),
      );
    }

    Future<void> _dialogConv(BuildContext context) {
      final _tAcompNome = TextEditingController();
      final _tAcompEmail = TextEditingController();
      final _tAcompParent = TextEditingController();
      final _tAcompDetalhe = TextEditingController();

      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Acompanhante'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                TextField(
                    controller: _tAcompNome,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    style: TextStyle(color: Color(0xfff7892b)),
                    decoration: InputDecoration(
                      labelText: "Nome",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xfff7892b),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Color.fromARGB(255, 105, 57, 14)),
                        // borderRadius: BorderRadius.circular(15),
                      ),
                      // fillColor: Color(0xfff3f3f4),
                    )),
                SizedBox(height: 10),
                TextField(
                    controller: _tAcompEmail,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    style: TextStyle(color: Color(0xfff7892b)),
                    decoration: InputDecoration(
                      labelText: "E-Mail",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xfff7892b),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Color.fromARGB(255, 105, 57, 14)),
                        // borderRadius: BorderRadius.circular(15),
                      ),
                      // fillColor: Color(0xfff3f3f4),
                    )),
                SizedBox(height: 10),
                TextField(
                    controller: _tAcompParent,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    style: TextStyle(color: Color(0xfff7892b)),
                    decoration: InputDecoration(
                      labelText: "Parentesco",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xfff7892b),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Color.fromARGB(255, 105, 57, 14)),
                        // borderRadius: BorderRadius.circular(15),
                      ),
                      // fillColor: Color(0xfff3f3f4),
                    )),
                SizedBox(height: 10),
                TextField(
                    controller: _tAcompDetalhe,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    style: TextStyle(color: Color(0xfff7892b)),
                    decoration: InputDecoration(
                      labelText: "Detalhe",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xfff7892b),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Color.fromARGB(255, 105, 57, 14)),
                        // borderRadius: BorderRadius.circular(15),
                      ),
                      // fillColor: Color(0xfff3f3f4),
                    )),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff009d7c), // Background color
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.paperPlane,
                    size: 20,
                  ),
                  label: Text('Enviar', style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    var result = _acompanhante(
                        _tAcompNome.text,
                        _tAcompEmail.text,
                        _tAcompParent.text,
                        _tAcompDetalhe.text,
                        global.logUser['nome'],
                        global.logUser['email'],
                        product["Cod"]);
                    Navigator.of(context).pop();
                    // print(result);
                  },
                ),
                SizedBox(height: 5),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Fechar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    _btnAddConv() {
      return Center(
        child: Ink(
          decoration: BoxDecoration(
            color: Color(0xff6f42c1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            icon: FaIcon(FontAwesomeIcons.userPlus),
            color: Colors.white,
            onPressed: () {
              _dialogConv(context);
            },
          ),
        ),
      );
    }

    Future<void> _dialogProm(BuildContext context) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Promover esse evento?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary:
                        Color.fromARGB(255, 193, 209, 253), // Background color
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.shareSquare,
                    size: 20,
                  ),
                  label: Text(
                    'Promover',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    var result = _promoveConvite(product["Cod"]);
                    Navigator.of(context).pop();
                    // print(result);
                  },
                ),
                SizedBox(height: 5),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Fechar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    _btnPromove() {
      return Center(
        child: Ink(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 65, 115, 252),
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            icon: FaIcon(FontAwesomeIcons.shareSquare),
            color: Colors.white,
            onPressed: () {
              _dialogProm(context);
            },
          ),
        ),
      );
    }

    _btnMsg() {
      return Center(
        child: Ink(
          decoration: BoxDecoration(
            color: Color(0xff0062cc),
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            icon: FaIcon(FontAwesomeIcons.comments),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        // Comentarios(conviteCod: product["Cod"])));
                        Comentarios(
                      conviteCod: product["Cod"],
                      onComentarioEnviado: () {
                        // Este código será executado após o envio bem-sucedido do comentário
                        // Atualize as informações da tela aqui
                        // Por exemplo, você pode chamar setState para reconstruir a árvore de widgets.
                      },
                    ),
                  ));
            },
          ),
        ),
      );
    }

    Future<void> _dialogEnviar(BuildContext context) {
      final _tLogin = TextEditingController();
      final _tComent = TextEditingController();

      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Compartilhar Link'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                    controller: _tLogin,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informar e-mail válido';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Color(0xfff7892b)),
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xfff7892b),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Color.fromARGB(255, 105, 57, 14)),
                        // borderRadius: BorderRadius.circular(15),
                      ),
                      // fillColor: Color(0xfff3f3f4),
                    )),
                SizedBox(height: 10),
                TextField(
                    controller: _tComent,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    style: TextStyle(color: Color(0xfff7892b)),
                    decoration: InputDecoration(
                      labelText: "Comentário",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xfff7892b),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Color.fromARGB(255, 105, 57, 14)),
                        // borderRadius: BorderRadius.circular(15),
                      ),
                      // fillColor: Color(0xfff3f3f4),
                    )),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff009d7c), // Background color
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.paperPlane,
                    size: 20,
                  ),
                  label: Text('Enviar', style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    var result = _enviaLink(_tLogin.text, _tComent.text,
                        global.logUser['nome'], product["Cod"]);
                    Navigator.of(context).pop();
                    // print(result);
                  },
                ),
                SizedBox(height: 5),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Fechar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    _btnEnviar() {
      return Center(
        child: Ink(
          decoration: BoxDecoration(
            color: Color(0xffe83e8c),
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            icon: FaIcon(FontAwesomeIcons.shareAlt),
            color: Colors.white,
            onPressed: () {
              _dialogEnviar(context);
            },
          ),
        ),
      );
    }

    _btnConv() {
      return Center(
        child: Ink(
          decoration: BoxDecoration(
            color: Color(0xff52add5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            icon: FaIcon(FontAwesomeIcons.list),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ListaConvidados(conviteCod: product["Cod"])));
            },
          ),
        ),
      );
    }

    _btnPresente() {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Color(0xffbd2130), // Background color
        ),
        icon: FaIcon(
          FontAwesomeIcons.gift,
          size: 30,
        ),
        label: Text('Presentear', style: TextStyle(fontSize: 18)),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Presentear(conviteCod: product["Cod"])));
        },
      );
    }

    _cardTitulo() {
      return Row(
        children: <Widget>[
          Container(
            width: 40,
            color: Color(0xFF009d7c),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FaIcon(FontAwesomeIcons.calendarAlt, color: Colors.white),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.77,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _labelText("Evento"),
                _fieldText(product["Titulo"]),
                SizedBox(height: 5),
                _labelText("Descrição"),
                _fieldText(product["Descricao"]),
                SizedBox(height: 5),
                _labelText("Data"),
                _fieldText(product["DataEventoDesc"]),
                SizedBox(height: 5),
                _labelText("Horário"),
                _fieldText(product["HoraInicioDesc"] +
                    " às " +
                    product["HoraFimDesc"]),
              ],
            ),
          ),
        ],
      );
    }

    _cardTipo() {
      return Row(
        children: <Widget>[
          Container(
            width: 40,
            color: Color(0xFF52add5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FaIcon(FontAwesomeIcons.bookmark, color: Colors.white),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.77,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _labelText("Ocasião"),
                _fieldText(product["TipoEventoDesc"]),
                SizedBox(height: 5),
                _labelText("Publico"),
                _fieldText(product["TipoPublicoDesc"]),
                SizedBox(height: 5),
                _labelText("Convite Individual"),
                _fieldText(product["ConvidarDesc"]),
              ],
            ),
          ),
        ],
      );
    }

    _cardObs() {
      return Row(
        children: <Widget>[
          Container(
            width: 40,
            color: Color(0xFF6c757d),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FaIcon(FontAwesomeIcons.bullhorn, color: Colors.white),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.77,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _labelText("Observação"),
                _fieldText(product["Obs"]),
              ],
            ),
          ),
        ],
      );
    }

    _cardEndereco() {
      return Row(
        children: <Widget>[
          Container(
            width: 40,
            color: Color(0xFF001f3f),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FaIcon(FontAwesomeIcons.flag, color: Colors.white),
              ],
            ),
          ),
          GestureDetector(
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.77,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _labelText("Endereço"),
                  _fieldText(product["Endereco"]),
                  SizedBox(height: 10),
                  _labelText("Mapa"),
                  ElevatedButton(
                    onPressed: () =>
                        MapsLauncher.launchQuery(product["Endereco"]),
                    child: FaIcon(FontAwesomeIcons.mapMarked,
                        color: Colors.white,
                        semanticLabel: "Abrir Mapa",
                        size: 30),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 38, 89, 141),
                        padding: EdgeInsets.symmetric(
                            vertical: 5, horizontal: 30) // Background color
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
              NetworkImage('${global.baseUrl}resources/images/ehfesta3.jpeg'),
          opacity: 0.2,
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (Proprietario == 1)
              ElevatedButton.icon(
                icon: Icon(Icons.edit_note),
                label: Text("Editar Convite"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ConviteEdit(conviteCod: conviteCod)),
                  );
                },
              ),
            SizedBox(width: MediaQuery.of(context).size.height, height: 10.0),
            AspectRatio(
              aspectRatio: 18 / 11,
              child: GestureDetector(
                onTap: () {
                  // print(product["Cod"]);
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return Scaffold(
                      body: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                '${global.baseUrl}/resources/img/Convite/' +
                                    (product["Img"] ?? 'noImage.gif') +
                                    '?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                              ),
                              fit: BoxFit.none,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                    ;
                  }));
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        '${global.baseUrl}/resources/img/Convite/' +
                            (product["Img"] ?? 'noImage.gif') +
                            '?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Stack(
              children: <Widget>[
                Container(
                  // color: Color(0xFF009d7c),
                  width: MediaQuery.of(context).size.width,
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 10),
                                  if (ConStatus == 1) _btnPromove(),
                                  if (ConStatus == 0) SizedBox(height: 10),
                                  if (Proprietario == 1 && ConStatus == 0)
                                    _btnRSVP(),
                                  if (ConStatus == 0) SizedBox(width: 10),
                                  if (ConStatus == 0) _btnAddConv(),
                                  if (ConStatus == 0) SizedBox(width: 10),
                                  if (ConStatus == 0) _btnMsg(),
                                  if (ConStatus == 0) SizedBox(width: 10),
                                  if (ConStatus == 0) _btnEnviar(),
                                  if (ConStatus == 0) SizedBox(width: 10),
                                  if (ConStatus == 0) _btnConv(),
                                ],
                              ),
                              SizedBox(height: 10),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: <Widget>[
                              //     if (Proprietario == 1) _btnPresente(),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                        IntrinsicHeight(
                          child: _cardTitulo(),
                        ),
                        SizedBox(height: 10),
                        IntrinsicHeight(
                          child: _cardTipo(),
                        ),
                        SizedBox(height: 10),
                        IntrinsicHeight(
                          child: _cardObs(),
                        ),
                        SizedBox(height: 10),
                        /******************/
                        // Localização
                        IntrinsicHeight(
                          child: _cardEndereco(),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
