<?php
session_start();
if (isset($_SESSION['usuario'])) {
    echo "Bienvenido, " . $_SESSION['usuario'];
    echo "<br><a href='logout.php'>Cerrar sesi�n</a>";
} else {
    echo "<a href='login.php'>Iniciar sesi�n</a> | <a href='register.php'>Registrarse</a>";
}
