# Script PowerShell: Diagnóstico del PC y exportación en formato TOML (simplificado)

# Datos iniciales
$fecha = Get-Date -Format "yyyyMMdd"
$nombrePC = $env:COMPUTERNAME

# Solicitar cédula al usuario
$cedula = Read-Host "Ingrese su cedula (sin puntos ni guiones)"

# Diagnóstico de red
$gateway = (Get-NetRoute -DestinationPrefix "0.0.0.0/0").NextHop
$pingLAN = Test-Connection $gateway -Count 1 -Quiet
$pingWAN = Test-Connection "8.8.8.8" -Count 1 -Quiet
$dnsOK   = Test-Connection "www.google.com" -Count 1 -Quiet

# Obtener IP y saber si usa DHCP
$ip = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -ne "127.0.0.1"} | Select-Object -First 1
$interfaz = Get-NetIPInterface -InterfaceIndex $ip.InterfaceIndex
$usaDHCP = $interfaz.Dhcp -eq "Enabled"

# Determinar estado general
$estado = if ($pingLAN) { "Exito" } else { "Fallo" }

# Sistema y hardware
$so = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$ram = [math]::Round($so.TotalVisibleMemorySize / 1MB, 2)
$disco = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$discoTotal = [math]::Round($disco.Size / 1GB, 2)

# Recursos disponibles cpu (uso en %)
try {
    $cpuUso = (Get-WmiObject win32_processor | Measure-Object -Property LoadPercentage -Average).Average
} catch {
    Write-Warning "No se pudo obtener el uso de CPU. Se asigna 0% como valor predeterminado."
    $cpuUso = 0
}

# Recursos disponibles ram
$ramLibre = $so.FreePhysicalMemory / 1MB
$ramUso = ($ram - $ramLibre)
$ramUsoPorc = [math]::Round(($ramUso / $ram) * 100, 2)

# Recursos disponibles disco
$discoLibre = [math]::Round($disco.FreeSpace / 1GB, 2)
$discoUso = [math]::Round((($discoTotal - $discoLibre) / $discoTotal) * 100, 2)

# Archivo de salida
$archivo = "$fecha-$nombrePC-$estado.toml"

# Contenido TOML
$contenido = @"
[info_general]
fecha = "$fecha"
cedula = "$cedula"
nombre_pc = "$nombrePC"
estado_conexion = "$estado"

[sistema_operativo]
nombre = "$($so.Caption)"
version = "$($so.Version)"

[red]
ip = "$($ip.IPAddress)"
mascara = "$($ip.PrefixLength)"
default_gateway = "$gateway"

[hardware]
cpu = "$($cpu.Name)"
ram_gb = $ram
disco_c_gb = $discoTotal

[diagnostico_red]
LAN = "$($pingLAN -replace 'True','Exito' -replace 'False','Fallo')"
WAN = "$($pingWAN -replace 'True','Exito' -replace 'False','Fallo')"
DHCP = "$($usaDHCP -replace 'True','Exito' -replace 'False','Fallo')"
DNS = "$($dnsOK -replace 'True','Exito' -replace 'False','Fallo')"

[recursos_disponibles]
cpu_uso_porcentaje = $cpuUso
ram_uso_porcentaje = $ramUsoPorc
disco_c_uso_porcentaje = $discoUso
"@

# Guardar archivo
$contenido | Out-File -FilePath $archivo -Encoding utf8

# (Opcional) Subir con SCP - Ajustar con tus datos reales

#scp $archivo hostname@ip:~

Write-Host "Archivo generado: $archivo"
sleep 3
