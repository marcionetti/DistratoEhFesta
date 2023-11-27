<?php

namespace App\Controllers;

use App\Models\ModelLogin;
use App\Models\ModelLogLogin;
use App\Controllers\Hash;
use App\Models\ModelCadConviteVW;

class Share extends BaseController
{
	private $login;
	protected $hash;

	public function __construct()
	{
		$this->hash = new Hash();
		$this->cadUsers = new ModelLogin();
		$this->LogLogin = new ModelLogLogin();
		$this->cadConviteVW = new ModelCadConviteVW();
	}

	public function index()
	{
		return redirect()->to(base_url());
	}
	public function festa($link = 'err')
	{
		if ($link == 'err' or strlen($link) < 5) {
			// echo "Cod erro1";
			return redirect()->to(base_url());
		}

		// Inicio convite

        
        $dspBotoes = "";
        $dspPresente = '';
        $dspConvidados = '';

        $result = $this->cadConviteVW->getWhere(['link' => $link])->getRow();

		if(!$result){
			// echo "Cod erro2";
			return redirect()->to(base_url());
		}

		$EventoCod = $result->Cod;
		$selConvidar = ' ';
		$selCompartilha = ' ';
		$selListaConvidados = ' ';
		$selMuralRecado = ' ';
		$selPresenteVirtual = ' ';
		$dspBotoes = '<a class="btn btn-app bg-orange" title="Informar Presença / Ausência" data-toggle="modal" data-target="#modalUsuario"><i class="fas fa-envelope"></i> RSVP</a>';
		$dspBotoes .= '<a class="btn btn-app bg-purple" title="Levar Acompanhante" data-toggle="modal" data-target="#modalUsuario"><i class="fa fa-user-plus"></i> + Conv</a>';
		$dspBotoes .= '<a class="btn btn-app bg-primary" onclick="" title="Comentários" data-toggle="modal" data-target="#modalUsuario"><i class="fas fa-comments"></i> Msg</a>';
		$dspBotoes .= '<a class="btn btn-app bg-pink" title="Compartilhar Convite" data-toggle="modal" data-target="#modalUsuario"><i class="fa fa-share-alt"></i> Enviar</a>';
		$dspBotoes .= '<a class="btn btn-app bg-info" title="Lista de Convidados" data-toggle="modal" data-target="#modalUsuario"><i class="fas fa-list"></i> Conv</a>';

		// $selTipoEvento = '';
		// $selTipoPublico = '';
		$data = array();
		$data['EventoCod']          = $result->Cod;
		$data['Titulo']             = $result->Titulo;
		$data['Status']             = $result->StatusDesc;
		$data['StatusCor']          = $result->StatusCor;
		$data['Evento']             = $result->Descricao;
		$data['DataEvento']         = $result->DataEventoDesc;
		$data['TipoEvento']         = $result->TipoEventoDesc;
		$data['TipoPublico']        = $result->TipoPublicoDesc;
		$data['Convidar']           = $result->ConvidarDesc;
		$data['Endereco']           = $result->Endereco;
		$data['Obs']                = $result->Obs;

		$data['dspBotoes']          = $dspBotoes;
		$data['selComentarios']     = '';

		$data['imgConvite']         = 'resources/img/Convite/' . $EventoCod . '.jpg';

		echo view('fragments-login/header');
		echo view('share', $data);
		echo view('fragments-login/footer');
	}


	public function loginFB()
	{
		session()->set("Cod", $retorno->Cod);
		session()->set("Email", $retorno->Email);
		session()->set("Nome", $retorno->Nome);
		session()->set("TipoConviteID", $retorno->TipoConviteID);
		session()->set("imgpessoa", $retorno->imgpessoa);
	}
}
