<?php

namespace App\Controllers;
use App\Models\MProduk;
use CodeIgniter\HTTP\RequestInterface;

class ProdukController extends RestfulController{
    // public function create(){
    //     $data =[
    //         'kode_produk' => $this->request->getVar('kode_produk'),
    //         'nama_produk' => $this->request->getVar('nama_produk'),
    //         'harga' => $this->request->getVar('harga')
    //     ];

    //     $model = new MProduk();
    //     $model->insert($data);
    //     $produk = $model->find($model->getInsertID());
    //     return $this->responseHasil(200, true, $produk);
    // }

    public function create(){
        helper(['form', 'url']);

        $validationRules = [
            'kode_produk' => 'required',
            'nama_produk' => 'required',
            'harga' => 'required|decimal',
            'gambar' => [
                'label' => 'Image File',
                'rules' => [
                    'uploaded[gambar]',
                    'is_image[gambar]',
                    'mime_in[gambar,image/jpg,image/jpeg,image/gif,image/png,image/webp]',
                    'max_size[gambar,1024]', // max size in KB
                    'max_dims[gambar,2048,2048]', // max dimensions
                ],
            ],
            'deskripsi' => 'required',
            'stok' => 'required'
        ];

        if (!$this->validate($validationRules)) {
            $validationErrors = $this->validator->getErrors();
            return $this->response->setJSON([
                'status' => 400,
                'success' => false,
                'errors' => $validationErrors
            ]);
        }

        $img = $this->request->getFile('gambar');

        if (!$img->hasMoved()) {
            $newImageName = $img->getRandomName();
            $img->move(WRITEPATH . 'uploads', $newImageName);

            $sanitizedData = [
                'kode_produk' => filter_var($this->request->getPost('kode_produk'), FILTER_SANITIZE_STRING),
                'nama_produk' => filter_var($this->request->getPost('nama_produk'), FILTER_SANITIZE_STRING),
                'harga' => filter_var($this->request->getPost('harga'), FILTER_SANITIZE_NUMBER_FLOAT, FILTER_FLAG_ALLOW_FRACTION),
                'gambar' => $newImageName,
                'deskripsi' => filter_var($this->request->getPost('deskripsi'), FILTER_SANITIZE_STRING),
                'stok' => filter_var($this->request->getPost('stok'), FILTER_SANITIZE_NUMBER_FLOAT, FILTER_FLAG_ALLOW_FRACTION)
            ];

            $model = new MProduk();
            $model->insert($sanitizedData);

            $produkId = $model->getInsertID();
            $produk = $model->find($produkId);
            return $this->responseHasil(200, true, $produk);

            
        }
        return $this->responseHasil(400, false, 'The file has already been moved.');
    }

    // public function list(){
    //     $model = new MProduk();
    //     $produk = $model->findAll();
    //     return $this->responseHasil(200, true, $produk);
    // }
    public function list(){
        $model = new MProduk();
        $produk = $model->findAll();
        foreach ($produk as &$item) {
            $item['gambar_url'] = base_url('uploads/' . $item['gambar']);
        }
        
    
        return $this->responseHasil(200, true, $produk);
    }
    

    // public function detail($id){
    //     $model = new MProduk();
    //     $produk = $model->find($id);
    //     return $this->responseHasil(200, true, $produk);
    // }
    public function detail($id){
        $model = new MProduk();
        $produk = $model->find($id);
        if ($produk) {
            $produk['gambar_url'] = base_url('uploads/' . $produk['gambar']);
            
            return $this->responseHasil(200, true, $produk);
        } else {
            return $this->responseHasil(404, true, "produk tidak ditemukan");
        }
        
    }
    

    // public function ubah($id){
    //     $data =[
    //         'kode_produk' => $this->request->getVar('kode_produk'),
    //         'nama_produk' => $this->request->getVar('nama_produk'),
    //         'harga' => $this->request->getVar('harga')
    //     ];

    //     $model = new MProduk ();
    //     $model->update($id, $data);
    //     $produk = $model->find($id);
    //     return $this->responseHasil(200, true, $produk);
    // }
    public function ubah($id){
        helper(['form', 'url']);

        $validationRules = [
            'kode_produk' => 'required',
            'nama_produk' => 'required',
            'harga' => 'required|decimal',
            'gambar' => [
                'label' => 'Image File',
                'rules' => [
                    'uploaded[gambar]',
                    'is_image[gambar]',
                    'mime_in[gambar,image/jpg,image/jpeg,image/gif,image/png,image/webp]',
                    'max_size[gambar,1024]', // max size in KB
                    'max_dims[gambar,2048,2048]', // max dimensions
                ],
            ],
            'deskripsi' => 'required',
            'stok' => 'required'
        ];

        if (!$this->validate($validationRules)) {
            $validationErrors = $this->validator->getErrors();
            return $this->responseHasil(400, false, $validationErrors);
        }

        $model = new MProduk();
        $existingProduct = $model->find($id);

        if (!$existingProduct) {
            return $this->responseHasil(404, false, "Produk tidak ditemukan");
        }

        // Prepare data to update
        $dataToUpdate = [
            'kode_produk' => $this->request->getVar('kode_produk'),
            'nama_produk' => $this->request->getVar('nama_produk'),
            'harga' => $this->request->getVar('harga'),
            'deskripsi' => $this->request->getVar('deskripsi'),
            'stok' => $this->request->getVar('stok')
        ];

        $img = $this->request->getFile('gambar');

        if ($img->isValid() && !$img->hasMoved()) {
            $newImageName = $img->getRandomName();
            $img->move(WRITEPATH . 'uploads', $newImageName);

            // Delete the old image if exists
            if ($existingProduct['gambar']) {
                @unlink(WRITEPATH . 'uploads/' . $existingProduct['gambar']);
            }

        
            $dataToUpdate['gambar'] = $newImageName;
        }

        
        $model->update($id, $dataToUpdate);
        $updatedProduct = $model->find($id);

        return $this->responseHasil(200, true, $updatedProduct);
    }



    public function hapus($id){
        $model = new MProduk();
        $produk = $model->find($id);
        if ($produk) {
            if ($produk['gambar']) {
                @unlink(WRITEPATH . 'uploads/' . $produk['gambar']);
            }
            $delete = $model->delete($id);
            if($delete){
                return $this->responseHasil(200, true, "berhasil menghapus");
            }else{
                return $this->responseHasil(500, false, "gagal menghapus");
            }
        }else{
            return $this->responseHasil(404, false, "produk tidak ditemukan");
        }
        
    }

    // public function getProdukByName(){
    //     $nama_produk = $this->request->getVar('nama_produk');
    //     $keyword = '%' . $nama_produk . '%';
    //     $model = new MProduk();
    //     $produk = $model->like('nama_produk', $keyword)->findAll();
    //     return $this->responseHasil(200, true, $produk);
    // }

    public function getProdukByName(){
        $nama_produk = $this->request->getVar('nama_produk');
        $keyword = '%' . $nama_produk . '%';
        $model = new MProduk();
        $produk = $model->like('nama_produk', $keyword)->findAll();
        if ($produk) {
            // Tambahkan URL ke gambar untuk produk
            foreach ($produk as &$item) {
                $item['gambar_url'] = base_url('uploads/' . $item['gambar']);
            }
            return $this->responseHasil(200, true, $produk);
        }else{
            return $this->responseHasil(404, false, "produk tidak ditemukan");
        }
    }
      

}