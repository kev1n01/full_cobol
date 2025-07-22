*******************************************************************
                        ARCHIVOS DE ENTRADA
*******************************************************************
FILE FILINP1.txt - informacion de cuenta
*******************************************************************
LONGITUD : 42 BYTES
CAMPOS   : 4

DE UN REGISTRO:
000301000000000001644547751198116501
ENTRADA ESPERADA:
  ACC-COD-ENT: 0003
  ACC-CENT-ALTA: 0100
  ACC-NUMB: 000000000164
  ACC-PAN: 4547751198116501

*******************************************************************
FILE FILINP2.txt - informacion tarjeta
*******************************************************************
LONGITUD : 50 BYTES
CAMPOS   : 7

DE UN REGISTRO:
4390460000127007      011913.11.20209805.09.201650
ENTRADA ESPERADA:
  INF-PAN: 4390460000127007
  INF-COD-MAR: 01
  INF-IND-TIP: 19
  INF-FEC-BAJ: 13.11.2020
  INF-MOT-BAJ: 98
  INF-FEC-BLOQ: 05.09.2016
  INF-COD-BLOQ: 50

*******************************************************************
                        ARCHIVOS DE SALIDA
*******************************************************************
FILE FILOUT1.txt
*******************************************************************
Solo tarjeta Visa o con CODIGO DE MARCA = 01 o INF-COD-MAR = 01
Escribir en DESCRIPCION DE BLOQUEO "TARJETA ACTIVA" => en VIS-DES-BLOQ
si INF-COD-BLOQ = 00

LONGITUD : 106 BYTES
CAMPOS   : 7

SALIDA ESPERADA:
  VIS-COD-ENT: 0003
  VIS-CENT-ALTA: 0987
  VIS-NUMB: 000000000520
  VIS-PAN: 4390460000127007
  VIS-DES-MAR: VISA
  VIS-FEC-BLOQ: 05.09.2016
  VIS-DES-BLOQ: BLOQUEO TARJETA POR ROBO

*******************************************************************
FILE FILOUT2.txt
*******************************************************************
Reporte de cuentas bloqueadas o con CODIGO DE BLOQUEO != 00
mejor dicho INF-COD-BLOQ != 00
Hace un mes atras hasta la fecha actual

Usar:
INTEGER-OF-DATE: FUNCION PARA CONVERTIR FECHA A ENTERO Y HACER EL CALCULO

LONGITUD : 68 BYTES
CAMPOS   : 4
REGISTRO ENTRADA 2: 4547751253080048      010101.01.0001  02.05.202557
REGISTRO ENTRADA 1: 000301000000028842344547751253080048

SALIDA ESPERADA:
  REP-NUMB: 000002884234
  REP-PAN: 4547751253080048
  REP-FEC-BLOQ: 02/05/2025
  REP-DES-BLOQ: BLOQUEO REEMISION REZAGO


*******************************************************************
                      LOGICA DE PROCESAMIENTO
*******************************************************************
- DEFINIR VARIABLES PARA EL MANEJO DE FECHAS
- DEFINIR UNA TABLA (VARIABLE) OCCURS ALMACENADA POR INDICE PARA FILINP1
- OBTENER FECHA ACTUAL  Y CALCULAR FECHA HACE UN MES USANDO LA FUNCION INTERGER-OF-DATE Y DATE-OF-INTEGER
- ABRIR LOS ARCHIVOS
- CARGAR REGISTROS DE FILINP1 A TABLA OCCURS INDEXADA
- LEER FILINP2
- BUSQAR POR PAN EN TABLA OCCURS
  SI HAY UN MATCH EVALUAR PARA FILOUT1
  -> CONDICION: SI EL CODIGO DE MARCA ES IGUAL A 01  
  -> OBTENER DESCRICION DE MARCA Y BLOQUEO
  -> MOVER OTROS DATOS
  -> ESCRIBIR 
  SI HAY UN MATCH EVALUAR PARA FILOUT2  
  ->  PRIMERA CONDICION: CODIGO DE BLOQUE != 00 
  ->  SEGUNDA CONDICION: QUE LA FECHA-HACE-UN-MES <= FECHA DE BLOQUEO <= FECHA ACTUAL (HOY)  
  -> FORMATEAR FECHA DE BLOQUEO DE DD.MM.YYYY A DD/MM/YYYY
  -> OBTENER DESCRICION BLOQUEO
  -> MOVER OTROS DATOS
  -> ESCRIBIR 

*******************************************************************
                           POSIBLES MEJORAS
*******************************************************************

- HACER UN PERFORM VARYING EN PARRAFO 3200-BUSCAR-CUENTA-POR-PAN


*******************************************************************
                           PENDIENTES
*******************************************************************
- PROGRAMAR UN JOB EN JCL EN MAINFRAME Y EJECUTAR LA RUTINA
- PASAR COMO VARIABLE LA LONGITUD DE REGISTROS DEL ARCHIVO CUENTA DE TARJETA O FILINP1 CON JCL PARA NO TENER QUE HACER MANUALMENTE EN EL OCCURS

