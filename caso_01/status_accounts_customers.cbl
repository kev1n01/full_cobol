      ******************************************************************
      *  Author: Kevin Arnold 
      *  Date: 23/06/2025
      *  Purpose: Introduction
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PSA01.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MOVES ASSIGN TO 'movimientos.dat'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS MOVES-STATUS.
           SELECT BALANCES ASSIGN TO 'saldos.txt'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT NEGATIVES ASSIGN TO 'negativos.txt'
               ORGANIZATION IS LINE SEQUENTIAL.
           
       DATA DIVISION.
       FILE SECTION.
       FD MOVES.
       01 MOVE-REGISTER            PIC X(100).

       FD BALANCES.
       01 BALANCE-REGISTER         PIC X(100).
       
       FD NEGATIVES.
       01 NEGATIVE-REGISTER         PIC X(100).

       WORKING-STORAGE SECTION.
       01 MOVES-STATUS PIC XX.
      * COUNTERS
       01 COUNT-REGISTERS           PIC 9(5) VALUE 0.
       01 COUNT-NEGATIVES           PIC 9(5) VALUE 0.
      
      * FIELDS TEMPORALS
       01 ID-CLIENT                 PIC X(5).
       01 NAME-CLIENT               PIC X(20).
       01 TYPE-MOVE                 PIC X.
       01 AMOUNT-MOVE               PIC 9(5)V99.
       01 PREVIOUS-BALANCE          PIC 9(5)V99.
       01 NEW-BALANCE               PIC S9(6)V99.
       01 EOF                       PIC X VALUE 'N'.

       PROCEDURE DIVISION.
           OPEN INPUT MOVES
               OUTPUT BALANCES NEGATIVES
           
           PERFORM HASTA-FIN-ARCHIVO.
           CLOSE MOVES BALANCES NEGATIVES
           DISPLAY "ESTADO DE ARCHIVO MOVIMIENTO: " MOVES-STATUS
           DISPLAY "TOTAL PROCESADOS: " COUNT-REGISTERS
           DISPLAY "CUENTAS EN NEGATIVO: " COUNT-NEGATIVES
           STOP RUN.
           
       HASTA-FIN-ARCHIVO.
           PERFORM UNTIL EOF = 'Y'
               READ MOVES
                   AT END
                       MOVE 'Y' TO EOF
                   NOT AT END
                       PERFORM PROCCESS-REGISTER
               END-READ
           END-PERFORM.
       
       PROCCESS-REGISTER.
           ADD 1 TO COUNT-REGISTERS
           UNSTRING MOVE-REGISTER DELIMITED BY "|"
               INTO ID-CLIENT, NAME-CLIENT, TYPE-MOVE, AMOUNT-MOVE, 
                   PREVIOUS-BALANCE
           
           EVALUATE TYPE-MOVE
               WHEN "D"
                   ADD AMOUNT-MOVE TO PREVIOUS-BALANCE GIVING 
                       NEW-BALANCE
                   DISPLAY NEW-BALANCE
               WHEN "R"
                   SUBTRACT AMOUNT-MOVE FROM PREVIOUS-BALANCE GIVING 
                       NEW-BALANCE
                   DISPLAY NEW-BALANCE
               WHEN OTHER
                   DISPLAY "TIPO DE MOVIENDO DESCONOCIDO"
           END-EVALUATE
       
           STRING ID-CLIENT DELIMITED BY SIZE
               " | " DELIMITED BY SIZE
               NAME-CLIENT DELIMITED BY SIZE
               " | " DELIMITED BY SIZE
               NEW-BALANCE DELIMITED BY SIZE
               INTO BALANCE-REGISTER

           WRITE BALANCE-REGISTER
           
           IF NEW-BALANCE < 0
               ADD 1 TO COUNT-NEGATIVES
               STRING "ALERTA: Client " ID-CLIENT DELIMITED BY SIZE
                   " SALDO NEGATIVO: " DELIMITED BY SIZE
                   NEW-BALANCE DELIMITED BY SIZE
                   INTO NEGATIVE-REGISTER
               WRITE NEGATIVE-REGISTER
           END-IF.
       END PROGRAM PSA01.
