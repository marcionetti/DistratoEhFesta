<?php

namespace App\Controllers;

use App\Models\ModelSysTextoEmail;
use App\Models\ModelCadConvite;

require('ServidorEmail.php');

class TextoEmail extends BaseController
{

	public function __construct()
	{
		$this->sysTextoEmail = new ModelSysTextoEmail();
		$this->ServEmail = new ServidorEmail();
		$this->cadConvite = new ModelCadConvite();
	}

	public function CadastroLogin()
	{
		$Nome = $this->request->getVar('Nome');
		$Email = $this->request->getVar('Email');
		$Senha = $this->request->getVar('Senha');

		$Texto = $this->sysTextoEmail->getWhere(['Descricao' => 'CadastroLogin'])->getRow();

		if ($Texto) {
			$find = array("#!Nome!#","#!Email!#","#!Senha!#");
			$replace = array($Nome,$Email,$Senha);
			
			$Titulo = str_replace($find,$replace,$Texto->Titulo);
			$Corpo = str_replace($find,$replace,$Texto->Corpo);

			
			$sendEmail = $this->ServEmail->envioEmail($Email, $Titulo, $Corpo);
			$retorno = "success";
		} else {
			$dados['Status'] = "error";
			$retorno = "ErroEmail";
		}
		return $retorno;
	}

	public function EnviarLink()
	{
		$Nome = session()->get('Nome');
		$Email = $this->request->getVar('Email');
		$Detalhe = $this->request->getVar('Detalhe');
		$Link = $this->request->getVar('Link');
		$CodConvite = $this->request->getVar('Convite');
		$RegConvite = $this->cadConvite->getWhere(['Cod' => $CodConvite])->getRow();
		if($RegConvite->link){
			$URL =$Link . $RegConvite->link;
		}else{
			$Hash = hash('sha256', $CodConvite);
			$dados = [
				'link' => $Hash,
			];
			var_dump($CodConvite);
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
			$retorno = "success";
		} else {
			$dados['Status'] = "error";
			$retorno = "ErroEmail";
		}
		return $retorno;
	}
}
