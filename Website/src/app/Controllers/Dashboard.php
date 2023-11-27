<?php

namespace App\Controllers;

use App\Controllers\BaseController;

class Dashboard extends BaseController
{
    public function index()
    {
        if(session()->get('Nome') and session()->get('Nome')!=""){
            $data = array();
            $data['NomePessoa'] = session()->get('Nome');
            $data['EmailPessoa'] = session()->get('Email');
            $data['CodPessoa'] = session()->get('Cod');
            $data['imgpessoa'] = session()->get('imgpessoa');
            $data['TipoConviteID'] = session()->get('TipoConviteID');
            
            if(session()->get('imgpessoa')){ 
                $imgpessoa=session()->get('imgpessoa');
            }else{
                $imgpessoa="avatar.jpg";
            }


            if(session()->get('TipoConviteID')=='1'){
                $cFrameNome= '<a class="nav-link active" data-toggle="row" id="tab-Convites" href="#panel-Convites" role="tab" aria-controls="panel-Convites" aria-selected="true">Meus Convites</a>';
                $cFrame = '<div class="tab-pane fade active show" id="panel-Convites" role="tabpanel" aria-labelledby="tab-index">
                                <iframe src="Convites" style="height: 87vh;"></iframe>
                            </div>';
                $menuConvite = '
                    <li class="nav-item">
                        <a href="Convites/convite/000001E" class="nav-link">
                            <i class="nav-icon fas fa-ticket-alt"></i>
                            <p>
                                Novo Convite
                            </p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="Convites" class="nav-link">
                            <i class="nav-icon fas fa-id-card-alt"></i>
                            <p>
                                Meus Convites
                            </p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="Convites/CVD" class="nav-link">
                            <i class="nav-icon fas fa-chalkboard-teacher"></i></i>
                            <p>
                                Convite Recebido
                            </p>
                        </a>
                    </li>
                ';

                $menuEvento = '
                    <li class="nav-item">
                        <a href="Eventos/CVD" class="nav-link">
                            <i class="nav-icon far fa-address-book"></i>
                            <p>
                                Buscar Eventos
                            </p>
                        </a>
                    </li>
                ';

                if (session()->get('CodID')=='1'){
                    $MenuConfig= '
                    <nav class="mt-2" style="border-bottom: 1px solid #4f5962;">
                        <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
                            <li class="nav-item">
                                <a href="Cliente/MigraCliente" class="nav-link">
                                <i class="nav-icon fas fa-retweet"></i>
                                    <p>
                                        Migração Cliente
                                    </p>
                                </a>
                            </li>
                        </ul>
                    </nav>
                    ';
                } else {
                    $MenuConfig= ''; 
                }
                
            } else {
                $cFrameNome= '<a class="nav-link active" data-toggle="row" id="tab-Eventos" href="#panel-Convites" role="tab" aria-controls="panel-Convites" aria-selected="true">Meus Eventos</a>';
                $cFrame = '<div class="tab-pane fade active show" id="panel-Eventos" role="tabpanel" aria-labelledby="tab-index">
                                <iframe src="Eventos" style="height: 87vh;"></iframe>
                            </div>';
                $menuConvite = '';

                $menuEvento = '
                    <li class="nav-item">
                        <a href="Eventos/evento/000001E" class="nav-link">
                            <i class="nav-icon far fa-calendar-plus"></i></i>
                            <p>
                                Novo Evento
                            </p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="Eventos" class="nav-link">
                            <i class="nav-icon far fa-calendar-check"></i>
                            <p>
                                Meus Eventos
                            </p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="Eventos/CVD" class="nav-link">
                            <i class="nav-icon far fa-address-book"></i>
                            <p>
                                Buscar Eventos
                            </p>
                        </a>
                    </li>
                ';
                $MenuConfig= ''; 
            }

            $data['MenuConfig'] = $MenuConfig;
            $data['MenuConvite'] = $menuConvite;
            $data['MenuEvento'] = $menuEvento;
            $data['cFrameNome'] = $cFrameNome;
            $data['cFrame'] = $cFrame;

            echo view('dashboard/index',$data);
        }else{
            unset(
                $_SESSION['CodID'],
                $_SESSION['Cod'],
                $_SESSION['Email'],
                $_SESSION['Nome'],
                $_SESSION['imgpessoa'],
                $_SESSION['TipoConviteID'],
            );

            header("Location: ".base_url()); 
            exit();
        }
    }
}
