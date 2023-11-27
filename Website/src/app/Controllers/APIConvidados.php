<?php

namespace App\Controllers;

use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\API\ResponseTrait;
use App\Models\modelLnkConviteConvidadoVW;
use App\Models\modelLnkConviteConvidado;


class APIConvidados extends ResourceController
{
    use ResponseTrait;

    public function show($id = null)
    {
        $this->ConviteConvidadoVW = new modelLnkConviteConvidadoVW();
        

        // $id = "1D43140A15";
        $request = service('request');
        if ($request->getServer('HTTP_AUTHORIZATION') == mob_token) {

            $sql = "SELECT vwlnkConviteConvidado.UserEmail, vwlnkConviteConvidado.Nome, vwlnkConviteConvidado.Detalhes, count(lnkConviteConvidado.ID)as convQtd FROM vwlnkConviteConvidado 
            Left Join lnkConviteConvidado on vwlnkConviteConvidado.UserEmail = lnkConviteConvidado.Convidado
            where vwlnkConviteConvidado.Convidado is null and vwlnkConviteConvidado.conv_Cod='60047148A0'
            Group by vwlnkConviteConvidado.UserEmail, vwlnkConviteConvidado.Nome, vwlnkConviteConvidado.Detalhes, lnkConviteConvidado.Convidado";
            
            $data = $this->ConviteConvidadoVW->query($sql)->getResult();
            if ($data[0]->UserEmail) {
                $data = [
                    'status' => '200',
                    'data'   => $data,
                ];
                return $this->respond($data, 200);
            } else {
                $data = [
                    'status' => '402',
                    'data'   => 'Nenhum dado encontrado',
                ];
                return $this->respond($data, 400);
            }

            
        }
        return $this->failUnauthorized('O cliente não está autorizado');
    }
    public function Acompanhante($id = null)
    {
        $this->ConviteConvidadoVW = new modelLnkConviteConvidadoVW();
        $this->ConviteConvidado = new modelLnkConviteConvidado();

        // $id = "1D43140A15";
        $request = service('request');
        $bodyAPI = $this->request->getJSON();

        $ConviteCod = $bodyAPI->CodConvite;
        $Convidado = $bodyAPI->Convidado;
        $ConvidadoEmail = $bodyAPI->ConvidadoEmail;
        $Nome = $bodyAPI->Nome;
        $Email = $bodyAPI->Email;
        $Parentesco = $bodyAPI->Parentesco;
        $Detalhe = $bodyAPI->Detalhe;

        // $data = [
        //         'status' => '200',
        //         'ConviteCod'   => $ConviteCod,
        //         'Convidado'   => $Convidado,
        //         'Nome'   => $Nome,
        //         'Email'   => $Email,
        //         'Parentesco'   => $Parentesco,
        //         'Detalhe'   => $Detalhe,
        //     ];
        //     return $this->respond($data, 200);

        if ($request->getServer('HTTP_AUTHORIZATION') == mob_token) {
            if ($Convidado <> "") {
                $sql = "SELECT Confirmado, DataConfirmado FROM lnkConviteConvidado where ConviteCod = '$ConviteCod' and UserEmail='$ConvidadoEmail'";
                $result = $this->ConviteConvidado->query($sql)->getResult();
                if ($result) {
                    $Confirmado = $result[0]->Confirmado;
                    $Data = $result[0]->DataConfirmado;
                } else {
                    $Confirmado = '0';
                    $Data = date("Y-m-d H:i:s");
                    $dados2 = [
                        "ConviteCod" => $ConviteCod,
                        "Nome" => $Convidado,
                        "UserEmail" => $ConvidadoEmail,
                        "Confirmado" => $Confirmado,
                        "DataConfirmado" => $Data,
                        "DataConvite" => $Data,
                    ];
                    $result = $this->ConviteConvidado->insert($dados2);
                }
                $dataupd = date("Y-m-d H:i:s");
                $dados = [
                    "ConviteCod" => $ConviteCod,
                    "Convidado" => $Convidado,
                    "Nome" => $Nome,
                    "UserEmail" => $Email,
                    "Parentesco" => $Parentesco,
                    "Detalhes" => $Detalhe,
                    "Confirmado" => $Confirmado,
                    "DataConfirmado" => $Data,
                    "DataConvite" => $dataupd,
                ];
                $result = $this->ConviteConvidado->insert($dados);
                if ($result) {
                    $data = [
                        'status' => '200',
                        'data'   => 'Sucesso',
                    ];
                    return $this->respond($data, 200);
                } 
            } else {
                $dados = [
                    "ConviteCod" => $ConviteCod,
                    "Nome" => $Nome,
                    "UserEmail" => $Email,
                    "Parentesco" => $Parentesco,
                    "Detalhes" => $Detalhe,
                    "Confirmado" => '0',
                    "DataConfirmado" => '',
                    "DataConvite" => date("Y-m-d H:i:s"),
                ];
                $result = $this->ConviteConvidado->insert($dados);
                if ($result) {
                    $data = [
                        'status' => '200',
                        'data'   => 'Sucesso',
                    ];
                    return $this->respond($data, 200);
                } 
            }
            return $this->fail('Erro ao adicionar Convidado', 400);
        }
        return $this->failUnauthorized('O cliente não está autorizado');
    }
}
