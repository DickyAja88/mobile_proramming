<?php

namespace App\Controllers;

use CodeIgniter\Controller;

class ImageController extends Controller
{
    public function show($filename)
    {
        $path = WRITEPATH . 'uploads/' . $filename;

        if (file_exists($path)) {
            $mime = mime_content_type($path);
            header('Content-Type: ' . $mime);
            readfile($path);
        } else {
            // Jika file tidak ditemukan, throw PageNotFoundException atau beri respons error
            throw new \CodeIgniter\Exceptions\PageNotFoundException('Gambar tidak ditemukan');
        }
    }
}
