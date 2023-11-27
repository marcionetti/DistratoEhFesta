<?php
namespace App\Controllers;

use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\API\ResponseTrait;
use App\Models\ModelCadConviteVW;
use App\Models\ModelCadConvite;


class APIConvites extends ResourceController
{
    use ResponseTrait;
    public function index()
    {
        $model = new ModelCadConviteVW();
        $data = $model->findAll();
        return $this->respond($data);
    }

    public function show($id = null)
    {
        $request = service('request');
        if ($request->getServer('HTTP_AUTHORIZATION') == mob_token) {

            $model = new ModelCadConviteVW();
            $data = $model->getWhere(['Cod' => $id])->getResult();

            if ($data) {
                $data = [
                    'status' => '200',
                    'data' => $data,
                ];
                return $this->respond($data, 200);
            }

            return $this->failNotFound('Nenhum dado encontrado');
        }
        return $this->failUnauthorized('O cliente não está autorizado');
    }
    public function addConvite()
    {
        $this->cadConvite = new ModelCadConvite();

        $request = service('request');
        $bodyAPI = $this->request->getJSON();

        if ($request->getServer('HTTP_AUTHORIZATION') == mob_token) {

            $dataAdd = date("Y-m-d H:i:s");

            $Data = $bodyAPI->DataEvento;
            $Data = substr($Data, -4) . "-" . substr($Data, 3, 2) . "-" . substr($Data, 0, 2);

            $dados = [
                "cadUserID" => $bodyAPI->cadUserID,
                "Titulo" => $bodyAPI->Titulo,
                "Status" => '1',
                "Descricao" => $bodyAPI->Descricao,
                "DataEvento" => $Data,
                "HoraInicio" => $bodyAPI->HoraInicio,
                "HoraFim" => $bodyAPI->HoraFim,
                "TipoEventoID" => $bodyAPI->TipoEventoID,
                "TipoPublicoID" => $bodyAPI->TipoPublicoID,
                // "PresenteVirtual" => $bodyAPI->PresenteVirtual,
                "Convidar" => $bodyAPI->Convidar,
                "Compartilhar" => $bodyAPI->Compartilhar,
                "ListaConvidados" => $bodyAPI->ListaConvidados,
                "MuralRecado" => $bodyAPI->MuralRecado,
                "Endereco" => $bodyAPI->Endereco,
                "Obs" => $bodyAPI->Obs,
                "DataCriacao" => $dataAdd,
            ];

            $IDConv = $this->cadConvite->addConvite($dados);
            if ($IDConv > '0') {
                $CodConv = strtoupper(bin2hex(random_bytes(2)) . $IDConv . bin2hex(random_bytes(2)));
                $dadosUp = [
                    "Cod" => $CodConv
                ];
                $updConvite = $this->cadConvite->updIdConvite($IDConv, $dadosUp);

                $data = [
                    'status' => '200',
                    'data' => $CodConv,
                ];
                return $this->respond($data, 200);
            }

            return $this->failNotFound('Nenhum dado encontrado');
        }
        return $this->failUnauthorized('O cliente não está autorizado');
    }
    public function updConvite()
    {
        $this->cadConvite = new ModelCadConvite();

        $request = service('request');
        $bodyAPI = $this->request->getJSON();

        if ($request->getServer('HTTP_AUTHORIZATION') == mob_token) {

            $dataAdd = date("Y-m-d H:i:s");

            $CodConv = $bodyAPI->CodConvite;

            $Data = $bodyAPI->DataEvento;
            $Data = substr($Data, -4) . "-" . substr($Data, 3, 2) . "-" . substr($Data, 0, 2);

            $dados = [
                "Titulo" => $bodyAPI->Titulo,
                "Status" => $bodyAPI->Status,
                "Descricao" => $bodyAPI->Descricao,
                "DataEvento" => $Data,
                "HoraInicio" => $bodyAPI->HoraInicio,
                "HoraFim" => $bodyAPI->HoraFim,
                "TipoEventoID" => $bodyAPI->TipoEventoID,
                "TipoPublicoID" => $bodyAPI->TipoPublicoID,
                // "PresenteVirtual" => $bodyAPI->PresenteVirtual,
                "Convidar" => $bodyAPI->Convidar,
                "Compartilhar" => $bodyAPI->Compartilhar,
                "ListaConvidados" => $bodyAPI->ListaConvidados,
                "MuralRecado" => $bodyAPI->MuralRecado,
                "Endereco" => $bodyAPI->Endereco,
                "Obs" => $bodyAPI->Obs,
                "DataUpdate" => $dataAdd,
            ];

            $updConvite = $this->cadConvite->updCodConvite($CodConv, $dados);

            if ($updConvite) {
                $data = [
                    'status' => '200',
                    'data' => $CodConv,
                ];
                return $this->respond($data, 200);
            }

            return $this->fail('Erro ao salvar alteração', 400);
        }
        return $this->failUnauthorized('O cliente não está autorizado');
    }
    public function PromoveConvite()
    {
        $this->cadConvite = new ModelCadConvite();

        $request = service('request');
        $bodyAPI = $this->request->getJSON();

        if ($request->getServer('HTTP_AUTHORIZATION') == mob_token) {

            $CodConv = $bodyAPI->CodConvite;

            $dados = [
                "Status" => '3',
            ];

            $updConvite = $this->cadConvite->updCodConvite($CodConv, $dados);

            if ($updConvite) {
                $data = [
                    'status' => '200',
                    'data' => $CodConv,
                ];
                return $this->respond($data, 200);
            }

            return $this->fail('Erro ao salvar alteração', 400);
        }
        return $this->failUnauthorized('O cliente não está autorizado');
    }



    public function updImgConvite()
    {
        $this->cadConvite = new ModelCadConvite();

        $request = service('request');

        if ($request->getServer('HTTP_AUTHORIZATION') == mob_token) {

            $img = $this->request->getFile('upConvite');

            $imgnameOri = $img->getName();
            $imgext = substr($imgnameOri, -4);
            $CodConv = (explode(".", $imgnameOri))[0];

            // $data = [
            //     'status' => '200',
            //     'imgnameOri'   => $imgnameOri,
            //     'imgext'   => $imgext,
            //     'CodConv'   => $CodConv,
            //     'img'   => $img,
            // ];
            // return $this->respond($data, 200);

            if ($imgnameOri) {

                $img->move('resources/img/Convite', $imgnameOri, true);

                $data = [
                    'status' => '200',
                    'data' => $imgnameOri,
                ];
                return $this->respond($data, 200);

            }

            return $this->fail('Erro ao salvar alteração da imagem', 400);

        }
        return $this->failUnauthorized('O cliente não está autorizado');
    }

}