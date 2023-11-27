function bntUserLogin() {
    $("#UserLogin").attr("disabled", true);
    var valido = true;

    if ($("#txtLogin").val().trim() == '') {
        $("#txtLogin").addClass("is-invalid");
        valido = false;
    }
    if ($("#txtPass").val().trim() == '') {
        $("#txtPass").addClass("is-invalid");
        valido = false;
    }

    if (valido == true) {


        dados = $.getJSON('https://api.bigdatacloud.net/data/reverse-geocode-client', function (data) {
            console.log(data);
            var cData = {
                Email: $("#txtLogin").val().trim(),
                Senha: $("#txtPass").val().trim(),
                IP: data.ip,
                country_code: data.countryCode,
                district: data.locality,
                isp: data.latitude + "  " + data.longitude
            }
            console.log(cData);

            $.ajax({
                url: urlSistema + "/Login/login",
                type: "POST",
                data: cData,
                error: function (error) {
                    console.log("error");
                    console.log(error);
                    msgToastr("Ocorreu um erro ao realizar login. er[1001]");
                },
                success: function (result) {
                    console.log("success");
                    console.log(result);
                    switch (result) {
                        case "ErroLogin":
                            msgToastr("Login / Senha Invalido.");
                            break;
                        case "success":
                            window.location.href = "dashboard";
                            break;
                        default:
                            msgToastr("Ocorreu um erro ao realizar login. er[1002]");
                    }
                },
            });
        });
    }
    $("#UserLogin").attr("disabled", false);
}

function bntUserAdd() {
    $("#UserAdd").attr("disabled", true);
    var valido = true;

    if ($("#selEmail").val().trim() == '' || !(validateEmail($("#selEmail").val().trim()))) {
        $("#selEmail").addClass("is-invalid");
        valido = false;
    }
    if ($("#selNome").val().trim() == '') {
        $("#selNome").addClass("is-invalid");
        valido = false;
    }

    let r = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[$*&@#])(?:([0-9a-zA-Z$*&@#])(?!\1)){8,}$/;
    if ($("#selSenha").val().trim() == '' || r.test($("#selSenha").val().trim()) == false) {
        $("#selSenha").addClass("is-invalid");
        msgToastr("Senha precisa conter:<br>8 caracteres no mínimo<br>1 Letra Maiúscula no mínimo<br>1 Número no mínimo<br>1 Símbolo no mínimo.");
        valido = false;
    }
    if ($("#terms").is(':checked') != true) {
        $("#terms").addClass("is-invalid");
        msgToastr("Necessário aceitar o Termos de Serviço para continuar.");
        valido = false;
    }
    if (valido == true) {

        // const data = $(form).serialize();

        vEmail = $("#selEmail").val().trim();

        dados = $.getJSON('https://api.bigdatacloud.net/data/reverse-geocode-client', function (data) {
            var cData = {
                Email: vEmail,
                Senha: $("#selSenha").val().trim(),
                Nome: $("#selNome").val().trim(),
                IP: data.ip,
                country_code: data.countryCode,
                district: data.locality,
                isp: data.latitude + "  " + data.longitude
            }
            // console.log(cData);

            $.ajax({
                url: urlSistema + "/Login/existelogin",
                type: "POST",
                data: cData,
                error: function (error) {
                    console.log(error);
                    msgToastr("Ocorreu um erro ao cadastrar o login. er[1003].");
                },
                success: function (result) {
                    console.log(result);
                    switch (result) {
                        case "ErroLogin":
                            msgToastr("Email já cadastrado.");
                            break;
                        case "success":
                            $.ajax({
                                url: urlSistema + "/Login/cadastralogin",
                                type: "POST",
                                data: cData,
                                error: function (error) {
                                    console.log(error);
                                    msgToastr("Ocorreu um erro ao cadastrar o login. er[1003].");
                                },
                                success: function (result) {
                                    Toast = Swal.mixin({
                                        toast: true,
                                        position: 'top-end',
                                        showConfirmButton: false,
                                        timer: 3000
                                    });
                                    toastr.success("Email Cadastrado");

                                    eData = {
                                        Email: vEmail,
                                        Senha: $("#selSenha").val().trim(),
                                        Nome: $("#selNome").val().trim(),
                                    }
                                    $.ajax({
                                        url: urlSistema + "/TextoEmail/CadastroLogin",
                                        type: "POST",
                                        data: eData,
                                        error: function (error) {
                                            console.log("Login_Email_error");
                                            console.log(error);
                                            msgToastr("Ocorreu um erro ao Enviar o email. er[1005].");
                                        },
                                        success: function (result) {
                                            console.log("Login_Email_result");
                                            console.log(result);
                                        }
                                    });

                                    window.location.href = "dashboard";
                                }
                            });
                            break;
                        default:
                            msgToastr("Ocorreu um erro ao cadastrar o login. er[1004].");
                    }
                }
            });
        });
    }
    $("#UserAdd").attr("disabled", false);
}

function CadastraFB() {
    dados = $.getJSON('https://api.bigdatacloud.net/data/reverse-geocode-client', function (data) {
        dataIP = data.ip;
        datacountry_code = data.countryCode;
        datadistrict = data.locality;
        dataisp = data.latitude + "  " + data.longitude;

    });
    FB.getLoginStatus(function (response) {
        var Ativo = 0;
        // console.log("response.status");
        // console.log(response.status);
        if (response.status === 'connected') {
            // O usuário já está conectado, você pode executar ações relacionadas aqui.
            console.log('Usuário já está conectado.');
            Ativo = 1;
        } else {
            FB.login(function (response) {
                if (response.authResponse) {
                    Ativo = 1;
                } else {
                    console.log('Usuário cancelou o login ou não autorizou totalmente o acesso.');
                }
            }, { scope: 'email' });
            console.log('Usuário cancelou o login ou não autorizou totalmente o acesso.');
        }

        if (Ativo == 1) {
            var dados = new FormData();
            FB.api('/me', { locale: 'en_US', fields: 'name, email, picture' },
                function (response) {
                    // console.log("response");
                    // console.log(response);
                    dados.append('ID', response.id);
                    dados.append('Nome', response.name);
                    dados.append('Email', response.email);
                    dados.append('IP', dataIP);
                    dados.append('country_code', datacountry_code);
                    dados.append('district', datadistrict);
                    dados.append('isp', dataisp);
                    console.log("dados");
                    console.log(response.email);
                    var cData = {
                        Email: response.email,
                    }
                    // console.log("cData");
                    // console.log(cData);
                    $.ajax({
                        url: urlSistema + "Login/existelogin",
                        type: "POST",
                        data: cData,
                        error: function (error) {
                            console.log(error);
                            msgToastr("Ocorreu um erro ao cadastrar o login. er[1003].");
                        },
                        success: function (result) {
                            console.log(result);
                            switch (result) {
                                case "ErroLogin":
                                    msgToastr("Email já cadastrado.");
                                    break;
                                case "success":
                                    $.ajax({
                                        url: urlSistema + "Login/cadastraFB",
                                        type: "POST",
                                        data: dados,
                                        cache: false,
                                        contentType: false,
                                        processData: false,
                                        error: function (error) {
                                            console.log("error1");
                                            console.log(error);
                                            msgToastr("Ocorreu um erro ao realizar login. er[2001]");
                                        },
                                        success: function (result) {
                                            console.log("result1");
                                            console.log(result);
                                            switch (result) {
                                                case "ErroLogin":
                                                    msgToastr("Usuário não cadastrado.");
                                                    break;
                                                case "success":
                                                    // msgToastr("OK");
                                                    window.location.href = "dashboard";
                                                    break;
                                                case "ExisteUser":
                                                    msgToastr("E-mail já cadastrado.");
                                                    //window.location.href = "dashboard";
                                                    break;
                                                default:
                                                    msgToastr("Ocorreu um erro ao realizar login. er[2002]");
                                            }
                                        },
                                    });

                                    break;
                                default:
                                    msgToastr("Ocorreu um erro ao cadastrar o login. er[1004].");
                            }
                        }
                    });
                }
            );
        }
    });
}

function loginFB() {
    dados = $.getJSON('https://api.bigdatacloud.net/data/reverse-geocode-client', function (data) {
        dataIP = data.ip;
        datacountry_code = data.countryCode;
        datadistrict = data.locality;
        dataisp = data.latitude + "  " + data.longitude;

    });
    FB.login(function (response) {
        if (response.authResponse) {
            var dados = new FormData();
            FB.api('/me', { locale: 'en_US', fields: 'name, email' },
                function (response) {
                    // console.log("response");
                    // console.log(response);

                    dados.append('ID', response.id);
                    dados.append('Nome', response.name);
                    dados.append('Email', response.email);
                    dados.append('IP', dataIP);
                    dados.append('country_code', datacountry_code);
                    dados.append('district', datadistrict);
                    dados.append('isp', dataisp);

                    // console.log("dados");
                    // console.log(dados);
                    $.ajax({
                        url: urlSistema + "Login/loginFB",
                        type: "POST",
                        data: dados,
                        cache: false,
                        contentType: false,
                        processData: false,
                        error: function (error) {
                            console.log("error");
                            console.log(error);
                            msgToastr("Ocorreu um erro ao realizar login. er[1001]");
                        },
                        success: function (result) {
                            console.log("success");
                            console.log(result);
                            switch (result) {
                                case "ErroLogin":
                                    msgToastr("Usuário não cadastrado.");
                                    break;
                                case "success":
                                    // msgToastr("OK");
                                    window.location.href = "dashboard";
                                    break;
                                default:
                                    msgToastr("Ocorreu um erro ao realizar login. er[1002]");
                            }
                        },
                    });
                }
            );
        } else {
            console.log('Usuário cancelou o login ou não autorizou totalmente o acesso.');
        }
    });
};

function CadastraIG() {
    msgToastr("Sistema sem credenciais para Instagram. er[1014].");

    // dados = $.getJSON('https://api.bigdatacloud.net/data/reverse-geocode-client', function (data) {
    //     dataIP = data.ip;
    //     datacountry_code = data.countryCode;
    //     datadistrict = data.locality;
    //     dataisp = data.latitude + "  " + data.longitude;

    // });
    // FB.getLoginStatus(function (response) {
    //     var Ativo = 0;
    //     // console.log("response.status");
    //     // console.log(response.status);
    //     if (response.status === 'connected') {
    //         // O usuário já está conectado, você pode executar ações relacionadas aqui.
    //         console.log('Usuário já está conectado.');
    //         Ativo = 1;
    //     } else {
    //         FB.login(function (response) {
    //             if (response.authResponse) {
    //                 Ativo = 1;
    //             } else {
    //                 console.log('Usuário cancelou o login ou não autorizou totalmente o acesso.');
    //             }
    //         }, { scope: 'email' });
    //         console.log('Usuário cancelou o login ou não autorizou totalmente o acesso.');
    //     }

    //     if (Ativo == 1) {
    //         var dados = new FormData();
    //         FB.api('/me', { locale: 'en_US', fields: 'name, email, picture' },
    //             function (response) {
    //                 // console.log("response");
    //                 // console.log(response);
    //                 dados.append('ID', response.id);
    //                 dados.append('Nome', response.name);
    //                 dados.append('Email', response.email);
    //                 dados.append('IP', dataIP);
    //                 dados.append('country_code', datacountry_code);
    //                 dados.append('district', datadistrict);
    //                 dados.append('isp', dataisp);
    //                 console.log("dados");
    //                 console.log(response.email);
    //                 var cData = {
    //                     Email: response.email,
    //                 }
    //                 // console.log("cData");
    //                 // console.log(cData);
    //                 $.ajax({
    //                     url: urlSistema + "Login/existelogin",
    //                     type: "POST",
    //                     data: cData,
    //                     error: function (error) {
    //                         console.log(error);
    //                         msgToastr("Ocorreu um erro ao cadastrar o login. er[1003].");
    //                     },
    //                     success: function (result) {
    //                         console.log(result);
    //                         switch (result) {
    //                             case "ErroLogin":
    //                                 msgToastr("Email já cadastrado.");
    //                                 break;
    //                             case "success":
    //                                 $.ajax({
    //                                     url: urlSistema + "Login/cadastraFB",
    //                                     type: "POST",
    //                                     data: dados,
    //                                     cache: false,
    //                                     contentType: false,
    //                                     processData: false,
    //                                     error: function (error) {
    //                                         console.log("error1");
    //                                         console.log(error);
    //                                         msgToastr("Ocorreu um erro ao realizar login. er[2001]");
    //                                     },
    //                                     success: function (result) {
    //                                         console.log("result1");
    //                                         console.log(result);
    //                                         switch (result) {
    //                                             case "ErroLogin":
    //                                                 msgToastr("Usuário não cadastrado.");
    //                                                 break;
    //                                             case "success":
    //                                                 // msgToastr("OK");
    //                                                 window.location.href = "dashboard";
    //                                                 break;
    //                                             case "ExisteUser":
    //                                                 msgToastr("E-mail já cadastrado.");
    //                                                 //window.location.href = "dashboard";
    //                                                 break;
    //                                             default:
    //                                                 msgToastr("Ocorreu um erro ao realizar login. er[2002]");
    //                                         }
    //                                     },
    //                                 });

    //                                 break;
    //                             default:
    //                                 msgToastr("Ocorreu um erro ao cadastrar o login. er[1004].");
    //                         }
    //                     }
    //                 });
    //             }
    //         );
    //     }
    // });
}

function loginIG() {
    msgToastr("Sistema sem credenciais para Instagram. er[1015].");
    // dados = $.getJSON('https://api.bigdatacloud.net/data/reverse-geocode-client', function (data) {
    //     dataIP = data.ip;
    //     datacountry_code = data.countryCode;
    //     datadistrict = data.locality;
    //     dataisp = data.latitude + "  " + data.longitude;

    // });
    // FB.login(function (response) {
    //     if (response.authResponse) {
    //         var dados = new FormData();
    //         FB.api('/me', { locale: 'en_US', fields: 'name, email' },
    //             function (response) {
    //                 // console.log("response");
    //                 // console.log(response);

    //                 dados.append('ID', response.id);
    //                 dados.append('Nome', response.name);
    //                 dados.append('Email', response.email);
    //                 dados.append('IP', dataIP);
    //                 dados.append('country_code', datacountry_code);
    //                 dados.append('district', datadistrict);
    //                 dados.append('isp', dataisp);

    //                 // console.log("dados");
    //                 // console.log(dados);
    //                 $.ajax({
    //                     url: urlSistema + "Login/loginFB",
    //                     type: "POST",
    //                     data: dados,
    //                     cache: false,
    //                     contentType: false,
    //                     processData: false,
    //                     error: function (error) {
    //                         console.log("error");
    //                         console.log(error);
    //                         msgToastr("Ocorreu um erro ao realizar login. er[1001]");
    //                     },
    //                     success: function (result) {
    //                         console.log("success");
    //                         console.log(result);
    //                         switch (result) {
    //                             case "ErroLogin":
    //                                 msgToastr("Usuário não cadastrado.");
    //                                 break;
    //                             case "success":
    //                                 // msgToastr("OK");
    //                                 window.location.href = "dashboard";
    //                                 break;
    //                             default:
    //                                 msgToastr("Ocorreu um erro ao realizar login. er[1002]");
    //                         }
    //                     },
    //                 });
    //             }
    //         );
    //     } else {
    //         console.log('Usuário cancelou o login ou não autorizou totalmente o acesso.');
    //     }
    // });
};

$('#selEmail').onchange(function () {
    alert("OK");
});

$('.select-lang').click(function () {

    let idioma = $(this).data("lang");
    let url = urlSistema + '/lang/' + idioma;
    console.log(idioma);

    $.ajax({
        url: url,
        type: 'get',
        success: function (result) {
            if (result == "sucesso") {
                location.reload();
            }
        }
    });
});

function msgToastr(msgDesc) {
    var Toast = Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000
    });
    toastr.error(msgDesc)
};

function validateEmail(email) {
    // var re = /\S+@\S+\.\S+/;
    // return re.test(email);
    return email.match(
        /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    );
}