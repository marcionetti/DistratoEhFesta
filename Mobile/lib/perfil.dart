import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import './global.dart' as global;
import 'dart:developer';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import './presentear.dart';
import './listaConvidados.dart';
import './comentarios.dart';
import './dashboard.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';

class Perfil extends StatefulWidget {
  const Perfil({Key? key}) : super(key: key);

  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  XFile? _imageFile;

  Image? imgPerfil;
  File? upPerfil;

  final _globalkey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  TextEditingController _tNome = new TextEditingController(text: "");
  TextEditingController _tData = new TextEditingController(text: "");
  TextEditingController _tSexo = new TextEditingController(text: "");
  TextEditingController _tCivil = new TextEditingController(text: "");
  TextEditingController _tLocalizacao = new TextEditingController(text: "");
  TextEditingController _tDescricao = new TextEditingController(text: "");

  TextEditingController _tMusicas = new TextEditingController(text: "");
  TextEditingController _tEventos = new TextEditingController(text: "");
  TextEditingController _tComidas = new TextEditingController(text: "");
  TextEditingController _tBebidas = new TextEditingController(text: "");

  List<Map<String, dynamic>> lstCivil = [];
  List<Map<String, dynamic>> lstSexo = [];

  _getUser() async {
    final response = await http.post(
      Uri.parse('${global.baseUrl}/APILogin/getUser'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': global.Token,
      },
      body: jsonEncode(
        <String, String>{
          'Email': '${global.logUser['email']}',
        },
      ),
    );
    final resp = jsonDecode(response.body);
    if (resp['status'] == '200') {
      final data = resp['data'];
      // inspect(data);
      return data;
    }
    final data = [];
    return data;
  }

  _getLista(nLista) async {
    final response = await http.post(
      Uri.parse('${global.baseUrl}/APIListas/$nLista'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': global.Token,
      },
      body: jsonEncode(
        <String, String>{
          'Email': '${global.logUser['email']}',
        },
      ),
    );
    final resp = jsonDecode(response.body);
    if (resp['status'] == '200') {
      final data = resp['data'];
      // inspect(data);
      return data;
    }
    final data = [];
    return data;
  }

  _getDados() async {
    List products = await _getUser();
    List lSexo = await _getLista('lstSexo');

    List lCivil = await _getLista('lstEstadoCivil');

    final ImagePicker _picker = ImagePicker();

    lSexo.forEach((item) {
      lstSexo.add({
        'value': item["ID"],
        'label': item["Descricao"],
        'textStyle': TextStyle(color: Color(0xfff7892b)),
      });
    });
    lCivil.forEach((item) {
      lstCivil.add({
        'value': item["ID"],
        'label': item["Descricao"],
        'textStyle': TextStyle(color: Color(0xfff7892b)),
      });
    });
    final product = products[0];

    _tNome.text = product["Nome"];
    _tData.text = product["DataDesc"] ?? "";
    _tSexo.text = product["Sexo"] ?? "";
    _tCivil.text = product["EstadoCivil"] ?? "";
    _tLocalizacao.text = product["Localizacao"] ?? "";
    _tDescricao.text = product["Descricao"] ?? "";

    _tMusicas.text = product["TagMusica"] ?? "";
    _tEventos.text = product["TagEvento"] ?? "";
    _tComidas.text = product["TagComida"] ?? "";
    _tBebidas.text = product["TagBebida"] ?? "";

    setState(() {
      _tSexo.text = product["Sexo"] ?? "";
      _tCivil.text = product["EstadoCivil"] ?? "";
    });
  }

  _updPerfil(context) async {
    print("_updPerfil");
    if (upPerfil == null) {
      final response = await http.post(
        Uri.parse(global.baseUrl + 'APILogin/updLogin'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': global.Token,
        },
        body: jsonEncode(
          <String, String>{
            'Cod': global.logUser['cod'].toString(),
            'Nome': _tNome.text,
            'Data': _tData.text,
            'Sexo': _tSexo.text,
            'EstadoCivil': _tCivil.text,
            'Localizacao': _tLocalizacao.text,
            'Descricao': _tDescricao.text,
            'TagMusica': _tMusicas.text,
            'TagEvento': _tEventos.text,
            'TagComida': _tComidas.text,
            'TagBebida': _tBebidas.text,
          },
        ),
      );
      final resp = jsonDecode(response.body);
      inspect(resp);
      if (resp['status'] == '200') {
        print("Sucesso");

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
                  content: Text("!! Erro ao enviar dados !!!"),
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
    } else {
      print("_updImgPerfil");
      var postUri = Uri.parse(global.baseUrl + 'APILogin/updImgLogin');
      var request = http.MultipartRequest("POST", postUri);
      request.headers.addAll({
        'Accept': '*/*',
        'Authorization': global.Token,
      });
      var FileNome =
          "${global.logUser['cod']}.${upPerfil!.path.split(".").last}";

      var multipartFile = await http.MultipartFile.fromPath(
        "upPerfil",
        upPerfil!.path,
        filename: FileNome,
      );
      request.files.add(multipartFile);

      final response = await request.send();

      final responseImg = await http.post(
        Uri.parse(global.baseUrl + 'APILogin/updLogin'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': global.Token,
        },
        body: jsonEncode(
          <String, String>{
            'Cod': global.logUser['cod'].toString(),
            'Nome': _tNome.text,
            'Data': _tData.text,
            'Sexo': _tSexo.text,
            'EstadoCivil': _tCivil.text,
            'Localizacao': _tLocalizacao.text,
            'Descricao': _tDescricao.text,
            'TagMusica': _tMusicas.text,
            'TagEvento': _tEventos.text,
            'TagComida': _tComidas.text,
            'TagBebida': _tBebidas.text,
            'imgpessoa': FileNome,
          },
        ),
      );
      final resp = jsonDecode(responseImg.body);
      inspect(resp);
      if (resp['status'] == '200') {
        print("Sucesso");

        global.logUser['nome'] = _tNome.text;
        global.logUser['img'] = FileNome;

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
                  content: Text("!! Erro ao enviar dados !!!"),
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
  }

  Widget _labelText(txtLabel) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: txtLabel,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
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
        style: TextStyle(
          fontSize: 18,
          color: Color(0xfff7892b),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getDados();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Perfil"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Widget>(
            future: _buildCard(context),
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

  Future<Widget> _buildCard(context) async {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: MediaQuery.of(context).size.height, height: 10.0),
            Stack(
              children: <Widget>[
                Container(
                  // color: Color(0xFF009d7c),
                  width: MediaQuery.of(context).size.width,
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 10),
                        IntrinsicHeight(
                          child: imageProfile(context),
                        ),
                        SizedBox(height: 10),
                        IntrinsicHeight(
                          child: _cardPerfil(context),
                        ),
                        SizedBox(height: 10),
                        IntrinsicHeight(
                          child: _cardPreferencias(context),
                        ),
                        SizedBox(height: 10),
                        /******************/
                        ElevatedButton(
                          onPressed: () {
                            // print("click");
                            _updPerfil(context);

                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => DashBoard()),
                            // );
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Salvar",
                              style: GoogleFonts.sourceSansPro(
                                textStyle:
                                    Theme.of(context).textTheme.headline1,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF009d7c),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 30) // Background color
                              ),
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

  imageProfile(context) {
    return Center(
      child: Stack(children: <Widget>[
        Container(
          height: 200,
          // width: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: (imgPerfil == null)
                  ? NetworkImage(
                      '${global.baseUrl}resources/img/Perfil/${global.logUser['img']}')
                  : imgPerfil!.image,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // backgroundImage: (_imageFile == null)
        //     ? FileImage(File(
        //         '${global.baseUrl}resources/img/Perfil/${global.logUser['img']}'))
        //     : imgPerfil,

        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet(context)),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  bottomSheet(context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Escolha a foto do perfil",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    size: 24.0,
                  ),
                  label: Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.folder,
                    size: 24.0,
                  ),
                  label: Text('Galeria'),
                ),
              ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );

    // print(Image.file(File(pickedFile!.path)).image);

    if (pickedFile != null) {
      upPerfil = new File(pickedFile!.path);
      setState(() {
        imgPerfil = Image.file(File(pickedFile.path));
      });
    }
  }

  _cardPerfil(context) {
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          color: Color(0xFF009d7c),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(FontAwesomeIcons.user, color: Colors.white),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.77,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //email
              _labelText("E-mail"),
              _fieldText(global.logUser['email']),
              //Nome
              SizedBox(height: 5),
              TextFormField(
                  controller: _tNome,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo Obrigatório';
                    }
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Nome",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xfff7892b),
                    ),
                    fillColor: Color(0xfff3f3f4),
                  )),
              // Data Nascimento
              SizedBox(height: 5),
              TextFormField(
                  controller: _tData,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo Obrigatório';
                    }
                  },
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: "Nascido em",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xfff7892b),
                    ),
                    fillColor: Color(0xfff3f3f4),
                  )),
              // Sexo
              SizedBox(height: 5),
              SelectFormField(
                labelText: 'Sexo',
                items: lstSexo,
                controller: _tSexo,
                decoration: InputDecoration(
                  labelText: "Sexo",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xfff7892b),
                  ),
                  fillColor: Color(0xfff3f3f4),
                  focusColor: Color(0xfff7892b),
                ),
              ),
              //EstadoCivil
              SizedBox(height: 5),
              SelectFormField(
                labelText: 'Estado Civil',
                items: lstCivil,
                controller: _tSexo,
                decoration: InputDecoration(
                  labelText: "Estado Civil",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xfff7892b),
                  ),
                  fillColor: Color(0xfff3f3f4),
                  focusColor: Color(0xfff7892b),
                ),
              ),
              //Localização
              SizedBox(height: 5),
              TextFormField(
                  controller: _tLocalizacao,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo Obrigatório';
                    }
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Localização",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xfff7892b),
                    ),
                    fillColor: Color(0xfff3f3f4),
                  )),
              //Descricao
              SizedBox(height: 5),
              TextFormField(
                  controller: _tDescricao,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo Obrigatório';
                    }
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "O que gosta de fazer?",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xfff7892b),
                    ),
                    fillColor: Color(0xfff3f3f4),
                  )),
              SizedBox(height: 5),
            ],
          ),
        ),
      ],
    );
  }

  _cardPreferencias(context) {
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          color: Color.fromARGB(255, 52, 125, 219),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(FontAwesomeIcons.heart, color: Colors.white),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.77,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5),
              TextFormField(
                  controller: _tMusicas,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Tipos de Músicas",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xfff7892b),
                    ),
                    fillColor: Color(0xfff3f3f4),
                  )),
              SizedBox(height: 5),
              TextFormField(
                  controller: _tEventos,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: "Tipos de Eventos",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xfff7892b),
                    ),
                    fillColor: Color(0xfff3f3f4),
                  )),
              SizedBox(height: 5),
              TextFormField(
                  controller: _tComidas,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Tipos de Comidas",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xfff7892b),
                    ),
                    fillColor: Color(0xfff3f3f4),
                  )),
              SizedBox(height: 5),
              TextFormField(
                  controller: _tBebidas,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Tipos de Bebidas",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xfff7892b),
                    ),
                    fillColor: Color(0xfff3f3f4),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
