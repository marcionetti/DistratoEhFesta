function updCliente(ID, Tipo) {
    dados = {
        'ID': ID,
        'Tipo': Tipo,
    };
    console.log(dados);

    $.ajax({
        url: urlSistema + "Cliente/updCliente",
        type: 'POST',
        data: dados,
        cache: false,
        success: function (result) {
            console.log(result);
            parent.msgtoast("success", "Cliente alterado");
            window.location.replace(
                urlSistema + `Cliente/MigraCLiente`
            );
        },
        error: function (result) {
            console.log("erro");
            console.log(result);
            parent.msgtoast("danger", result);
        }
    });
};