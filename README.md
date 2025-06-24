# EJERCICIOS COBOL
## PRIMER EJERCICIO
### Caso 01: Procesamiento de estados de cuenta de clientes de un banco
  **🎯 Objetivo**
Un banco necesita procesar un archivo de movimientos bancarios diarios (depósitos y retiros) de sus clientes. Como desarrollador COBOL, debes:
  1. Leer un archivo de entrada .DAT (puede venir como CSV o de mainframe).
  2. Por cada registro:
    - Identificar el cliente.
    - Calcular el nuevo saldo.
    - Validar si se excedió el límite permitido.
  3. Escribir un nuevo archivo con los saldos actualizados.
  4. Si el saldo queda negativo, escribirlo en un archivo de alerta (NEGATIVE.TXT).
  5. Al final, mostrar un resumen de cuántas cuentas se procesaron, cuántas quedaron negativas.

  **¿Qué aprenderás aquí?**
  1. Archivos de entrada/salida (SELECT, READ, WRITE, OPEN, CLOSE).
  2. Uso de variables numéricas (PIC 9, V, S, etc.).
  3. Uso de bucles (PERFORM UNTIL).
  4. Validaciones (IF, EVALUATE).
  5. Uso de STRING, UNSTRING.
  6. Escritura condicional en múltiples archivos.
