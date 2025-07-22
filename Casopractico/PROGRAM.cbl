       IDENTIFICATION DIVISION.
       PROGRAM-ID.  PROGRAM1.
       AUTHOR. KEVIN ARNOLD.
       
       ENVIRONMENT DIVISION. 
       INPUT-OUTPUT SECTION.
       FILE-CONTROL. 
      *    ARCHIVO DE ENTRADA DE CUENTA DE TARJETA
           SELECT FILINP1 ASSIGN TO 'FILINP1.txt' 
              ORGANIZATION IS LINE SEQUENTIAL
              ACCESS MODE IS SEQUENTIAL
              FILE STATUS IS FS-FILINP1.
      *    ARCHIVO DE ENTRADA DE INFORMACION DE TARJETA
           SELECT FILINP2 ASSIGN TO 'FILINP2.txt' 
              ORGANIZATION IS LINE SEQUENTIAL
              ACCESS MODE IS SEQUENTIAL
              FILE STATUS IS FS-FILINP2.
      *    ARCHIVO DE SALIDA DE SOLO TARJETAS VISA
           SELECT FILOUT1 ASSIGN TO 'FILOUT1.txt'
              ORGANIZATION IS LINE SEQUENTIAL
              ACCESS MODE IS SEQUENTIAL
              FILE STATUS IS FS-FILOUT1.
      *    ARCHIVO DE SALIDA DE REPORTE DE CUENTAS BLOQUEADAS 
           SELECT FILOUT2 ASSIGN TO 'FILOUT2.txt'
              ORGANIZATION IS LINE SEQUENTIAL
              ACCESS MODE IS SEQUENTIAL
              FILE STATUS IS FS-FILOUT2.

       DATA DIVISION.
       FILE SECTION. 
       FD  FILINP1
           RECORDING MODE IS F.
       01  REG-IN01.
           02 ACC-COD-ENT       PIC X(4). *> CODIO DE ENTIDAD
           02 ACC-CENT-ALTA     PIC X(4). *> CENTRO DE ALTA
           02 ACC-NUMB          PIC X(12). *> CUENTA
           02 ACC-PAN           PIC X(22). *> NUMERO TARJETA (PAN)
           
       FD  FILINP2
           RECORDING MODE IS F.
       01  REG-IN02.
           02 INF-PAN          PIC X(22). *> NUMERO TARJETA (PAN)
           02 INF-COD-MAR      PIC 9(2). *> CODIGO DE MARCA
           02 INF-IND-TIP      PIC 9(2). *> INDICE DE TIPO
           02 INF-FEC-BAJ      PIC X(10). *> FECHA DE BAJA
           02 INF-MOT-BAJ      PIC X(2). *> MOTIVO DE BAJA
           02 INF-FEC-BLOQ     PIC X(10). *> FECHA DE BLOQUEO
           02 INF-COD-BLOQ     PIC 9(2). *> CODIGO DE BLOQUEO

       FD  FILOUT1
           RECORDING MODE IS F.
       01  REG-OU01.
           02 VIS-COD-ENT       PIC X(4). *> CODIO DE ENTIDAD
           02 VIS-CENT-ALTA     PIC X(4). *> CENTRO DE ALTA
           02 VIS-NUMB          PIC X(12). *> CUENTA
           02 VIS-PAN           PIC X(16). *> NUMERO TARJETA (PAN)
           02 VIS-DES-MAR       PIC X(30). *> DESCRIPCION DE MARCA
           02 VIS-FEC-BLOQ      PIC X(10). *> FECHA DE BLOQUEO
           02 VIS-DES-BLOQ      PIC X(30). *> DESCRIPCION DE BLOQUEO

       FD  FILOUT2
           RECORDING MODE IS F.
       01  REG-OU02.
           02 REP-NUMB          PIC X(12). *> CUENTA
           02 REP-PAN           PIC X(16). *> NUMERO TARJETA (PAN)
           02 REP-FEC-BLOQ      PIC X(10). *> FECHA DE BLOQUEO
           02 REP-DES-BLOQ      PIC X(30). *> DESCRIPCION DE BLOQUEO

       WORKING-STORAGE SECTION.
      *VARIABLES PARA SABER EL ESTADO DE LOS ARCHIVO
       01  WSF-STATUS.
           05  FS-FILINP1            PIC XX.
           05  FS-FILINP2            PIC XX.
           05  FS-FILOUT1            PIC XX.
           05  FS-FILOUT2            PIC XX.

      *VARIABLES PARA CONTAR REGISTROS DE ENTRADA Y SALIDA
       01 WSC-COUNTERS.
           05 COUNT-FILINP1      PIC  9(07) COMP VALUE ZEROS.
           05 COUNT-FILINP2      PIC  9(07) COMP VALUE ZEROS.
           05 COUNT-FILOUT1      PIC  9(07) COMP VALUE ZEROS.
           05 COUNT-FILOUT2      PIC  9(07) COMP VALUE ZEROS.
           05 COUNT-MATCHES      PIC  9(07) COMP VALUE ZEROS.
       
      *VARIABLES PARA CONTROLAR FIN DE LECTURA
       01 EOF-FLAGS.
           05 EOF-FILINP1                 PIC X VALUE 'N'.
           05 EOF-FILINP2                 PIC X VALUE 'N'.
      
      *VARIABLES AUXILIARES
       01 WS-VARIABLES.
           05 WS-DES-MARCA          PIC X(30).
           05 WS-DES-BLOQ           PIC X(30).
           05 WS-PAN-16             PIC X(16).
           05 WS-MATCH-FOUND        PIC X VALUE 'N'.

      *VARIABLES PARA MANEJO DE FECHAS
       01 WS-FECHA-ACTUAL.
           05 WS-FECHA-YYYYMMDD     PIC 9(8).
           05 WS-FECHA-REPORT.
               10 WR-DD             PIC 9(2).
               10 FILLER            PIC X VALUE '/'.
               10 WR-MM             PIC 9(2).
               10 FILLER            PIC X VALUE '/'.
               10 WR-YYYY           PIC 9(4).
      *    VARIABLES PARA MOSTRAR FECHA Y HORA ACTUAL - REFACTOR
           05 WS-FECHA-DISPLAY.
               10 WS-DD             PIC 9(2).
               10 FILLER            PIC X VALUE '/'.
               10 WS-MM             PIC 9(2).
               10 FILLER            PIC X VALUE '/'.
               10 WS-YYYY           PIC 9(4).
           05 WS-HORA-DISPLAY.
              10 HH                  PIC 9(02).
              10 FILLER              PIC X(01)   VALUE ':'.
              10 MM                  PIC 9(02).
              10 FILLER              PIC X(01)   VALUE ':'.
              10 SS                  PIC 9(02).

      *VARIABLES PARA ALMACENAR FECHAS ENTEROS
       01 WS-FECHA-BLOQ-NUM         PIC 9(8).
       01 WS-FECHA-UN-MES-ATRAS     PIC 9(8) COMP VALUE 0.

      *TABLA PARA ALMACENAR REGISTROS DE FILINP1 EN MEMORIA CON INDEX
       01 WS-TABLA-CUENTAS.
           05 WS-MAX-REGISTROS      PIC 9(7) COMP VALUE 1065248.
           05 WS-CANT-REGISTROS     PIC 9(7) COMP VALUE ZEROS.
           05 WS-CUENTAS OCCURS 1065248 TIMES INDEXED BY WS-IDX.
               10 WS-ACC-COD-ENT    PIC X(4).
               10 WS-ACC-CENT-ALTA  PIC X(4).
               10 WS-ACC-NUMB       PIC X(12).
               10 WS-ACC-PAN        PIC X(22).

       PROCEDURE DIVISION.
       0000-MAIN-PROCESS.
           PERFORM 1000-INICIALIZAR
           PERFORM 2000-CARGAR-TABLA-CUENTAS
           PERFORM 3000-PROCESAR-TARJETAS
           PERFORM 9000-FINALIZAR
           STOP RUN.

      *----------------------------------------------------------------+
       1000-INICIALIZAR.
      *----------------------------------------------------------------+
           DISPLAY '======================================='
           DISPLAY '  INICIANDO PROCESAMIENTO DE TARJETAS  '
           DISPLAY '======================================='
           PERFORM 1100-OBTENER-FECHA-ACTUAL
           PERFORM 1200-CALCULAR-FECHA-UN-MES
           PERFORM 1300-PREPARAR-ARCHIVOS.

      *----------------------------------------------------------------+
       1100-OBTENER-FECHA-ACTUAL.
      *----------------------------------------------------------------+
           COPY GDATETIME.

      *----------------------------------------------------------------+
       1200-CALCULAR-FECHA-UN-MES.
      *----------------------------------------------------------------+
      *    CALCULANDO FECHA DE HACE UN MES -> INTEGER-OF-DATE
      *    CONVIRTIENDO FECHA ACTUAL A ENTERO Y RESTANDOLE 30 DIAS
           COMPUTE WS-FECHA-UN-MES-ATRAS = 
               FUNCTION INTEGER-OF-DATE(WS-FECHA-YYYYMMDD) - 30
      *    CONVIRTIENDO ENTERO A FECHA
           COMPUTE WS-FECHA-UN-MES-ATRAS = 
               FUNCTION DATE-OF-INTEGER(WS-FECHA-UN-MES-ATRAS).

      *----------------------------------------------------------------+
       1300-PREPARAR-ARCHIVOS.
      *----------------------------------------------------------------+
           OPEN INPUT FILINP1 FILINP2 
           OPEN OUTPUT FILOUT1 FILOUT2
           IF FS-FILINP1 NOT = '00' OR FS-FILINP2 NOT = '00' OR
              FS-FILOUT1 NOT = '00' OR FS-FILOUT2 NOT = '00'
               DISPLAY 'ERROR AL ABRIR ARCHIVOS'
               STOP RUN
           END-IF.

      *----------------------------------------------------------------+
       2000-CARGAR-TABLA-CUENTAS.
      *----------------------------------------------------------------+
           DISPLAY '======================================='
           DISPLAY '       CARGANDO TABLA DE CUENTAS       '
           DISPLAY '======================================='
           PERFORM 2100-LEER-FILINP1
           PERFORM UNTIL EOF-FILINP1 = 'S' 
                       OR WS-CANT-REGISTROS >= WS-MAX-REGISTROS
               PERFORM 2200-GUARDAR-EN-TABLA
               PERFORM 2100-LEER-FILINP1
           END-PERFORM
           DISPLAY '======================================='
           DISPLAY '   CUENTAS CARGADAS: ' WS-CANT-REGISTROS
           DISPLAY '======================================='.

      *----------------------------------------------------------------+
       2100-LEER-FILINP1.
      *----------------------------------------------------------------+
           READ FILINP1
               AT END 
                 MOVE 'S' TO EOF-FILINP1
               NOT AT END 
                 ADD 1 TO COUNT-FILINP1
           END-READ.

      *----------------------------------------------------------------+
       2200-GUARDAR-EN-TABLA.
      *----------------------------------------------------------------+
           ADD 1 TO WS-CANT-REGISTROS
           SET WS-IDX TO WS-CANT-REGISTROS
           MOVE ACC-COD-ENT TO WS-ACC-COD-ENT(WS-IDX)
           MOVE ACC-CENT-ALTA TO WS-ACC-CENT-ALTA(WS-IDX)
           MOVE ACC-NUMB TO WS-ACC-NUMB(WS-IDX)
           MOVE ACC-PAN TO WS-ACC-PAN(WS-IDX).

      *----------------------------------------------------------------+
       3000-PROCESAR-TARJETAS.
      *----------------------------------------------------------------+
           DISPLAY '======================================='
           DISPLAY '  PROCESANDO INFORMACION DE TARJETAS   '
           DISPLAY '======================================='
           PERFORM 3100-LEER-FILINP2
           PERFORM UNTIL EOF-FILINP2 = 'S'
               PERFORM 3200-BUSCAR-CUENTA-POR-PAN
               IF WS-MATCH-FOUND = 'S'
                   PERFORM 3300-PROCESAR-MATCH
               END-IF
               PERFORM 3100-LEER-FILINP2
           END-PERFORM
      *    DISPLAY 'MATCHES ENCONTRADOS: ' COUNT-MATCHES
           .

      *----------------------------------------------------------------+
       3100-LEER-FILINP2.
      *----------------------------------------------------------------+
           READ FILINP2
               AT END 
                 MOVE 'S' TO EOF-FILINP2
               NOT AT END 
                 ADD 1 TO COUNT-FILINP2
           END-READ.
           
      *----------------------------------------------------------------+
       3200-BUSCAR-CUENTA-POR-PAN.
      *----------------------------------------------------------------+
           MOVE 'N' TO WS-MATCH-FOUND
           SET WS-IDX TO 1 *> REINICIA EL VALOR DEL INDICE A LA POS 1
           PERFORM UNTIL WS-IDX > WS-CANT-REGISTROS OR 
                         WS-MATCH-FOUND = 'S'
               IF INF-PAN = WS-ACC-PAN(WS-IDX)
                   MOVE 'S' TO WS-MATCH-FOUND
                   ADD 1 TO COUNT-MATCHES
               ELSE
                   SET WS-IDX UP BY 1 *> INCREMENTA EL INDICE +1 POS
               END-IF
           END-PERFORM.

      *----------------------------------------------------------------+
       3300-PROCESAR-MATCH.
      *----------------------------------------------------------------+
           PERFORM 3400-EVALUAR-PARA-FILOUT1
           PERFORM 3500-EVALUAR-PARA-FILOUT2.

      *----------------------------------------------------------------+
       3400-EVALUAR-PARA-FILOUT1.
      *----------------------------------------------------------------+
           IF INF-COD-MAR = 01
               PERFORM 3410-ESCRIBIR-FILOUT1
           END-IF.

      *----------------------------------------------------------------+
       3410-ESCRIBIR-FILOUT1.
      *----------------------------------------------------------------+
           PERFORM 4100-OBTENER-DESC-MARCA
           PERFORM 4200-OBTENER-DESC-BLOQUEO
          
           MOVE INF-PAN(1:16) TO WS-PAN-16 
           MOVE WS-ACC-COD-ENT(WS-IDX) TO VIS-COD-ENT
           MOVE WS-ACC-CENT-ALTA(WS-IDX) TO VIS-CENT-ALTA
           MOVE WS-ACC-NUMB(WS-IDX) TO VIS-NUMB
           MOVE WS-PAN-16 TO VIS-PAN
           MOVE WS-DES-MARCA TO VIS-DES-MAR   
           MOVE INF-FEC-BLOQ TO VIS-FEC-BLOQ 
           MOVE WS-DES-BLOQ TO VIS-DES-BLOQ   
           
           WRITE REG-OU01
           ADD 1 TO COUNT-FILOUT1.

      *----------------------------------------------------------------+
       3500-EVALUAR-PARA-FILOUT2.
      *----------------------------------------------------------------+
           IF INF-COD-BLOQ NOT = 00
               PERFORM 3510-VERIFICAR-FECHA-BLOQUEO
           END-IF.

      *----------------------------------------------------------------+
       3510-VERIFICAR-FECHA-BLOQUEO.
      *----------------------------------------------------------------+
           PERFORM 4300-CONVERTIR-FECHA-BLOQ-NUM
           
      *    VERIFICAR SI SE BLOQUEO HACE UN MES
           IF WS-FECHA-BLOQ-NUM >= WS-FECHA-UN-MES-ATRAS AND
              WS-FECHA-BLOQ-NUM <= WS-FECHA-YYYYMMDD
      *        DISPLAY "SE ENCONTRO BLOQUEO HACE UN MES"
               PERFORM 3520-ESCRIBIR-FILOUT2
           END-IF.
           
      *----------------------------------------------------------------+
       3520-ESCRIBIR-FILOUT2.
      *----------------------------------------------------------------+
           PERFORM 4200-OBTENER-DESC-BLOQUEO
           PERFORM 4400-FORMAT-FECHA-PARA-REPORTE
           
           MOVE INF-PAN(1:16) TO WS-PAN-16
           
           MOVE WS-ACC-NUMB(WS-IDX) TO REP-NUMB
           MOVE WS-PAN-16 TO REP-PAN 
           MOVE WS-FECHA-REPORT TO REP-FEC-BLOQ 
           MOVE WS-DES-BLOQ TO REP-DES-BLOQ   
           
           WRITE REG-OU02
           ADD 1 TO COUNT-FILOUT2.

      *----------------------------------------------------------------+
       4100-OBTENER-DESC-MARCA.
      *----------------------------------------------------------------+
           COPY EVDESMAR.

      *----------------------------------------------------------------+
       4200-OBTENER-DESC-BLOQUEO.
      *----------------------------------------------------------------+
           COPY EVDESBLOQ.

      *----------------------------------------------------------------+
       4300-CONVERTIR-FECHA-BLOQ-NUM.
      *----------------------------------------------------------------+
      *    DD.MM.YYYY -> YYYYMMDD
           MOVE ZEROS TO WS-FECHA-BLOQ-NUM
           IF INF-FEC-BLOQ NOT = SPACES AND INF-FEC-BLOQ NOT = ZEROS
               MOVE INF-FEC-BLOQ(7:4) TO WS-FECHA-BLOQ-NUM(1:4) *> YYYY
               MOVE INF-FEC-BLOQ(4:2) TO WS-FECHA-BLOQ-NUM(5:2) *> MM
               MOVE INF-FEC-BLOQ(1:2) TO WS-FECHA-BLOQ-NUM(7:2) *> DD
           END-IF.

      *----------------------------------------------------------------+
       4400-FORMAT-FECHA-PARA-REPORTE.
      *----------------------------------------------------------------+
      *    DD.MM.YYYY -> DD/MM/YYYY
           MOVE INF-FEC-BLOQ(1:2) TO WS-FECHA-REPORT(1:2) *> DD
           MOVE INF-FEC-BLOQ(4:2) TO WS-FECHA-REPORT(4:2) *> MM
           MOVE INF-FEC-BLOQ(7:4) TO WS-FECHA-REPORT(7:4). *> YYYY

      *----------------------------------------------------------------+
       9000-FINALIZAR.
      *----------------------------------------------------------------+
           PERFORM 9100-CERRAR-ARCHIVOS
           PERFORM 9200-MOSTRAR-DETALLES.

      *----------------------------------------------------------------+
       9100-CERRAR-ARCHIVOS.
      *----------------------------------------------------------------+
           CLOSE FILINP1 FILINP2 FILOUT1 FILOUT2.

      *----------------------------------------------------------------+
       9200-MOSTRAR-DETALLES.
      *----------------------------------------------------------------+
           DISPLAY ' '
           DISPLAY 'F/H EJECUCION: ' WS-FECHA-DISPLAY" "WS-HORA-DISPLAY
           DISPLAY '========================================='
           DISPLAY '             DETALLES PROCESO            '
           DISPLAY '========================================='
           DISPLAY 'REG. LEIDOS FILINP1 = ' COUNT-FILINP1
           DISPLAY 'REG. LEIDOS FILINP2 = ' COUNT-FILINP2
           DISPLAY 'REG. GRABAD FILOUT1 = ' COUNT-FILOUT1
           DISPLAY 'REG. GRABAD FILOUT2 = ' COUNT-FILOUT2
           DISPLAY 'MATCHES ENCONTRADOS = ' COUNT-MATCHES
           DISPLAY ' '.