<?php

namespace App\Controllers;

use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\API\ResponseTrait;
use App\Models\ModelSysTextoEmail;
use App\Models\ModelCadConvite;

require('ServidorEmail.php');

class APIEnviarLink extends ResourceController
{
    use ResponseTrait;

    public function EnviarLink()
	{
        $this->sysTextoEmail = new ModelSysTextoEmail();
		$this->ServEmail = new ServidorEmail();
		$this->cadConvite = new ModelCadConvite();

        $request = service('request');
        $bodyAPI = $this->request->getJSON();

        if ($request->getServer('HTTP_AUTHORIZATION') == mob_token) {

            $Email = $bodyAPI->dest;
            $Detalhe = $bodyAPI->coment;
            $Nome = $bodyAPI->userNome;
            $Link = base_url() . "/share/festa/";
            $CodConvite = $bodyAPI->codConvite;

            $URL = $Link . $CodConvite;

            $RegConvite = $this->cadConvite->getWhere(['Cod' => $CodConvite])->getRow();

            if($RegConvite->link){
                $URL =$Link . $RegConvite->link;
            }else{
                $Hash = hash('sha256', $CodConvite);
                $dados = [
                    'link' => $Hash,
                ];
                // var_dump($CodConvite);
                $updConvite = $this->cadConvite->updConvite($CodConvite, $dados);
                $URL =$Link . $Hash;
            }

            

            $Texto = $this->sysTextoEmail->getWhere(['Descricao' => 'EnviarLink'])->getRow();

            if ($Texto) {
                $find = array("#!Nome!#","#!Link!#","#!Obs!#");
                $replace = array($Nome,$URL,$Detalhe);
                
                $Titulo = str_replace($find,$replace,$Texto->Titulo);
                $Corpo = str_replace($find,$replace,$Texto->Corpo);

                $sendEmail = $this->ServEmail->envioEmail($Email, $Titulo, $Corpo);
                $sendEmail = json_decode($sendEmail, true);

                if ($sendEmail['status'] == "success") {
                    $retorno = "success";
                    $data = [
                        'status' => '200',
                        'data'   => $retorno,
                    ];
                    return $this->respond($data, 200);
                } else {
                    $retorno = $sendEmail['message'];
                    $data = [
                        'status' => '400',
                        'data'   => $retorno,
                    ];
                    return $this->respond($data, 200);
                } 
            } else {
                $data = [
                    'status' => '400',
                    'data'   => 'Erro ao enviar email',
                ];
                return $this->fail($data, 400);
            }
        }
        return $this->failUnauthorized('O cliente não está autorizado');
	}
}
