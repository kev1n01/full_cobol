       IDENTIFICATION DIVISION.
       PROGRAM-ID.  PROGRAM1.
       AUTHOR. KEVIN ARNOLD. 
       
       ENVIRONMENT DIVISION. 
       INPUT-OUTPUT SECTION.
       FILE-CONTROL. 
      *    ARCHIVO DE ENTRADA DE CUENTA DE TARJETA
           SELECT FILINP1 ASSIGN TO 'FILINP1.txt' 
              ORGANIZATION IS LINE SEQUENTIAL
                FILE STATUS IS FS-FILINP1.
      *    ARCHIVO DE ENTRADA DE INFORMACION DE TARJETA
           SELECT FILINP2 ASSIGN TO 'FILINP2.txt' 
              ORGANIZATION IS LINE SEQUENTIAL
                FILE STATUS IS FS-FILINP2.
      *    ARCHIVO DE SALIDA DE SOLO TARJETAS VISA
           SELECT FILOUT1 ASSIGN TO 'FILOUT1.txt'
              ORGANIZATION IS LINE SEQUENTIAL
              FILE STATUS IS FS-FILOUT1.
      *    ARCHIVO DE SALIDA DE REPORTE DE CUENTAS BLOQUEADAS 
      *    DE HACE UN MES HASTA LA FECHA 
           SELECT FILOUT2 ASSIGN TO 'FILOUT2.txt'
              ORGANIZATION IS LINE SEQUENTIAL
              FILE STATUS IS FS-FILOUT2.

       DATA DIVISION.
       FILE SECTION. 
       FD  FILINP1.
       01  REG-IN01.
           02 ACC-COD-ENT       PIC X(4). *> CODIO DE ENTIDAD
           02 ACC-CENT-ALTA     PIC X(4). *> CENTRO DE ALTA
           02 ACC-NUMB          PIC X(12). *> CUENTA
           02 ACC-PAN           PIC X(22). *> NUMERO TARJETA (PAN)
           
       FD  FILINP2.
       01  REG-IN02.
           02 INF-PAN          PIC X(22). *> NUMERO TARJETA (PAN)
           02 INF-COD-MAR      PIC 9(2). *> CODIGO DE MARCA
           02 INF-IND-TIP      PIC 9(2). *> INDICE DE TIPO
           02 INF-FEC-BAJ      PIC X(10). *> FECHA DE BAJA
           02 INF-MOT-BAJ      PIC X(2). *> MOTIVO DE BAJA
           02 INF-FEC-BLOQ     PIC X(10). *> FECHA DE BLOQUEO
           02 INF-COD-BLOQ     PIC 9(2). *> CODIGO DE BLOQUEO

       FD  FILOUT1.
       01  REG-OU01.
           02 VIS-COD-ENT       PIC X(4). *> CODIO DE ENTIDAD
           02 VIS-CENT-ALTA     PIC X(4). *> CENTRO DE ALTA
           02 VIS-NUMB          PIC X(12). *> CUENTA
           02 VIS-PAN           PIC X(16). *> NUMERO TARJETA (PAN)
           02 VIS-DES-MAR       PIC X(30). *> DESCRIPCION DE MARCA
           02 VIS-FEC-BLOQ      PIC X(10). *> FECHA DE BLOQUEO
           02 VIS-DES-BLOQ      PIC X(30). *> DESCRIPCION DE BLOQUEO

       FD  FILOUT2.
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
           05 CONT-FILINP1      PIC  9(07) COMP VALUE ZEROS.
           05 CONT-FILINP2      PIC  9(07) COMP VALUE ZEROS.
           05 CONT-FILOUT1      PIC  9(07) COMP VALUE ZEROS.
           05 CONT-FILOUT2      PIC  9(07) COMP VALUE ZEROS.
       
      *VARIABLES PARA CONTROLAR FIN DE LECTURA
       01 EOFILINP1                       PIC X VALUE 'N'.
       01 EOFILINP2                       PIC X VALUE 'N'.
      
      * Variables auxiliares
       01 WS-DES-MARCA          PIC X(30).
       01 WS-DES-BLOQ           PIC X(30).
       01 WS-FEC-BLOQ           PIC 9(10).
           02 FQ-DIA             PIC 9(02).
           02 FILLER              PIC X(01)   VALUE '/'.
           02 FQ-MES             PIC 9(02).
           02 FILLER              PIC X(01)   VALUE '/'.
           02 FQ-ANO             PIC X(04).

      *VARIABLES PARA FECHA DE SALIDA FORMATO DD/MM/YYYY
       01 NOW-DATE.
           02 NOW-DIA             PIC 9(02).
           02 FILLER              PIC X(01)   VALUE '/'.
           02 NOW-MES             PIC 9(02).
           02 FILLER              PIC X(01)   VALUE '/'.
           02 NOW-ANO             PIC X(04).
       
      *VARABILES DE ENTEROS DE FECHA
       01 WS-HOY-YYYYMMDD       PIC 9(8).
       01 WS-HOY-INT            PIC S9(9) COMP VALUE 0.
       01 WS-LIM-INT            PIC S9(9) COMP VALUE 0.
       01 WS-BLOQ-INT           PIC S9(9) COMP VALUE 0.

      *  CONSTANTES PARA DESCRIPCION DE MARCA
       01 WS-MARCA-01           PIC X(30) VALUE 'VISA'.
       01 WS-MARCA-02           PIC X(30) VALUE 'AMERICAN EXPRESS'.
       01 WS-MARCA-03           PIC X(30) VALUE 'MARCA PRIVADA'.
       01 WS-MARCA-04           PIC X(30) VALUE 'MASTERCARD'.

       PROCEDURE DIVISION.
      *    PRCOESOS PARA FILTRO DE FECHA
           MOVE FUNCTION CURRENT-DATE(1:8) TO WS-HOY-YYYYMMDD.
           COMPUTE WS-HOY-INT = FUNCTION INTEGER-OF-DATE 
              (WS-HOY-YYYYMMDD).
           MOVE WS-HOY-YYYYMMDD(7:2) TO NOW-DIA.
           MOVE WS-HOY-YYYYMMDD(5:2) TO NOW-MES.
           MOVE WS-HOY-YYYYMMDD(1:4) TO NOW-ANO.

      *    ULTIMOS 30 DIAS
           COMPUTE WS-LIM-INT = WS-HOY-INT - 30.

           OPEN INPUT FILINP1 FILINP2 
                 OUTPUT FILOUT1 FILOUT2.

           PERFORM CARGAR-FILINP2.
           
           PERFORM LEER-FILINP1.
           
           PERFORM UNTIL EOFILINP1 = 'S'
               PERFORM PROCESAR-REGISTRO
               PERFORM LEER-FILINP1
           END-PERFORM.

           CLOSE FILINP1 FILINP2 FILOUT1 FILOUT2.
           PERFORM DISPLAY-DETAILS
           STOP RUN.
       
       LEER-FILINP1.
           READ FILINP1
               AT END MOVE 'S' TO EOFILINP1
               NOT AT END ADD 1 TO CONT-FILINP1
           END-READ.

       CARGAR-FILINP2.
           PERFORM UNTIL EOFILINP2 = 'S'
              READ FILINP2
                 AT END MOVE 'S' TO EOFILINP2
                 NOT AT END
                    ADD 1 TO CONT-FILINP2
      *             ADD 1 TO WS-FILINP2-CNT
      *             MOVE REG-IN02 TO WS-FILINP2-ENTRY (WS-FILINP2-CNT)
              END-READ
           END-PERFORM.

       PROCESAR-REGISTRO.
      *FILTRO PARA OBTENER TARJETAS DE MARCA VISA
           EVALUATE INF-COD-MAR
              WHEN 01
                 PERFORM OBTENER-DESC-MARCA
      *          Desectructurando fecha de bloque en WS-FEC-BLOQ
                 UNSTRING INF-FEC-BLOQ DELIMITED BY "."
                    INTO FQ-DIA FQ-MES FQ-ANO
                 END-UNSTRING
                 PERFORM OBTENER-DESC-BLOQUEO
                 PERFORM GRABAR-FILOUT1
                 PERFORM OBTENER-BLOQ-MES
              WHEN OTHER
      *       FILTOR DE CUENTAS BLOQUEADAS
                 PERFORM OBTENER-BLOQ-MES
           END-EVALUATE.
       
       OBTENER-BLOQ-MES.
           IF WS-BLOQ-INT > 0
              AND WS-BLOQ-INT >= WS-LIM-INT
              AND WS-BLOQ-INT <= WS-HOY-INT
              AND WS-DES-BLOQ NOT = 'TARJETA ACTIVA'
              PERFORM GRABAR-FILOUT2
           END-IF.
       
       OBTENER-DESC-MARCA.
           EVALUATE INF-COD-MAR
              WHEN 01 MOVE WS-MARCA-01 TO WS-DES-MARCA
              WHEN 02 MOVE WS-MARCA-02 TO WS-DES-MARCA
              WHEN 03 MOVE WS-MARCA-03 TO WS-DES-MARCA
              WHEN 04 MOVE WS-MARCA-04 TO WS-DES-MARCA
              WHEN OTHER MOVE SPACES    TO WS-DES-MARCA
           END-EVALUATE.

       OBTENER-DESC-BLOQUEO.
           COPY EVDESBLOQ.
       
       GRABAR-FILOUT1.
           MOVE ACC-COD-ENT   TO VIS-COD-ENT
           MOVE ACC-CENT-ALTA TO VIS-CENT-ALTA
           MOVE ACC-NUMB      TO VIS-NUMB
           MOVE ACC-PAN(1:16) TO VIS-PAN
           MOVE WS-DES-MARCA  TO VIS-DES-MAR
           MOVE INF-FEC-BLOQ  TO VIS-FEC-BLOQ
           MOVE WS-DES-BLOQ TO VIS-DES-BLOQ
           WRITE REG-OU01
           ADD 1 TO CONT-FILOUT1.

       GRABAR-FILOUT2.
           MOVE ACC-NUMB      TO REP-NUMB
           MOVE ACC-PAN(1:16) TO REP-PAN
           MOVE INF-FEC-BLOQ  TO REP-FEC-BLOQ
           MOVE WS-DES-BLOQ TO REP-DES-BLOQ
           WRITE REG-OU02
           ADD 1 TO CONT-FILOUT2.

       DISPLAY-DETAILS.
           DISPLAY 'FECHA DE EJECUCION' NOW-DATE 
           DISPLAY '================================='
           DISPLAY '------- DETALLES PROCESO --------'
           DISPLAY '================================='
           DISPLAY 'REG. LEIDOS FILINP1 = ' CONT-FILINP1
           DISPLAY 'REG. LEIDOS FILINP2 = ' CONT-FILINP2
           DISPLAY 'REG. GRABAD FILOUT1 = ' CONT-FILOUT1
           DISPLAY 'REG. GRABAD FILOUT2 = ' CONT-FILOUT2
           DISPLAY '================================='
           DISPLAY '================================='
           DISPLAY '--------- FIN DETALLES ----------'
           DISPLAY '================================='.