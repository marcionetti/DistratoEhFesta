<?php

namespace App\Controllers;

use App\Models\ModelLogin;
use App\Models\ModelLogLogin;
use App\Controllers\Hash;

class Login extends BaseController
{
	private $login;
	protected $hash;

	public function __construct()
	{
		$this->hash = new Hash();
		$this->cadUsers = new ModelLogin();
		$this->LogLogin = new ModelLogLogin();
	}

	public function index()
	{

		echo view('fragments-login/header');
		echo view('login/index');
		echo view('fragments-login/footer');
	}

	public function login()
	{


		$Email = $this->request->getVar('Email');
		$hash = $this->hash->set($this->request->getVar('Senha'));
		$valid = true;
		$dados = [
			"Email" => $Email,
			"Senha" => $hash,
			"IP" => $this->request->getVar('IP'),
			"country_code" => $this->request->getVar('country_code'),
			"district" => $this->request->getVar('district'),
			"isp" => $this->request->getVar('isp'),
			"data" => date("Y-m-d H:i:s")
		];

		$retorno = $this->cadUsers->getWhere(['Email' => $Email, 'Senha' => $hash])->getRow();
		if ($retorno) {
			$dados['Status'] = "success";
			$Log = $this->LogLogin->insert($dados);

			session()->set("CodID", $retorno->ID);
			session()->set("Cod", $retorno->Cod);
			session()->set("Email", $retorno->Email);
			session()->set("Nome", $retorno->Nome);
			session()->set("TipoConviteID", $retorno->TipoConviteID);
			session()->set("imgpessoa", $retorno->imgpessoa);


			$retorno = "success";
		} else {
			$dados['Status'] = "error";
			$retorno = "ErroLogin";
		}
		$Log = $this->LogLogin->insert($dados);
		echo $retorno;
	}

	public function usuarioSessao()
	{
		$idUsuario = session()->get('id_usuario');

		echo json_encode($idUsuario);
	}

	public function existelogin()
	{
		$Email = $this->request->getVar('Email');

		$retorno = $this->cadUsers->getWhere(['Email' => $Email])->getRow();
		// var_dump($retorno);
		if ($retorno) {
			$retorno = "ErroLogin";
		} else {
			$retorno = "success";
		}
		// var_dump($retorno);
		echo $retorno;
	}
	public function cadastralogin()
	{

		$Email = $this->request->getVar('Email');
		$hash = $this->hash->set($this->request->getVar('Senha'));
		$Nome = $this->request->getVar('Nome');
		$valid = true;
		$Cod = uniqid();
		// echo $hash;
		$dados1 = [
			"Email" => $Email,
			"Senha" => $hash,
			"Cod" => $Cod,
			"Nome" => $Nome,
			"Token" => $Cod,
			"imgpessoa" => "avatar.jpg",
			"Criado" => date("Y-m-d H:i:s")
		];
		$dados2 = [
			"Status" => "Cadastro",
			"Email" => $Email,
			"Senha" => $hash,
			"IP" => $this->request->getVar('IP'),
			"country_code" => $this->request->getVar('country_code'),
			"district" => $this->request->getVar('district'),
			"isp" => $this->request->getVar('isp'),
			"data" => date("Y-m-d H:i:s")
		];


		$retorno = $this->cadUsers->insert($dados1);
		$Log = $this->LogLogin->insert($dados2);

		$retorno = $this->cadUsers->getWhere(['Email' => $Email])->getRow();
		if ($retorno) {
			session()->set("CodID", $retorno->ID);
			session()->set("Cod", $retorno->Cod);
			session()->set("Email", $retorno->Email);
			session()->set("Nome", $retorno->Nome);
			session()->set("TipoConviteID", $retorno->TipoConviteID);
			session()->set("imgpessoa", $retorno->imgpessoa);
		}

		echo "Cadastro";
	}
	public function cadastraFB()
	{
		$retorno = "Erro";

		$FBID = $this->request->getVar('ID');
		$Email = $this->request->getVar('Email');
		$Nome = $this->request->getVar('Nome');
		// $Img = $this->request->getVar('Img');
		$valid = true;
		$Cod = uniqid();
		// echo $hash;
		$dados1 = [
			"Email" => $Email,
			"lnkFacebook" => $FBID,
			"Cod" => $Cod,
			"Nome" => $Nome,
			"Token" => $Cod,
			"imgpessoa" => "avatar.jpg",
			"Criado" => date("Y-m-d H:i:s")
		];
		$dados2 = [
			"Status" => "Cadastro",
			"Email" => $Email,
			"Senha" => 'FB',
			"IP" => $this->request->getVar('IP'),
			"country_code" => $this->request->getVar('country_code'),
			"district" => $this->request->getVar('district'),
			"isp" => $this->request->getVar('isp'),
			"data" => date("Y-m-d H:i:s")
		];

		$retorno = $this->cadUsers->insert($dados1);

		$Log = $this->LogLogin->insert($dados2);

		$retorno = $this->cadUsers->getWhere(['Email' => $Email])->getRow();

		if ($retorno) {

			// $imgname = $retorno->Cod . ".jpg";

			// $imgpath = 'resources/img/Perfil/' . $imgname;

			// $data = file_get_contents($Img);
			// $file = fopen($imgpath, 'w+');
			// fputs($file, $data);
			// fclose($file);


			// $data = [
			// 	'ID' => $$retorno->ID,
			// 	'imgpessoa'  => $imgname,
			// ];

			// $this->cadUsers->update($data);

			session()->set("CodID", $retorno->ID);
			session()->set("Cod", $retorno->Cod);
			session()->set("Email", $retorno->Email);
			session()->set("Nome", $retorno->Nome);
			session()->set("TipoConviteID", $retorno->TipoConviteID);
			session()->set("imgpessoa", $retorno->imgpessoa);

			$retorno = "success";
		} else {
			$retorno = "ErroLogin";
		}

		return $retorno;
	}
	public function loginFB()
	{
		$FBID = $this->request->getVar('ID');
		$Nome = $this->request->getVar('Nome');
		$Email = $this->request->getVar('Email');

		$dados = [
			"Email" => $Email,
			"Senha" => 'FB-' . $Nome,
			"IP" => $this->request->getVar('IP'),
			"country_code" => $this->request->getVar('country_code'),
			"district" => $this->request->getVar('district'),
			"isp" => $this->request->getVar('isp'),
			"data" => date("Y-m-d H:i:s")
		];

		$retorno = $this->cadUsers->getWhere(['lnkFacebook' => $FBID])->getRow();
		if ($retorno) {
			$dados['Status'] = "success";
			$Log = $this->LogLogin->insert($dados);

			session()->set("CodID", $retorno->ID);
			session()->set("Cod", $retorno->Cod);
			session()->set("Email", $retorno->Email);
			session()->set("Nome", $retorno->Nome);
			session()->set("TipoConviteID", $retorno->TipoConviteID);
			session()->set("imgpessoa", $retorno->imgpessoa);


			$retorno = "success";
		} else {
			$dados['Status'] = "error";
			$retorno = "ErroLogin";
		}
		$Log = $this->LogLogin->insert($dados);
		echo $retorno;
	}
}
