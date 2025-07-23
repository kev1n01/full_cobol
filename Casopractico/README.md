# 📂 Archivos de Entrada

---

## `FILINP1.txt` - Información de cuenta

- **Longitud:** 42 bytes  
- **Campos:** 4

### 🧾 Registro de ejemplo:
000301000000000001644547751198116501
### 📥 Entrada esperada:
- `ACC-COD-ENT`: 0003  
- `ACC-CENT-ALTA`: 0100  
- `ACC-NUMB`: 000000000164  
- `ACC-PAN`: 4547751198116501  

---

## `FILINP2.txt` - Información de tarjeta

- **Longitud:** 50 bytes  
- **Campos:** 7

### 🧾 Registro de ejemplo:
4390460000127007      011913.11.20209805.09.201650

### 📥 Entrada esperada:
- `INF-PAN`: 4390460000127007  
- `INF-COD-MAR`: 01  
- `INF-IND-TIP`: 19  
- `INF-FEC-BAJ`: 13.11.2020  
- `INF-MOT-BAJ`: 98  
- `INF-FEC-BLOQ`: 05.09.2016  
- `INF-COD-BLOQ`: 50  

---

# 📤 Archivos de Salida

---
## `FILOUT1.txt`

- Solo tarjeta Visa o con `INF-COD-MAR = 01`
- Escribir en `VIS-DES-BLOQ`: **"TARJETA ACTIVA"** si `INF-COD-BLOQ = 00`
- **Longitud:** 106 bytes  
- **Campos:** 7

### Salida esperada:
- `VIS-COD-ENT`: 0003  
- `VIS-CENT-ALTA`: 0987  
- `VIS-NUMB`: 000000000520  
- `VIS-PAN`: 4390460000127007  
- `VIS-DES-MAR`: VISA  
- `VIS-FEC-BLOQ`: 05.09.2016  
- `VIS-DES-BLOQ`: BLOQUEO TARJETA POR ROBO  

---

## `FILOUT2.txt`

- Reporte de cuentas bloqueadas (`INF-COD-BLOQ ≠ 00`)  
- Rango: Desde hace un mes hasta la fecha actual  
- Usar función `INTEGER-OF-DATE` y`DATE-OF-INTEGER` para cálculo de fechas  

- **Longitud:** 68 bytes  
- **Campos:** 4

### 🧾 Registro de entrada 1:
000301000000028842344547751253080048

### 🧾 Registro de entrada 2:
4547751253080048      010101.01.0001  02.05.202557

### 📤 Salida esperada:
- `REP-NUMB`: 000002884234  
- `REP-PAN`: 4547751253080048  
- `REP-FEC-BLOQ`: 02/05/2025  
- `REP-DES-BLOQ`: BLOQUEO REEMISION REZAGO  

---

# ⚙️ Lógica de Procesamiento

---
1. Definir variables para manejo de fechas  
2. Definir una tabla `OCCURS` indexada para `FILINP1`  
3. Obtener fecha actual y calcular fecha hace un mes con `INTEGER-OF-DATE` y `DATE-OF-INTEGER`  
4. Abrir archivos  
5. Cargar registros de `FILINP1` a la tabla indexada  
6. Leer `FILINP2`  
7. Buscar por PAN en la tabla:
   - Si hay **match**, evaluar para `FILOUT1`:
     - Condición: `INF-COD-MAR = 01`
     - Obtener descripción de marca y bloqueo
     - Mover otros datos
     - Escribir
   - Si hay **match**, evaluar para `FILOUT2`:
     - Condición 1: `INF-COD-BLOQ ≠ 00`
     - Condición 2: `Fecha-Hace-Un-Mes <= Fecha Bloqueo <= Fecha Actual`
     - Formatear fecha de bloqueo de `DD.MM.YYYY` a `DD/MM/YYYY`
     - Obtener descripción de bloqueo
     - Mover otros datos
     - Escribir

---

# 🛠️ Posibles Mejoras

---

- Usar SEARCH para la busqueda en tabla cuenta de tarjeta `FILINP1`
---

# 📝 Pendientes

---

- Programar un `JOB` en JCL en Mainframe para ejecutar la rutina  
- Pasar como variable la longitud de registros del archivo `FILINP1` desde JCL (para no modificar manualmente el `OCCURS`)

---

# 📸 Imágenes de Ejecución

---

- Ejemplo con 100,000 registros