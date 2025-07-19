*******************************************************************
                        ARCHIVOS DE ENTRADA:
*******************************************************************
FILE FILINP1.txt - informacion de cuenta
*******************************************************************
LONGITUD : 42 BYTES
CAMPOS   : 4

CODENT | CENTALTA | CUENTA      | PAN
0003   |  0100    | 00000000016 | 44547751198112559

*******************************************************************
FILE FILINP2.txt - informacion tarjeta
*******************************************************************
LONGITUD : 50 BYTES
CAMPOS   : 7

PAN    X22            |CODMAR|INDTIP| FECBAJA   |MOTBAJA|  FECBLOQ |CODBLOQ
4547751253262745      |  01  |  01  | 01.01.0001|   XX  |01.01.0001|00




*******************************************************************
                        ARCHIVOS DE SALIDA:
*******************************************************************
FILE FILOUT1.txt
*******************************************************************
SOlo tarjeta Visa o con CODMARCA 01
Escribir en DESCRIP BLOQUEO "TARJETA ACTIVA" si es 00

LONGITUD : 106 BYTES
CAMPOS   : 7

CODENT | CENTALTA | CUENTA | PAN | DESMAR | FECBLOQ | DESBLOQ
X4     |  X4      | X12    | X16 |  X30   |    X10  | X30

*******************************************************************
FILE FILOUT2.txt
*******************************************************************
Reporte de cuentas bloqueadas o con CODIGO DE BLOQUEO != 00
Hace un mes atras hasta la fecha actual


LONGITUD : 68 BYTES
CAMPOS   : 4

CUENTA | PAN  | FECBLOQ | DESBLOQ
X12    | X16  |    X10  | X30
