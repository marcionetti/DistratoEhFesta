<?php

namespace App\Controllers;

use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\HTTP\IncomingRequest;
use CodeIgniter\API\ResponseTrait;
use App\Models\modelCadUsers;
use App\Models\modelCadUsersVW;
use App\Controllers\Hash;


class APILogin extends ResourceController
{

    use ResponseTrait;

    public function show($id = null)
    {
        $request = service('request');
        
        if ($request->getServer('HTTP_AUTHORIZATION') == mob_token) {

            $model = new modelCadUsers();

            $data = $model->getWhere(['Email' => $id])->getResult();

            if ($data) {
                $data = [
                    'status' => '200',
                    'data' => $data,
                ];
                return $this->respond($data, 200);
            }

            return $this->failNotFound('Nenhum dado encontrado');
        }
        return $this->failUnauthorized('1 O cliente não está autorizado');
    }

    public function getUser()
    {
        $request = service('request');
        $bodyAPI = $this->request->getJSON();

        if ($request->getServer('HTTP_AUTHORIZATION') == mob_token) {

            $Email = $bodyAPI->Email;

            $model = new modelCadUsersVW();

            $data = $model->getWhere(['Email' => $Email])->getResult();

            if ($data) {
                $data = [
                    'status' => '200',
                    'data' => $data,
                ];
                return $this->respond($data, 200);
            }

            return $this->failNotFound('Nenhum dado encontrado');
        }
        return $this->failUnauthorized('2 O cliente não está autorizado');
    }

    public function addLogin()
    {

        // $this->CadComentarios = new modelCadComentarios();

        $this->cadUsers = new modelCadUsers();
        $this->hash = new Hash();

        $request = service('request');
        $bodyAPI = $this->request->getJSON();

        if ($request->getServer('HTTP_AUTHORIZATION') == mob_token) {

            $Status = '1';
            $Nome = $bodyAPI->Nome;
            $Email = $bodyAPI->Email;
            $Senha = $bodyAPI->Senha;
            $lnkFacebook = $bodyAPI->lnkFacebook;
            $hash = $Senha <> '' ? $this->hash->set($Senha) : '';
            $valid = true;
            $Cod = uniqid();
            // echo $hash;
            $dados1 = [
                "Email" => $Email,
                "Senha" => $hash,
                "Cod" => $Cod,
                "Nome" => $Nome,
                "Token" => $Cod,
                "lnkFacebook" => $lnkFacebook,
                "imgpessoa" => "avatar.jpg",
                "Criado" => date("Y-m-d H:i:s")
            ];

            $retorno = $this->cadUsers->insert($dados1);

            if ($retorno) {
                $model = new modelCadUsers();

                $data = $model->getWhere(['Email' => $Email])->getResult();
                $data = [
                    'status' => '200',
                    'data' => $data,
                ];
                return $this->respond($data, 200);
            }

            return $this->fail('Erro ao registrar usuário', 400);
        }
        return $this->failUnauthorized('3 O cliente não está autorizado');
    }

    public function updLogin()
    {
        $this->cadUsers = new modelCadUsers();
        $this->hash = new Hash();

        $request = service('request');
        $bodyAPI = $this->request->getJSON();

        if ($request->getServer('HTTP_AUTHORIZATION') == mob_token) {

            $Status = '1';
            $Cod = $bodyAPI->Cod;
            $Nome = $bodyAPI->Nome;
            $DataNasc = $bodyAPI->Data;
            $Sexo = $bodyAPI->Sexo;
            $EstadoCivil = $bodyAPI->EstadoCivil;
            $Localizacao = $bodyAPI->Localizacao;
            $Descricao = $bodyAPI->Descricao;
            $TagMusica = $bodyAPI->TagMusica;
            $TagEvento = $bodyAPI->TagEvento;
            $TagComida = $bodyAPI->TagComida;
            $TagBebida = $bodyAPI->TagBebida;
            // $imgExt = $bodyAPI->imgExt;


            $DataNasc = substr($DataNasc, -4) . "-" . substr($DataNasc, 3, 2) . "-" . substr($DataNasc, 0, 2);

            $data = [
                "Nome" => $Nome,
                "Data" => $DataNasc,
                "Sexo" => $Sexo,
                "EstadoCivil" => $EstadoCivil,
                "Localizacao" => $Localizacao,
                "Descricao" => $Descricao,
                "TagMusica" => $TagMusica,
                "TagEvento" => $TagEvento,
                "TagComida" => $TagComida,
                "TagBebida" => $TagBebida,

            ];


            $retorno = $this->cadUsers->updPerfil($Cod, $data);

            if ($retorno) {
                $data = [
                    'status' => '200',
                    'data' => $data,
                ];
                return $this->respond($data, 200);
            }

            return $this->fail('Erro ao registrar usuário', 400);
        }
        return $this->failUnauthorized('4 O cliente não está autorizado');
    }
    public function updImgLogin()
    {
        $request = service('request');
        $bodyAPI = $this->request->getJSON();

        if ($request->getServer('HTTP_AUTHORIZATION') == mob_token) {


            $upFiles = $_FILES['upPerfil']['tmp_name'];
            $upFilesName = $_FILES['upPerfil']['name'];
            $uploadfile = "resources/img/Perfil/$upFilesName";

            if (move_uploaded_file($_FILES['upPerfil']['tmp_name'], $uploadfile)) {
                $status = 'success';
            } else {
                $status = 'failure';
            }

            $data = [
                'status' => '200',
                'data' => $status,
            ];

            return $this->respond($data, 200);
        }
        return $this->failUnauthorized('5 O cliente não está autorizado');

    }
}
