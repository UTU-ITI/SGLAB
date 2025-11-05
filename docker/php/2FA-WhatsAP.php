<?php
// Iniciamos la sesión para poder guardar el código 2FA temporalmente
session_start();

/*
 * ============================================
 * LA INTERFAZ (EL CONTRATO)
 * ============================================
 *
 * Este es el contrato que NO cambia.
 * Define las "reglas del juego" para cualquier proveedor de 2FA.
 */
interface ProveedorDosPasos
{
    /**
     * Inicia el desafío para el usuario (ej. enviar un SMS, un WhatsApp, etc.).
     */
    public function enviarDesafio(Usuario $usuario): bool;

    /**
     * Verifica si el código proporcionado por el usuario es válido.
     */
    public function verificarCodigo(Usuario $usuario, string $codigo): bool;
}

/*
 * ============================================
 * NUEVA IMPLEMENTACIÓN: ProveedorWhatsapp
 * ============================================
 *
 * Esta es la nueva clase que pediste.
 * "Firma el contrato" ProveedorDosPasos usando "implements".
 * Debe proveer su propia lógica (el "CÓMO").
 */
class ProveedorWhatsapp implements ProveedorDosPasos
{
    /**
     * Define el CÓMO del envío por WhatsApp.
     */
    public function enviarDesafio(Usuario $usuario): bool
    {
        // 1. Generamos un código aleatorio
        $codigo = rand(100000, 999999);
        echo "LOG: (WhatsApp) Código generado: $codigo\n";

        // 2. Guardamos el código en la sesión para verificarlo después
        // En una app real, también guardaríamos una marca de tiempo de expiración
        $_SESSION['2fa_code_whatsapp'] = $codigo;
        $_SESSION['2fa_expiry_whatsapp'] = time() + 300; // Válido por 5 minutos

        // 3. Simulación de la llamada a la API de WhatsApp
        // En un caso real, aquí usarías una librería (ej. Twilio API for WhatsApp)
        // para enviar el mensaje al $usuario->telefono.
        echo "LOG: (API de WhatsApp) SIMULANDO envío de '$codigo' al teléfono {$usuario->telefono}...\n";
        
        // Asumimos que la API siempre funciona para este demo
        return true;
    }

    /**
     * Define el CÓMO de la verificación del código de WhatsApp.
     */
    public function verificarCodigo(Usuario $usuario, string $codigo): bool
    {
        // 1. Verificamos que el código exista en la sesión y no haya expirado
        if (!isset($_SESSION['2fa_code_whatsapp']) || $_SESSION['2fa_expiry_whatsapp'] < time()) {
            echo "LOG: (WhatsApp) Código no encontrado o expirado.\n";
            return false;
        }

        // 2. Comparamos el código
        $codigoGuardado = $_SESSION['2fa_code_whatsapp'];
        if ($codigo === (string)$codigoGuardado) {
            echo "LOG: (WhatsApp) Código '$codigo' verificado con éxito.\n";
            
            // 3. Limpiamos el código para que no se pueda reusar
            unset($_SESSION['2fa_code_whatsapp']);
            unset($_SESSION['2fa_expiry_whatsapp']);
            return true;
        }

        echo "LOG: (WhatsApp) Código incorrecto.\n";
        return false;
    }
}


/*
 * ============================================
 * LA CLASE "CLIENTE" (No cambia)
 * ============================================
 *
 * Esta clase NO NECESITA CAMBIAR. Sigue funcionando
 * igual, porque solo le importa la "interfaz".
 */
class LoginManager
{
    /**
     * ¡Polimorfismo en acción!
     * A este método no le importa si $proveedor es ProveedorSms,
     * ProveedorTotp o ProveedorWhatsapp.
     *
     * Solo sabe que $proveedor "firmó el contrato"
     * ProveedorDosPasos, y por lo tanto, TIENE un
     * método ->verificarCodigo().
     */
    public function completarLogin(Usuario $usuario, ProveedorDosPasos $proveedor, string $codigo): bool
    {
        echo "LoginManager: Verificando código...\n";
        if ($proveedor->verificarCodigo($usuario, $codigo)) {
            echo "LoginManager: ¡Login 2FA Exitoso! Bienvenido, {$usuario->nombre}.\n";
            return true;
        }
        
        echo "LoginManager: Error: El código 2FA es incorrecto.\n";
        return false;
    }
}


// --- Clases auxiliares para el demo ---
class Usuario 
{
    public function __construct(
        public string $nombre, 
        public string $telefono,
        public string $secretoTotp = "" // No se usa en este ejemplo
    ) {}
}

// ============================================
// --- DEMO DE USO CON WHATSAPP ---
// ============================================

$usuario = new Usuario('Beto', '+5491112345678');
$manager = new LoginManager();

echo "--- INTENTO DE LOGIN CON WHATSAPP ---\n";

// 1. Creamos la implementación CONCRETA de WhatsApp
$estrategiaWhatsapp = new ProveedorWhatsapp();

// 2. El proveedor se encarga de CÓMO enviar el desafío
$estrategiaWhatsapp->enviarDesafio($usuario);

// 3. El usuario mira su WhatsApp, ve el código y lo ingresa en el formulario.
// (Simulamos que el código correcto es el que se guardó en sesión)
$codigoDeWhatsapp = $_SESSION['2fa_code_whatsapp'];

echo "Usuario: (Ingresando el código $codigoDeWhatsapp desde WhatsApp...)\n";

// 4. El LoginManager usa la ESTRATEGIA (la interfaz) para verificar.
//    No sabe que es WhatsApp, solo sabe que es un ProveedorDosPasos.
$manager->completarLogin($usuario, $estrategiaWhatsapp, $codigoDeWhatsapp);

echo "\n--- INTENTO FALLIDO (Código incorrecto) ---\n";
// El usuario vuelve a intentar con un código viejo o incorrecto
$manager->completarLogin($usuario, $estrategiaWhatsapp, "000000");

?>
