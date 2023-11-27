<?php
namespace App\Controllers;

use App\Models\ModelServidorEmail;


class ServidorEmail extends BaseController
{
 
    private $email;

    public function __construct()
    {
        $this->email = new modelServidorEmail();
        
    }

    public function envioEmail($Email, $Titulo, $Corpo){

        // $destinatario = $this->request->getVar('txtEmail');

        if(!isset($Email) || $Email == ''){
            $result = array(
                'status'    => 'fields',
                'message'   => 'Email não preenchido',
                'token'     => csrf_hash()
            );

            return json_encode($result);
        }
        if(strpos($Email,",")>0){
            $result = array(
                'status'    => 'fields',
                'message'   => 'Email inválido',
                'token'     => csrf_hash()
            );

            return json_encode($result);
        }
        if(!isset($Titulo) || $Titulo == ''){
            $result = array(
                'status'    => 'fields',
                'message'   => 'Campos obrigatórios não preenchidos',
                'token'     => csrf_hash()
            );

            return json_encode($result);
        }
        if(!isset($Corpo) || $Corpo == ''){
            $result = array(
                'status'    => 'fields',
                'message'   => 'Campos obrigatórios não preenchidos',
                'token'     => csrf_hash()
            );

            return json_encode($result);
        }
        
        $result = $this->email->envioEmail($Email, $Titulo, $Corpo);


        if ($result) {
            $result = array(
                'status'    => 'success',
                'message'   => 'E-mail enviado',
                'token'     => csrf_hash()
            );

            return json_encode($result);
        } else {
            $result = array(
                'status'    => 'danger',
                'message'   => 'Erro ao enviar email',
                'token'     => csrf_hash()
            );

            return json_encode($result);
        }        
    }
}
