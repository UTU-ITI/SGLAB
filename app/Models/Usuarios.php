<?php
namespace App\Models;

use App\Database\ConexionDB;
use PDO;

class Usuarios extends Personas {
    public int $id;
    public string $email;
    public string $password;
    public Perfiles $perfil;

    public function __construct($id, $ci, $nombre, $apellido, $direccion, $fechaNacimiento, $email, $password, Perfiles $perfil) {
        parent::__construct($ci, $nombre, $apellido, $direccion, $fechaNacimiento);
        $this->id = $id;
        $this->email = $email;
        $this->password = $password;
        $this->perfil = $perfil;
    }

    public static function registrar($ci, $nombre, $apellido, $direccion, $fechaNacimiento, $email, $password, $perfil): bool {
        $db = ConexionDB::getInstancia()->getConexion();
        $sql = "INSERT INTO usuarios (ci, nombre, apellido, direccion, fechaNacimiento, email, password, perfil_id) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $db->prepare($sql);
        return $stmt->execute([$ci, $nombre, $apellido, $direccion, $fechaNacimiento, $email, password_hash($password, PASSWORD_BCRYPT), $perfil->id]);
    }

    public static function login($email, $password): ?Usuarios {
        $db = ConexionDB::getInstancia()->getConexion();
        $stmt = $db->prepare("SELECT * FROM usuarios WHERE email = ?");
        $stmt->execute([$email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user && password_verify($password, $user['password'])) {
            $perfil = new Perfiles($user['perfil_id'], "Estudiante", "Acceso básico");
            return new Usuarios($user['id'], $user['ci'], $user['nombre'], $user['apellido'], $user['direccion'], $user['fechaNacimiento'], $user['email'], $user['password'], $perfil);
        }
        return null;
    }
}
