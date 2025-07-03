************************************************************************
******* 512972 16/05/25 ARC HOMOLOGACIÓN DE CAMPOS PARA TERADATA       *
******* 413119 16/12/24 TEC INNOMINADAS-INTERFAZ DATA REPORTERIA FASE 2*
*OBJET******************************************************************
*OBJET*** MATCHING X PAN INNOMINADA                                    *
*OBJET******************************************************************

       IDENTIFICATION DIVISION.
      *========================*
       PROGRAM-ID.    CDCB14Q.
       AUTHOR.        OLSSA.
       DATE-WRITTEN.  DIC 2024.

       ENVIRONMENT DIVISION. 
      *======================*
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT  FTOTT09I ASSIGN TO 'FTOTT09I.dat'
      *       ORGANIZATION IS LINE SEQUENTIAL
              FILE STATUS IS FS-FTOTT09I.

           SELECT  FFECACTI ASSIGN TO 'FFECACTI.dat'
      *       ORGANIZATION IS LINE SEQUENTIAL
              FILE STATUS IS FS-FFECACTI.

           SELECT  FECACTVO ASSIGN TO 'FECACTVO.dat'
      *       ORGANIZATION IS LINE SEQUENTIAL
              FILE STATUS IS FS-FECACTVO.

      *=============*
       DATA DIVISION.
      *=============*
      *=============*
       FILE SECTION.
      *=============*
      *SOLICITUDES PROCESADAS(ESTADO 1)
       FD  FTOTT09I
      *    LABEL RECORD IS OMITTED
      *    BLOCK CONTAINS 0 RECORDS
      *    RECORDING MODE IS F
           .
       01 REG-DATAREPO.
           COPY CDCFDREP.
           02 CDC-NUMPLAST       PIC 9(12).
           02 CDC-NUMBEN         PIC 9(05).

       FD  FFECACTI
      *    LABEL RECORD IS OMITTED
      *    BLOCK CONTAINS 0 RECORDS
      *    RECORDING MODE IS F
           .
       01  REG-FFECACTI.
           02 CDC-FECACTI        PIC X(08).
           02 CDC-PANINNO        PIC X(21).

       FD  FECACTVO
      *    TO DATA WITH LABELS OR HEADERS -> OMITTED, DATA
      *    LABEL RECORD IS OMITTED
      *    COUNT RECORDS CONTAIN -> PERFORMANCE - GROUP
      *    BLOCK CONTAINS 0 RECORDS
      *    REGISTER FIXED LENGTH -> V = VARIABLE, U = UNDEFINED
      *    RECORDING MODE IS F
           .
       01  REG-SALIDA.
      *    Replace CDC prefix by REP
           COPY CDCFDREP REPLACING LEADING ==CDC== BY ==REP==.
           02 REP-NUMPLAST        PIC 9(12).
           02 REP-NUMBEN          PIC 9(05).
           02 REP-LINEVENT        PIC X(02).

      *========================*
       WORKING-STORAGE SECTION.
      *========================*
       01 WSV-VARIABLES.
           05 WSV-FSTATUS         PIC  9(02)  VALUE ZEROS.
           05 WSV-RUTINA          PIC  X(18)  VALUE SPACES.
           05 WSV-ACCION          PIC  X(18)  VALUE SPACES.

       01 WSF-FSTATUS.
           05 FS-FTOTT09I         PIC  X(02)  VALUE '00'.
           05 FS-FFECACTI         PIC  X(02)  VALUE '00'.
           05 FS-FECACTVO         PIC  X(02)  VALUE '00'.
512972     05 WS-MATCH            PIC  X      VALUE ' '.
512972        88 SW-MATCH-SI                  VALUE 'S'.
512972     05 WS-NO-MATCH         PIC  X      VALUE ' '.
512972        88 SW-NO-MATCH-SI               VALUE 'S'.
512972*    05 WS-GRABAR         PIC  X     VALUE ' '.
512972*       88 SW-GRABAR-SI             VALUE 'S'.

       01 WSC-COSTANTES.
           05 WSC-10              PIC  9(02)  VALUE 10.
           05 WSC-00              PIC  9(02)  VALUE 00.
           05 WSC-16              PIC  9(02)  VALUE 16.

       01 WSA-ACUMULADORES.
           05 WSV-CONT-ACFI1      PIC  9(07) COMP VALUE ZEROS.
           05 WSV-CONT-ACFI2      PIC  9(07) COMP VALUE ZEROS.
           05 WSV-CONT-ACFO1      PIC  9(07) COMP VALUE ZEROS.

       01 WSS-SWITCH.
           05 WS-FIN-FTOTT09I     PIC  9(01)  VALUE 0.
              88 FIN-FTOTT09I-OK              VALUE 1.
           05 WS-FIN-FFECACTI     PIC  9(01)  VALUE 0.
              88 FIN-FFECACTI-OK              VALUE 1.

       01 FEC-ACT1             PIC X(10)       VALUE "ACTIVACION".
       01 FEC-ACT2             PIC X(10)       VALUE ALL SPACES.
       01 FEC-SPAC             PIC X(8)        VALUE ALL SPACES.

       01 TIP-VEN1            PIC X(02)       VALUE "P".
       01 TIP-VEN2            PIC X(02)       VALUE "NP".

      *-----------------------+
      * VARAIBLES DE FECHAS   +
      *-----------------------+
       COPY COMWTIME.

       01 OUT-DATE.
          02 OUT-DIA             PIC 9(02).
          02 FILLER              PIC X(01)   VALUE '/'.
          02 OUT-MES             PIC 9(02).
          02 FILLER              PIC X(01)   VALUE '/'.
          02 OUT-SIGANO.
             04 OUT-SIG          PIC 9(02).
             04 OUT-ANO          PIC 9(02).

       01 HORAMVS.
          05 HH                  PIC 9(02).
          05 FILLER              PIC X(01)   VALUE ':'.
          05 MM                  PIC 9(02).
          05 FILLER              PIC X(01)   VALUE ':'.
          05 SS                  PIC 9(02).

      *    COPY COMWUPSI.
      *----------------------------------------------------------------*
      *=================*
       LINKAGE SECTION.
      *=================*
      *     COPY COMWLUPS.
      *----------------------------------------------------------------*
      *===============================*
      *PROCEDURE DIVISION USING LKUPSI.
       PROCEDURE DIVISION.
      *===============================*
           PERFORM 1000-INICIO-PROGRAMA
           PERFORM 2000-PROCESO-PROGRAMA
           PERFORM 3000-FIN-PROGRAMA.
      *----------------------------------------------------------------*
      *====================*
       1000-INICIO-PROGRAMA.
      *====================*
           PERFORM 1001-OPEN-FILES
           PERFORM 1003-READ-FTOTT09I
           PERFORM 1002-READ-FFECACTI
           PERFORM 1004-OBTENER-FECHA.
      *----------------------------------------------------------------*
      *===============*
       1001-OPEN-FILES.
      *===============*

           OPEN INPUT FTOTT09I FFECACTI
                OUTPUT FECACTVO

           IF (FS-FTOTT09I = '00' OR '97') AND
              (FS-FFECACTI = '00' OR '97') AND
              (FS-FECACTVO = '00' OR '97')
              CONTINUE
           ELSE
              DISPLAY ' ERROR AL ABRIR ARCHIVOS  '
              DISPLAY ' FS-FTOTT09I ............. = ' FS-FTOTT09I
              DISPLAY ' FS-FFECACTI ............. = ' FS-FFECACTI
              DISPLAY ' FS-FECACTVO ............. = ' FS-FECACTVO
              PERFORM  9000-ERROR-PGM
           END-IF.

      *----------------------------------------------------------------*
      *===================*
       1003-READ-FTOTT09I.
      *===================*
           READ FTOTT09I
           AT END
              SET FIN-FTOTT09I-OK TO TRUE
              MOVE '9999999999999999999999' TO CDC-PAN
           END-READ.
           EVALUATE FS-FTOTT09I
           WHEN WSC-00
                ADD 1 TO WSV-CONT-ACFI1
           WHEN WSC-10
                SET FIN-FTOTT09I-OK TO TRUE
           WHEN OTHER
                MOVE '1003-READ-FTOTT09I' TO WSV-RUTINA
                MOVE 'READ FTOTT09I' TO WSV-ACCION
                MOVE FS-FTOTT09I TO WSV-FSTATUS
                PERFORM 9000-ERROR-PGM
           END-EVALUATE.
           
      *----------------------------------------------------------------*
      *===================*
       1002-READ-FFECACTI.
      *==================*
           READ FFECACTI
           AT END
              SET FIN-FFECACTI-OK TO TRUE
              MOVE '9999999999999999999999' TO CDC-PANINNO
           NOT AT END
              ADD 1 TO WSV-CONT-ACFI2
           END-READ.
           EVALUATE FS-FFECACTI
           WHEN WSC-00
                ADD 1 TO WSV-CONT-ACFI2
           WHEN WSC-10
                SET FIN-FFECACTI-OK TO TRUE
           WHEN OTHER
                MOVE '1002-READ-FFECACTI' TO WSV-RUTINA
                MOVE 'READ FFECACTI' TO WSV-ACCION
                MOVE FS-FFECACTI TO WSV-FSTATUS
                PERFORM 9000-ERROR-PGM
           END-EVALUATE.
      *----------------------------------------------------------------*
      *===================*
       1004-OBTENER-FECHA.
      *==================*
           COPY COMLUPSI.
      *    COPY COMLTIME.
       
      *--- HORA Y FECHA DEL SISTEMA
           DISPLAY 'HORA  DEL SISTEMA : ' HORAMVS
           DISPLAY 'FECHA DEL SISTEMA : ' OUT-DATE.
      *----------------------------------------------------------------*
      *=====================*
       2000-PROCESO-PROGRAMA.
      *=====================*
           PERFORM 2001-MATCHING-X-PAN UNTIL FIN-FTOTT09I-OK.
      *----------------------------------------------------------------*

      *=================*
       2001-MATCHING-X-PAN.
      *=================*
           MOVE SPACES TO WS-MATCH
           MOVE SPACES TO WS-NO-MATCH
512972*    MOVE SPACES TO WS-GRABAR
      *    DISPLAY "VALUE CDC-PAN: " CDC-PAN 
      *    DISPLAY "VALUE CDC-PANINNO: " CDC-PANINNO 
           
           EVALUATE TRUE
           WHEN CDC-PAN = CDC-PANINNO
                SET SW-MATCH-SI TO TRUE
512972*         SET SW-GRABAR-SI TO TRUE
                DISPLAY "IS EQUAL" 
                PERFORM 2002-MOVER-DATOS
                PERFORM 1003-READ-FTOTT09I
                PERFORM 1002-READ-FFECACTI
           WHEN CDC-PAN < CDC-PANINNO
                SET SW-NO-MATCH-SI TO TRUE
512972*         SET SW-GRABAR-SI TO TRUE
                PERFORM 2002-MOVER-DATOS
                PERFORM 1003-READ-FTOTT09I
           WHEN CDC-PAN > CDC-PANINNO
512972*         SET SW-NO-MATCH-SI TO TRUE
512972*         SET SW-GRABAR-SI TO TRUE
512972*         PERFORM 2002-MOVER-DATOS
                PERFORM 1002-READ-FFECACTI
           END-EVALUATE.
      *----------------------------------------------------------------*
      *==================*
       2002-MOVER-DATOS.
      *==================*
           INITIALIZE REG-SALIDA
           MOVE REG-DATAREPO TO REG-SALIDA

           IF SW-MATCH-SI
                MOVE CDC-FECACTI  TO REP-FEC-ACUSE-TAR
                MOVE FEC-ACT1     TO REP-TEC-TARJ
                MOVE TIP-VEN2     TO REP-LINEVENT
512972          PERFORM 2004-GRABAR-SALIDA
           END-IF
           IF SW-NO-MATCH-SI
                MOVE TIP-VEN1 TO REP-LINEVENT
                MOVE FEC-ACT2 TO REP-TEC-TARJ
                MOVE FEC-SPAC TO REP-FEC-ACUSE-TAR
512972          PERFORM 2004-GRABAR-SALIDA
           END-IF
512972*    IF SW-GRABAR-SI
512972*         PERFORM 2004-GRABAR-SALIDA
512972*    END-IF
           .
      *----------------------------------------------------------------*
      *==================*
       2004-GRABAR-SALIDA.
      *==================*
           WRITE REG-SALIDA
           IF FS-FECACTVO NOT = '00'
              MOVE '2003-SAVE-FECACTVO   ' TO WSV-RUTINA
              MOVE 'WRITE REG-FECACTVO   ' TO WSV-ACCION
              MOVE FS-FECACTVO TO WSV-FSTATUS
              PERFORM 9000-ERROR-PGM
           END-IF
           ADD 1 TO WSV-CONT-ACFO1.
      *----------------------------------------------------------------*
      *=================*
       3000-FIN-PROGRAMA.
      *=================*
           PERFORM 3001-CLOSE-FILES
           PERFORM 3002-CARGA-DETALLES
           STOP RUN.
      *----------------------------------------------------------------*
      *================*
       3001-CLOSE-FILES.
      *================*
           CLOSE FTOTT09I FFECACTI FECACTVO

           IF (FS-FTOTT09I = '00') AND
              (FS-FFECACTI = '00') AND
              (FS-FECACTVO = '00')
              CONTINUE
           ELSE
              DISPLAY ' ERROR AL ABRIR ARCHIVOS  '
              DISPLAY ' FS-FTOTT09I ............. = ' FS-FTOTT09I
              DISPLAY ' FS-FFECACTI ............. = ' FS-FFECACTI
              DISPLAY ' FS-FECACTVO ............. = ' FS-FECACTVO
              PERFORM  9000-ERROR-PGM
           END-IF.
      *----------------------------------------------------------------*
      *===================*
       3002-CARGA-DETALLES.
      *===================*
           DISPLAY '================================='
           DISPLAY '------- DETALLES PROCESO --------'
           DISPLAY '-------     CDCB14Q      --------'
           DISPLAY '================================='
           DISPLAY 'REG. LEIDOS FTOTT09I = ' WSV-CONT-ACFI1
           DISPLAY 'REG. LEIDOS FFECACTI = ' WSV-CONT-ACFI2
           DISPLAY 'REG. GRABAD FECACTVO = ' WSV-CONT-ACFO1
           DISPLAY '================================='
           MOVE WSC-00 TO RETURN-CODE
           DISPLAY '================================='
           DISPLAY '--------- FIN DETALLES ----------'
           DISPLAY '================================='.
      *----------------------------------------------------------------*
      *==============*
       9000-ERROR-PGM.
      *==============*
           DISPLAY '================================'
           DISPLAY '------ DETALLES DE ERROR -------'
           DISPLAY '------      CDCB14Q      -------'
           DISPLAY '================================'
           DISPLAY ' RUTINA          :' WSV-RUTINA
           DISPLAY ' ACCION DE ERROR :' WSV-ACCION
           DISPLAY ' CODIGO DE ERROR :' WSV-FSTATUS
           DISPLAY '================================'
           DISPLAY '--------- FIN DETALLES ---------'
           DISPLAY '================================'
           MOVE WSC-16 TO RETURN-CODE

           STOP RUN.
      *----------------------------------------------------------------*
