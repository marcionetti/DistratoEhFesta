<!-- css -->
<link rel="stylesheet" href="<?= base_url() ?>/resources/css/Convite/style.css?v=<?= getenv('Version') ?>">
<link rel="stylesheet"
    href="<?= base_url() ?>/plugins/sweetalert2-theme-bootstrap-4/bootstrap-4.min.css?v=<?= getenv('Version') ?>">
<link rel="stylesheet" href="<?= base_url() ?>/plugins/toastr/toastr.min.css?v=<?= getenv('Version') ?>">
<!-- js -->
<script src="<?= base_url() ?>/plugins/jquery/jquery.min.js?v=<?= getenv('Version') ?>"></script>
<script src="<?= base_url() ?>/plugins/jquery-ui/jquery-ui.min.js?v=<?= getenv('Version') ?>"></script>
<script src="<?= base_url() ?>/plugins/bootstrap/js/bootstrap.min.js?v=<?= getenv('Version') ?>"></script>
<script src="<?= base_url() ?>/plugins/bootstrap/js/bootstrap.bundle.min.js?v=<?= getenv('Version') ?>"></script>
<script src="<?= base_url() ?>/plugins/sweetalert2/sweetalert2.min.js?v=<?= getenv('Version') ?>"></script>
<script src="<?= base_url() ?>/plugins/toastr/toastr.min.js?v=<?= getenv('Version') ?>"></script>
<script
    src="<?= base_url() ?>/plugins/bs-custom-file-input/bs-custom-file-input.min.js?v=<?= getenv('Version') ?>"></script>
<script src="<?= base_url() ?>/resources/js/Clientes/index.js?v0.2"></script>

<!-- Body -->
<div class="card-body">
    <div id="example2_wrapper" class="dataTables_wrapper dt-bootstrap4">
        <div class="row">
            <div class="col-sm-12 col-md-6"></div>
            <div class="col-sm-12 col-md-6"></div>
        </div>
        <div class="row">
            <div class="col-sm-12">
                <table id="example2" class="table table-bordered table-hover dataTable dtr-inline"
                    aria-describedby="example2_info">
                    <thead>
                        <tr>
                            <th></th>
                            <th class="sorting sorting_asc" tabindex="0" aria-controls="example2" rowspan="1"
                                colspan="1" aria-sort="ascending"
                                aria-label="ID: activate to sort column descending">ID</th>
                            <th class="sorting" tabindex="0" aria-controls="example2" rowspan="1" colspan="1"
                                aria-label="Nome: activate to sort column ascending">Nome</th>
                            <th class="sorting" tabindex="0" aria-controls="example2" rowspan="1" colspan="1"
                                aria-label="Email: activate to sort column ascending">Email</th>
                            <th class="sorting" tabindex="0" aria-controls="example2" rowspan="1" colspan="1"
                                aria-label="Tipo: activate to sort column ascending">Tipo</th>
                            <th class="sorting" tabindex="0" aria-controls="example2" rowspan="1" colspan="1"
                                aria-label="Criado: activate to sort column ascending">Criado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php echo $tblCliente; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>