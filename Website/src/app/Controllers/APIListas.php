<?php

namespace App\Controllers;

use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\HTTP\IncomingRequest;
use CodeIgniter\API\ResponseTrait;
use App\Models\ModeltpoUserSexo;
use App\Models\ModeltpoUserEstadoCivil;
use App\Models\ModeltpoEvento;
use App\Models\ModeltpoPublico;

class APIListas extends ResourceController
{

    use ResponseTrait;

    public function lstSexo(){
        $request = service('request'); 
        $bodyAPI = $this->request->getJSON();

        if ($request->getServer('HTTP_AUTHORIZATION') == mob_token) {
            
            $Email = $bodyAPI->Email;

            $model = new ModeltpoUserSexo();

            $data = $model->orderBy('Descricao')->getWhere(['Ativo' => '1'])->getResult();

            if ($data) {
                $data = [
                    'status' => '200',
                    'data'   => $data,
                ];
                return $this->respond($data, 200);
            }

            return $this->failNotFound('Nenhum dado encontrado');
        }
        return $this->failUnauthorized('O cliente não está autorizado');
    }
    
    public function lstEstadoCivil(){
        $request = service('request'); 
        $bodyAPI = $this->request->getJSON();

        if ($request->getServer('HTTP_AUTHORIZATION') == mob_token) {
            
            $Email = $bodyAPI->Email;

            $model = new ModeltpoUserEstadoCivil();

            $data = $model->orderBy('Descricao')->getWhere(['Ativo' => '1'])->getResult();

            if ($data) {
                $data = [
                    'status' => '200',
                    'data'   => $data,
                ];
                return $this->respond($data, 200);
            }

            return $this->failNotFound('Nenhum dado encontrado');
        }
        return $this->failUnauthorized('O cliente não está autorizado');
    }
    public function lstTipoEvento(){
        $request = service('request'); 
        $bodyAPI = $this->request->getJSON();

        if ($request->getServer('HTTP_AUTHORIZATION') == mob_token) {
            
            $Email = $bodyAPI->Email;

            $model = new ModeltpoEvento();

            $data = $model->orderBy('Descricao')->getWhere(['Ativo' => '1'])->getResult();

            if ($data) {
                $data = [
                    'status' => '200',
                    'data'   => $data,
                ];
                return $this->respond($data, 200);
            }

            return $this->failNotFound('Nenhum dado encontrado');
        }
        return $this->failUnauthorized('O cliente não está autorizado');
    }

    public function lstTipoPublico(){
        $request = service('request'); 
        $bodyAPI = $this->request->getJSON();

        if ($request->getServer('HTTP_AUTHORIZATION') == mob_token) {
            
            $Email = $bodyAPI->Email;

            $model = new ModeltpoPublico();

            $data = $model->orderBy('Descricao')->getWhere(['Ativo' => '1'])->getResult();

            if ($data) {
                $data = [
                    'status' => '200',
                    'data'   => $data,
                ];
                return $this->respond($data, 200);
            }

            return $this->failNotFound('Nenhum dado encontrado');
        }
        return $this->failUnauthorized('O cliente não está autorizado');
    }

}
