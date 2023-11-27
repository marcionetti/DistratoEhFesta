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

class ConviteNovo extends StatefulWidget {
  const ConviteNovo({Key? key}) : super(key: key);

  _ConviteNovoState createState() => _ConviteNovoState();
}

class _ConviteNovoState extends State<ConviteNovo> {
  XFile? _imageFile;

  Image? imgPerfil;
  File? upPerfil;

  final _globalkey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  TextEditingController _tEvento = new TextEditingController(text: "");
  TextEditingController _tDescricao = new TextEditingController(text: "");
  TextEditingController _tData = new TextEditingController(text: "");
  TextEditingController _tInicio = new TextEditingController(text: "");
  TextEditingController _tFim = new TextEditingController(text: "");

  TextEditingController _tOcasiao = new TextEditingController(text: "");
  TextEditingController _tPublico = new TextEditingController(text: "");
  TextEditingController _tPresente = new TextEditingController(text: "");
  TextEditingController _tIndividual = new TextEditingController(text: "");
  TextEditingController _tCompartilhar = new TextEditingController(text: "");
  TextEditingController _tConvidados = new TextEditingController(text: "");
  TextEditingController _tRecados = new TextEditingController(text: "");

  TextEditingController _tObs = new TextEditingController(text: "");

  TextEditingController _tEndereco = new TextEditingController(text: "");

  List<Map<String, dynamic>> lstTipo = [];
  List<Map<String, dynamic>> lstPublico = [];
  List<Map<String, dynamic>> lstSimNao = [];

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
    List lTipo = await _getLista('lstTipoEvento');
    List lPublico = await _getLista('lstTipoPublico');
    final ImagePicker _picker = ImagePicker();

    lTipo.forEach((item) {
      lstTipo.add({
        'value': item["ID"],
        'label': item["Descricao"],
        'textStyle': TextStyle(color: Color(0xfff7892b)),
      });
    });
    lPublico.forEach((item) {
      lstPublico.add({
        'value': item["ID"],
        'label': item["Descricao"],
        'textStyle': TextStyle(color: Color(0xfff7892b)),
      });
    });

    lstSimNao.add(
      {
        'value': 0,
        'label': "Não",
        'textStyle': TextStyle(color: Color(0xfff7892b)),
      },
    );
    lstSimNao.add(
      {
        'value': 1,
        'label': "Sim",
        'textStyle': TextStyle(color: Color(0xfff7892b)),
      },
    );
  }

  _addConvite(context) async {
    print("_addConvite");
    if (upPerfil == null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: new Text("Confirmação"),
                content: Text("!! Imagem do Convite obrigatória !!!"),
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
      print("Aqui");
      final response = await http.post(
        Uri.parse(global.baseUrl + 'APIConvites/addConvite'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': global.Token,
        },
        body: jsonEncode(
          <String, String>{
            'cadUserID': global.logUser['cod'].toString(),
            'Titulo': _tEvento.text,
            'Descricao': _tDescricao.text,
            'DataEvento': _tData.text,
            'HoraInicio': _tInicio.text,
            'HoraFim': _tFim.text,
            'TipoEventoID': _tOcasiao.text,
            'TipoPublicoID': _tPublico.text,
            'Convidar': _tIndividual.text,
            'Compartilhar': _tCompartilhar.text,
            'ListaConvidados': _tConvidados.text,
            'MuralRecado': _tRecados.text,
            'Endereco': _tEndereco.text,
            'Obs': _tObs.text,
          },
        ),
      );
      final resp = jsonDecode(response.body);
      print("resp");
      inspect(resp);
      if (resp['status'] == '200') {
        print("Sucesso");
        final CodConvite = resp['data'];
        print(CodConvite);
        print("_updImgEvento");
        var postUri = Uri.parse(global.baseUrl + 'APIConvites/updImgConvite');
        var request = http.MultipartRequest("POST", postUri);
        request.headers.addAll({
          'Accept': '*/*',
          'Authorization': global.Token,
        });
        var FileNome = CodConvite + ".${upPerfil!.path.split(".").last}";
        print(FileNome);
        var multipartFile = await http.MultipartFile.fromPath(
          "upConvite",
          upPerfil!.path,
          filename: FileNome,
        );
        request.files.add(multipartFile);

        final response = await request.send();
        inspect(response);
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
        style: GoogleFonts.sourceSansPro(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color.fromARGB(255, 83, 74, 66),
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
        title: Text("Convite"),
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
                          child: imageConvite(context),
                        ),
                        SizedBox(height: 10),
                        IntrinsicHeight(
                          child: _cardTitulo(context),
                        ),
                        SizedBox(height: 10),
                        IntrinsicHeight(
                          child: _cardTipo(context),
                        ),
                        SizedBox(height: 10),
                        IntrinsicHeight(
                          child: _cardObs(context),
                        ),
                        SizedBox(height: 10),
                        /******************/
                        // Localização
                        IntrinsicHeight(
                          child: _cardEndereco(context),
                        ),
                        SizedBox(height: 10),
                        /******************/
                        ElevatedButton(
                          onPressed: () {
                            _addConvite(context);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => DashBoard()),
                            // );
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Criar Convite",
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

  imageConvite(context) {
    return Center(
      child: Stack(children: <Widget>[
        Container(
          height: 200,
          // width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: (imgPerfil == null)
                  ? NetworkImage(
                      '${global.baseUrl}resources/img/Convite/noImage.gif')
                  : imgPerfil!.image,
              fit: BoxFit.contain,
            ),
          ),
        ),
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

    upPerfil = new File(pickedFile!.path);
    setState(() {
      imgPerfil = Image.file(File(pickedFile.path));
    });
  }

  _cardTitulo(context) {
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
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                  controller: _tEvento,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo Obrigatório';
                    }
                  },
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Color(0xfff7892b)),
                  decoration: InputDecoration(
                    labelText: "Evento",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xfff7892b),
                    ),
                  )),
              SizedBox(height: 5),
              TextFormField(
                  controller: _tDescricao,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo Obrigatório';
                    }
                  },
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Color(0xfff7892b)),
                  decoration: InputDecoration(
                    labelText: "Descrição",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xfff7892b),
                    ),
                    fillColor: Color(0xfff3f3f4),
                  )),
              SizedBox(height: 5),
              TextFormField(
                  controller: _tData,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo Obrigatório';
                    }
                  },
                  keyboardType: TextInputType.datetime,
                  style: TextStyle(color: Color(0xfff7892b)),
                  decoration: InputDecoration(
                    labelText: "Data",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xfff7892b),
                    ),
                    fillColor: Color(0xfff3f3f4),
                  )),
              SizedBox(height: 5),
              TextFormField(
                  controller: _tInicio,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo Obrigatório';
                    }
                  },
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Color(0xfff7892b)),
                  decoration: InputDecoration(
                    labelText: "Das",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xfff7892b),
                    ),
                    fillColor: Color(0xfff3f3f4),
                  )),
              SizedBox(height: 5),
              TextFormField(
                  controller: _tFim,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo Obrigatório';
                    }
                  },
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Color(0xfff7892b)),
                  decoration: InputDecoration(
                    labelText: "Até",
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

  _cardTipo(context) {
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
              SelectFormField(
                labelText: 'Tipo do Evento',
                items: lstTipo,
                controller: _tOcasiao,
                decoration: InputDecoration(
                  labelText: "Tipo do Evento",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xfff7892b),
                  ),
                  fillColor: Color(0xfff3f3f4),
                  focusColor: Color(0xfff7892b),
                ),
              ),
              SizedBox(height: 5),
              SelectFormField(
                labelText: 'Público',
                items: lstPublico,
                controller: _tPublico,
                decoration: InputDecoration(
                  labelText: "Público",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xfff7892b),
                  ),
                  fillColor: Color(0xfff3f3f4),
                  focusColor: Color(0xfff7892b),
                ),
              ),
              SizedBox(height: 5),
              SelectFormField(
                labelText: 'Individual',
                items: lstSimNao,
                controller: _tIndividual,
                decoration: InputDecoration(
                  labelText: "Individual",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xfff7892b),
                  ),
                  fillColor: Color(0xfff3f3f4),
                  focusColor: Color(0xfff7892b),
                ),
              ),
              SizedBox(height: 5),
              SelectFormField(
                labelText: 'Compartilhar',
                items: lstSimNao,
                controller: _tCompartilhar,
                decoration: InputDecoration(
                  labelText: "Compartilhar",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xfff7892b),
                  ),
                  fillColor: Color(0xfff3f3f4),
                  focusColor: Color(0xfff7892b),
                ),
              ),
              SizedBox(height: 5),
              SelectFormField(
                labelText: 'Lista Convidados',
                items: lstSimNao,
                controller: _tConvidados,
                decoration: InputDecoration(
                  labelText: "Lista Convidados",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xfff7892b),
                  ),
                  fillColor: Color(0xfff3f3f4),
                  focusColor: Color(0xfff7892b),
                ),
              ),
              SizedBox(height: 5),
              SelectFormField(
                labelText: 'Mural de Recados',
                items: lstSimNao,
                controller: _tRecados,
                decoration: InputDecoration(
                  labelText: "Mural de Recados",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xfff7892b),
                  ),
                  fillColor: Color(0xfff3f3f4),
                  focusColor: Color(0xfff7892b),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _cardObs(context) {
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
              TextFormField(
                  controller: _tObs,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo Obrigatório';
                    }
                  },
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Color(0xfff7892b)),
                  decoration: InputDecoration(
                    labelText: "Observação",
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

  _cardEndereco(context) {
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
                TextFormField(
                    controller: _tEndereco,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                    },
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Color(0xfff7892b)),
                    decoration: InputDecoration(
                      labelText: "Endereço",
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
        ),
      ],
    );
  }
}
