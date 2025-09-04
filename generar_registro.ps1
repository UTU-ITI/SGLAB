# Script PowerShell: Diagnóstico del PC y exportación en formato TOML con clave SSH

# Ejecutar comandos necesarios para permisos y claves
ssh-keygen -t rsa -b 4096
get-ExecutionPolicy
Set-ExecutionPolicy Unrestricted -Scope Process -Force

# Obtener fecha y nombre del equipo
$fecha = Get-Date -Format "yyyyMMdd"
$fechaLegible = Get-Date -Format "yyyy/MM/dd (HH:mm)"
$nombrePC = $env:COMPUTERNAME

# Función para generar clave SSH si no existe
function Generate-SSHKey {
    $sshDir = "$env:USERPROFILE\.ssh"
    $privateKeyPath = "$sshDir\id_rsa"
    $publicKeyPath = "$sshDir\id_rsa.pub"
    
    if (!(Test-Path $sshDir)) {
        try {
            New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
            Write-Output "Directorio .ssh creado"
        }
        catch {
            Write-Output "Error al crear directorio .ssh: $($_.Exception.Message)"
            return "ERROR: No se pudo crear el directorio .ssh"
        }
    }
    
    if (Test-Path $publicKeyPath) {
        try {
            $claveExistente = Get-Content $publicKeyPath -Raw
            return $claveExistente
        }
        catch {
            Write-Output "Error al leer la clave existente: $($_.Exception.Message)"
            return "ERROR: No se pudo leer la clave SSH existente"
        }
    }

    Write-Output "Generando nueva clave SSH..."

    try {
        Get-Command ssh-keygen -ErrorAction Stop | Out-Null
    }
    catch {
        Write-Output "ssh-keygen no está disponible en el sistema"
        return "ERROR: ssh-keygen no disponible. Instale OpenSSH Client."
    }

    $sshKeygenArgs = @(
        "-t", "rsa",
        "-b", "2048", 
        "-f", $privateKeyPath,
        "-N", '""',
        "-C", "$env:USERNAME@$env:COMPUTERNAME"
    )
    
    try {
        & ssh-keygen @sshKeygenArgs
        if (Test-Path $publicKeyPath) {
            Write-Output "Clave SSH generada exitosamente"
            $nuevaClave = Get-Content $publicKeyPath -Raw
            return $nuevaClave
        }
        else {
            Write-Output "Error al generar la clave SSH"
            return "ERROR: No se pudo generar la clave SSH"
        }
    }
    catch {
        Write-Output "Error ejecutando ssh-keygen: $_"
        return "ERROR: ssh-keygen falló - $($_.Exception.Message)"
    }
}

# Generar o obtener clave SSH pública
Write-Output "========== GESTION DE CLAVES SSH =========="
$clavePublica = Generate-SSHKey
Write-Output "=========================================="

# Intentar hacer ping al Gateway
Write-Output "Verificando conectividad..."
try {
    $gateway = (Get-NetRoute -DestinationPrefix "0.0.0.0/0").NextHop
    $ping = Test-Connection -ComputerName $gateway -Count 1 -Quiet
    if ($ping) {
        $estado = "Exito"
    }
    else {
        $estado = "Fallo"
    }
}
catch {
    $estado = "Error"
    $gateway = "No disponible"
}

# Obtener información del sistema
Write-Output "Recopilando información del sistema..."
try {
    $so = Get-CimInstance Win32_OperatingSystem
    $ipInfo = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.PrefixOrigin -eq "Dhcp" -or $_.PrefixOrigin -eq "Manual"} | Select-Object -First 1
    $cpu = Get-CimInstance Win32_Processor
    $ram = [math]::Round($so.TotalVisibleMemorySize / 1024 / 1024, 2)
    $disco = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $discoTotal = [math]::Round($disco.Size / 1GB, 2)
}
catch {
    Write-Output "Error al recopilar información del sistema: $($_.Exception.Message)"
    exit 1
}

# Solicitar y validar cédula del usuario
do {
    $cedula = Read-Host "Ingrese su cedula (maximo 8 digitos numericos)"
    $cedulaValida = $cedula -match '^\d{1,8}$'
    if (-not $cedulaValida) {
        Write-Output "Cédula inválida. Debe contener solo números y hasta 8 dígitos."
    }
} until ($cedulaValida)

# Ruta y nombre de archivo de salida (en el Escritorio del usuario)
$escritorio = [Environment]::GetFolderPath("Desktop")
$archivo = Join-Path $escritorio "$fecha-$nombrePC-$estado-$numeroSerie.toml"

# Crear contenido TOML
$contenido = @"
[info_general]
fecha = "$($fechaLegible)"
nombre_pc = "$($nombrePC)"
estado_conexion = "$($estado)"

[sistema_operativo]
nombre = "$($so.Caption)"
version = "$($so.Version)"

[red]
ip = "$($ipInfo.IPAddress)"
mascara = "$($ipInfo.PrefixLength)"
default_gateway = "$($gateway)"

[hardware]
cpu = "$($cpu.Name)"
ram_gb = $ram
disco_c_gb = $discoTotal

[ssh]
clave_publica = "$($clavePublica.Trim())"
usuario = "$($env:USERNAME)"
ruta_clave = "$($env:USERPROFILE)\.ssh\id_rsa.pub"

[usuario_responsable]
cedula = "$cedula"
"@

# Guardar archivo
try {
    $contenido | Out-File -FilePath $archivo -Encoding utf8
    Write-Output "Archivo TOML guardado: $archivo"
}
catch {
    Write-Output "Error al guardar archivo: $($_.Exception.Message)"
    Write-Output "========== SCRIPT con ERROR=========="
    exit 1
}

# Mostrar información en consola
Write-Output ""
Write-Output "========== DIAGNOSTICO COMPLETADO =========="
Write-Output "Archivo generado: $archivo"
Write-Output ""
Write-Output "========== CLAVE SSH PUBLICA =========="
Write-Output $clavePublica
Write-Output "======================================"

# Código SCP original comentado
$usuario = [Environment]::UserName
$servidor = "localhost"
try {
	$ping = Test-Connection -ComputerName $servidor -Count 1 -Quiet
	    if ($ping) {
        	Write-Output "Subiendo archivo: scp $archivo "$usuario@$servidor:LAB6/""
		    scp $archivo "$usuario@$servidor:LAB6/"
	    }
        else {
      	    Write-Output "Fallo: Revisar conexion a servidor SSH: $servidor"
	        Write-Output "========== SCRIPT CON ERROR=========="
    	    exit 1
        } 
}
catch {
    Write-Output "Error al ejecutar ping: $($_.Exception.Message)"
    Write-Output "========== SCRIPT con ERROR=========="
    exit 1
}

Write-Output "========== SCRIPT COMPLETADO con EXITO=========="
