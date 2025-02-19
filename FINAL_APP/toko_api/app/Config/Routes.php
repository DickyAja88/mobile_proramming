<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
$routes->get('/', 'Home::index');
$routes->post('/registrasi', 'RegistrasiController::registrasi');
$routes->post('/login', 'LoginController::login');

$routes->group('/produk', function($routes){
    $routes->post('/', 'ProdukController::create');
    $routes->get('cari', 'ProdukController::getProdukByName'); 
    $routes->get('/', 'ProdukController::list');
    $routes->get('(:segment)', 'ProdukController::detail/$1');
    $routes->post('(:segment)', 'ProdukController::ubah/$1');
    $routes->delete('(:segment)', 'ProdukController::hapus/$1');
});
  
$routes->get('writable/uploads/(:any)', 'StaticFiles::serveFile/$1');
