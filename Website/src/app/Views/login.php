<!DOCTYPE html>
<html lang="pt-br">

<head>
  <style>
    .alert {
      padding: 0 1.25rem !important;
    }
  </style>

  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Eh Festa</title>
  <link rel="shortcut icon" href="<?= base_url() ?>/resources/images/EhFesta.ico" type="image/x-icon">

  <!-- css -->
  <link rel="stylesheet"
    href="<?= base_url() ?>/resources/css/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
  <link rel="stylesheet"
    href="<?= base_url() ?>/resources/plugins/fontawesome-free/css/all.min.css?v=<?= getenv('Version') ?>">
  <link rel="stylesheet" href="<?= base_url() ?>/resources/css/icheck-bootstrap.min.css?v=<?= getenv('Version') ?>">
  <link rel="stylesheet" href="<?= base_url() ?>/resources/css/adminlte.min.css?v=<?= getenv('Version') ?>">
  <link rel="stylesheet"
    href="<?= base_url() ?>/plugins/sweetalert2-theme-bootstrap-4/bootstrap-4.min.css?v=<?= getenv('Version') ?>">
  <link rel="stylesheet" href="<?= base_url() ?>/plugins/toastr/toastr.min.css?v=<?= getenv('Version') ?>">
  <link rel="stylesheet" href="<?= base_url() ?>/resources/css/login/style.css?v=<?= getenv('Version') ?>">
  <!-- js -->
  <script> const urlSistema = '<?= base_url() ?>';</script>
  <script src="<?= base_url() ?>/resources/js/adminlte.min.js?v=<?= getenv('Version') ?>"></script>
  <script src="<?= base_url() ?>/plugins/jquery/jquery.min.js?v=<?= getenv('Version') ?>"></script>
  <script src="<?= base_url() ?>/plugins/jquery-ui/jquery-ui.min.js?v=<?= getenv('Version') ?>"></script>
  <script src="<?= base_url() ?>/plugins/bootstrap/js/bootstrap.min.js?v=<?= getenv('Version') ?>"></script>
  <script src="<?= base_url() ?>/plugins/bootstrap/js/bootstrap.bundle.min.js?v=<?= getenv('Version') ?>"></script>
  <script src="<?= base_url() ?>/plugins/sweetalert2/sweetalert2.min.js?v=<?= getenv('Version') ?>"></script>
  <script src="<?= base_url() ?>/plugins/toastr/toastr.min.js?v=<?= getenv('Version') ?>"></script>
  <script
    src="<?= base_url() ?>/plugins/bs-custom-file-input/bs-custom-file-input.min.js?v=<?= getenv('Version') ?>"></script>
  <script src="<?= base_url() ?>/resources/js/login/index.js?v0.2"></script>

  <script>
    window.fbAsyncInit = function () {
      FB.init({
        appId: '727941919181177',
        cookie: true,
        xfbml: true,
        version: 'v18.0'
      });

      FB.AppEvents.logPageView();

    };

    (function (d, s, id) {
      var js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) { return; }
      js = d.createElement(s); js.id = id;
      js.src = "https://connect.facebook.net/en_US/sdk.js";
      fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));
  </script>
</head>



<body class="text-center hold-transition login-page"
  style="background-image: url(<?= base_url() ?>/resources/images/ehfesta3.jpeg);background-size: 100% 100%;">

  <!-- Modal Usuario -->
  <div class="modal fade show" id="modalUsuario" style="display: none; padding-right: 17px;" aria-modal="true"
    role="dialog">
    <div class="modal-dialog
    ">
      <div class="modal-content col-12">
        <div class="modal-header">
          <h4 class="modal-title">Favor logar para continuar</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">×</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="card card-primary card-tabs">
            <div class="card-header col-12 p-0 pt-1">
              <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                <li class="nav-item" style="width: 224px;text-align: center;">
                  <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill"
                    href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home"
                    aria-selected="true">Entrar</a>
                </li>
                <li class="nav-item" style="width: 224px;text-align: center;">
                  <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill"
                    href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile"
                    aria-selected="false">Cadastrar</a>
                </li>
              </ul>
            </div>
            <div class="card-body">
              <div class="tab-content" id="custom-tabs-one-tabContent">
                <!-- Div Entrar -->
                <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel"
                  aria-labelledby="custom-tabs-one-home-tab">
                  <!-- <form action="<?php echo base_url('LoginController/signin') ?>" method="post"> -->
                  <form id="LoginForm" novalidate="novalidate">
                    <div class="input-group col-12 mb-3">
                      <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fas fa-at"></i></span>
                      </div>
                      <input type="text" name="txtLogin" id="txtLogin" class="form-control" required="required"
                        placeholder="E-mail">
                    </div>
                    <div class="input-group col-12 mb-3">
                      <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fas fa-key"></i></span>
                      </div>
                      <input type="password" name='txtPass' id='txtPass' class="form-control" placeholder="Senha">
                    </div>
                    <!-- <div class="row">
                      <div class="col-4 mb-3" style="margin: auto;">
                        <a href="forgot-password.html">Esqueci a senha</a>
                      </div>
                    </div> -->
                    <div class="row">
                      <!-- /.col -->
                      <div class="col-12">
                        <button type="button" id="UserLogin" onclick="bntUserLogin();"
                          class="btn btn-info btn-block">Entrar <i class="fas fa-sign-in-alt"></i></button>
                      </div>
                      <!-- /.col -->
                    </div>
                  </form>
                  <div class="social-auth-links text-center col-12 mt-2 mb-3">
                    <div class="row">
                      <div class="col-12 m-3" style="margin: auto;">
                        <a>ou entrar com</a>
                      </div>
                    </div>
                    <div class="row col-11" style="justify-content: space-between;margin: auto;" b>
                      <!-- <a class="btn btn-media col-5" style="background-color: #3B5998;"> -->
                      <a class="btn btn-media col-5" onclick="loginFB();" style="background-color: #3B5998;">
                        <span class="fab fa-facebook"></span> Facebook
                      </a>
                      <a class="btn btn-media col-5" onclick="loginIG();" style="background-color: #125688;">
                        <span class="fab fa-instagram"></span> Instagram
                      </a>
                    </div>
                  </div>
                </div>
                <!-- Div Cadastrar -->
                <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel"
                  aria-labelledby="custom-tabs-one-profile-tab">
                  <form id="CadForm" novalidate="novalidate">
                    <div class="card-body">
                      <div class="row" style="justify-content: space-between;margin: 5px;">
                        <div class="form-group col-12">
                          <label style="margin: 0px !important;">E-mail<i class="fas fa-asterisk"
                              style="font-size: 7px;color: red;vertical-align: text-top;"></i></label><br>
                          <input type="text" id="selEmail" name="selEmail" class="form-control" placeholder="Email ...">
                        </div>
                        <div class="form-group col-12">
                          <label style="margin: 0px !important;">Nome<i class="fas fa-asterisk"
                              style="font-size: 7px;color: red;vertical-align: text-top;"></i></label><br>
                          <input type="text" id="selNome" name="selNome" class="form-control" placeholder="Nome ...">
                        </div>
                      </div>
                      <div class="row" style="justify-content: space-between;margin: 5px;">
                        <div class="form-group col-12">
                          <label style="margin: 0px !important;">Senha<i class="fas fa-asterisk"
                              style="font-size: 7px;color: red;vertical-align: text-top;"></i></label><br>
                          <input type="password" id="selSenha" name="selSenha" class="form-control"
                            placeholder="Senha ...">
                        </div>
                      </div>

                      <div class="custom-control custom-checkbox col-12" style="margin: auto;margin-top: 15px;">
                        <input type="checkbox" name="terms" class="custom-control-input" id="terms"
                          aria-describedby="terms-error" aria-invalid="false">
                        <label class="custom-control-label" for="terms">Eu aceito os <a
                            href="<?= base_url() ?>/resources/terms/TermosUsuario.pdf" target="blank">Termos de
                            Serviço</a>.</label>
                      </div>
                    </div>

                    <div class="card-footer">
                      <button type="button" id="UserAdd" onclick="bntUserAdd();" class="btn btn-info btn-block"><i
                          class="fas fa-save"> Criar</i></button>
                    </div>
                  </form>
                  <div class="social-auth-links text-center col-12 mt-2 mb-3">
                    <div class="row">
                      <div class="col-12 m-3" style="margin: auto;">
                        <a>ou entrar com</a>
                      </div>
                    </div>
                    <div class="row col-11" style="justify-content: space-between;margin: auto;" b>
                      <!-- <a class="btn btn-media col-5" style="background-color: #3B5998;"> -->
                      <a class="btn btn-media col-5" onclick="CadastraFB();" style="background-color: #3B5998;">
                        <span class="fab fa-facebook"></span> Facebook
                      </a>
                      <a class="btn btn-media col-5" onclick="CadastraIG();" style="background-color: #125688;">
                        <span class="fab fa-instagram"></span> Instagram
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  </div>


  <div class="cover-container d-flex h-100 mx-auto flex-column" style="width: 100%;">
    <header class="masthead mb-auto">
      <div class="inner" style="background-color: #ffffff8f;height: 55px;">
        <h2 class="masthead-brand float-left pl-3 m-2"> EhFesta</h2>
        <!-- <nav class="nav nav-masthead justify-content-center">
          <a class="nav-link active" href="#">Home</a>
          <a class="nav-link" href="#">Features</a>
          <a class="nav-link" href="#">Contact</a>
          <a class="btn btn-block btn-info float-right" data-toggle="modal" data-target="#modalUsuario" style="width: 140px;">
          <i class="fas fa-user mr-2"></i> Entrar
        </a>
        </nav> -->
        <a class="btn btn-block btn-info float-right m-2" data-toggle="modal" data-target="#modalUsuario"
          style="width: 140px;">
          <i class="fas fa-user mr-2"></i> Entrar
        </a>
      </div>
    </header>
  </div>


</body>

</html>