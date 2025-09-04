<?php
namespace App\Controllers;

use App\Models\Equipos;

class EquipoController {
    public function alta($serialNumber, $hostname, $mac, $cpu, $ram, $diskType, $diskTotal, $laboratorio): bool {
        return Equipos::altaEquipo($serialNumber, $hostname, $mac, $cpu, $ram, $diskType, $diskTotal, $laboratorio);
    }

    public function actualizarSerial($id, $serialNumber): bool {
        return Equipos::actualizarSerial($id, $serialNumber);
    }

    public function listar($laboratorio): array {
        return Equipos::listarPorLaboratorio($laboratorio);
    }
}
