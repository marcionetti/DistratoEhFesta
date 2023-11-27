<?php

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\modelCadUsers;
use App\Models\ModelLogLogin;
use App\Controllers\Hash;

class Cliente extends BaseController
{
	private $login;
	protected $hash;

	public function __construct()
	{
		$this->hash = new Hash();
		$this->cadUsers = new modelCadUsers();
		$this->LogLogin = new ModelLogLogin();
	}


	public function MigraCLiente()
	{
		$tblCliente = "";
		$sql = "SELECT ID, Nome, Email, TipoConviteID, Criado FROM cadUsers order by ID";
		$retorno = $this->cadUsers->query($sql)->getResult();
		if ($retorno) {
			foreach ($retorno as $row) {
				$TipoConviteID = $row->TipoConviteID == '1' ? "Pessoa" : "Empresa";
				$tblCliente .= "
				<tr>
					<td><button type='button' onclick='updCliente($row->ID, $row->TipoConviteID);' class='btn btn-default btn-sm'><i class='fas fa-retweet'></i></button></td>
					<td>$row->ID</td>
					<td>$row->Nome</td>
					<td>$row->Email</td>
					<td>$TipoConviteID</td>
					<td>$row->Criado</td>
				</tr>";
			}
		}

		$data = array();
		$data['tblCliente'] = $tblCliente;

		echo view('fragments/header');
		echo view('cliente/index', $data);
		echo view('fragments/footer');
	}
	public function updCliente()
	{
		$ID = $this->request->getVar('ID');
		$Tipo = $this->request->getVar('Tipo');
		$nTipo = $Tipo == '1' ? '2' : '1';

		$sql = "UPDATE cadUsers SET TipoConviteID=$nTipo WHERE ID=$ID";
		$retorno = $this->cadUsers->query($sql);

		echo json_encode($retorno);
	}

}
