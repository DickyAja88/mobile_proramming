<?php
namespace App\Services;

use CodeIgniter\HTTP\RequestInterface;

class ProdukQuery {
    public function transform(Request $request) {
        $eloQuery = [];
    
        foreach ($this->safeParms as $parm => $operators) {
            $query = $request->getVar($parm);
            if (!isset($query)) {
                continue;
            }
    
            $column = $this->columnMap[$parm] ?? $parm;
    
            foreach ($operators as $operator) {
                if (isset($query[$operator])) {
                    $eloQuery[] = [$column, $this->operatorMap[$operator], $query[$operator]];
                }
            }
        }
    
        return $eloQuery;
    }
    
}

