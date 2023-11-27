<?php

namespace App\Controllers;

use App\Controllers\BaseController;

class Logout extends BaseController
{
	public function logout()
	{
		$items = ['CodID', 'Cod', 'Email', 'Nome', 'TipoConviteID', 'imgpessoa'];
		session()->remove($items);

		return "logout";
	}
}
