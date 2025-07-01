# Compilar COBOL usando OpenCobolIDE en Windows
> [!IMPORTANT]  
> **Solo aplica si estás utilizando OpenCobolIDE y deseas compilar desde la terminal usando como IDE VSCODE u otro.**

#### 1. Agrega la ruta a las variables de entorno
Agrega lo siguiente a tu variable de entorno `PATH`:
```bash
 C:\Program Files (x86)\OpenCobolIDE\GnuCOBOL\bin   
```
Esto permitirá ejecutar `cobc.exe` desde la terminal.

#### 2. Verifica que la ruta fue agregada correctamente
Reinicia la terminal y ejecuta:
```bash
cobc --version
```

#### 3. Si intentas compilar con:
```bash
cobc -x nombre_archivo.cbl 
```
Te mostrará el error:
> [!CAUTION]  
> configuration error: /mingw/share/gnu-cobol/config\default.conf: No such file or directory

#### 4. Ejecutar con parametros
Tendrás que pasarle el parametro -conf e indicarle la ruta para el output donde se guardará el .exe con el parametro -o:
```bash
cobc -v basesinit.CBL -conf "C:\Program Files (x86)\OpenCobolIDE\GnuCOBOL\config\default.conf" -x -o exes\basesinit.exe
```
---
#### OPCIONAL
Si no compilar siempre de esta manera, puedes crear un alias function en tu profile de powershell.
- Para ello ejecuta:

```bash
notepad $PROFILE
```
- Pega lo siguiente:

> [!TIP]
> Puedes cambiar el nombre la funcion combol a otro(Ej. cobolexe).
```bash
function combol {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Archivo
    )

    # Obtener nombre sin extensión
    $nombre = [System.IO.Path]::GetFileNameWithoutExtension($Archivo)

    # Ruta al archivo default.conf
    $conf = 'C:\Program Files (x86)\OpenCobolIDE\GnuCOBOL\config\default.conf'

    # Ruta de salida
    $salida = "exes\$nombre.exe"

    # Ejecutar el comando de compilación
    cobc -v $Archivo -conf $conf -x -o $salida
}
```

- Reinicia la terminal y ejecuta:
```bash
combol nombre_archivo.cbl // o .cob
```
- Esto creará el ejecutable dentro de la carpeta exes\nombre_archivo.exe.
- Finalmente ejecuta con:
```bash
./exes/nombre_archivo.exe
```