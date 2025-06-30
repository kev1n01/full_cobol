      ******************************************************************
      *  Author: Kevin Arnold 
      *  Date: 23/06/2025
      *  Purpose: Introduction
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. P0395.
       AUTHOR. KEVIN ARNOLD.
       DATE-WRITTEN. 23/06/2025.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       
       DATA DIVISION.
       FILE SECTION.       
       WORKING-STORAGE SECTION.
       01 I                       PIC 9(2) VALUE 0.
       01 CONTADOR                PIC 9(2) VALUE 0.
       01 TOTAL                   PIC 9(4) VALUE 0.
       01 SUMANDO                 PIC 9(4) VALUE 10.
       01 CANT-REGISTRO           PIC 9(2) VALUE 5.
       01 SHOW-DISPLAY            PIC A(200).

       PROCEDURE DIVISION.
      *PERFORMS INLINE Y OUTLINE
           DISPLAY "==================================================".
           DISPLAY "PERFORM NORMAL INLINE Y OUTLINE".
           DISPLAY "==================================================".
           PERFORM
               DISPLAY "Mensaje desde PERFORM INLINE"
               DISPLAY "Este bloque no está en un párrafo"
           END-PERFORM.
           PERFORM MOSTRAR-MENSAJE.

           DISPLAY "==================================================".
           DISPLAY "PERFORM THRU".
           DISPLAY "==================================================".
           PERFORM INICIO THRU ULTIMO.
           
           DISPLAY "==================================================".
           DISPLAY "PERFORM TIMES".
           DISPLAY "==================================================".
           DISPLAY "Mostrando del 0-2:"
           PERFORM 3 TIMES 
              DISPLAY I 
              ADD 1 TO I
           END-PERFORM 
                     
           MOVE 0 TO I
           DISPLAY "Mostrando del 0-4:".
           PERFORM MOSTRAR-NUMERO 5 TIMES.

           DISPLAY "==================================================".
           DISPLAY "PERFORM UNTIL".
           DISPLAY "==================================================".
           MOVE 0 TO I.
           DISPLAY "Mostrando con PERFORM UNTIL hasta que I > 5 - 1".
           PERFORM UNTIL I > 5 - 1
               DISPLAY "I = " I
               ADD 1 TO I
           END-PERFORM.
           
           MOVE 0 TO I.
           DISPLAY " "
           DISPLAY "-----------------------"
           DISPLAY "| ID |       NAME     |"
           DISPLAY "-----------------------"
           PERFORM MOSTRAR-USUARIO UNTIL I > CANT-REGISTRO.

           DISPLAY "==================================================".
           DISPLAY "PERFORM VARYING".
           DISPLAY "==================================================".
           DISPLAY "Sumando múltiplos de 10 con PERFORM VARYING INL".
           MOVE 0 TO TOTAL
           PERFORM VARYING CONTADOR FROM 1 BY 1 UNTIL CONTADOR > 5
               COMPUTE TOTAL = TOTAL + SUMANDO * CONTADOR
               DISPLAY "Iteración " CONTADOR ": " TOTAL
           END-PERFORM.

           DISPLAY "Sumando múltiplos de 10 con PERFORM VARYING OUT".
           MOVE 0 TO TOTAL
           PERFORM PERFORM-MULTI VARYING CONTADOR 
              FROM 1 BY 1 UNTIL CONTADOR > 5.
           
           STOP RUN.

       MOSTRAR-MENSAJE.
           DISPLAY "Mensaje desde PERFORM INLINE"
           DISPLAY "Este bloque no está en un párrafo".

      *PERFORM THRU
       INICIO.
           DISPLAY "PERFORM THRU INICIO".
       MEDIO.
           DISPLAY "PERFORM THRU MEDIO".
       ULTIMO.
           DISPLAY "PERFORM THRU FINAL".

      *PERFORM TIMES 
       MOSTRAR-NUMERO.
           DISPLAY I
           ADD 1 TO I.
       
      *PERFORM VARYING 
       PERFORM-MULTI.
           COMPUTE TOTAL = TOTAL + SUMANDO * CONTADOR
           DISPLAY "Iteración " CONTADOR ": " TOTAL.
       
      *PERFORM UNTIL 
       MOSTRAR-USUARIO.
           ADD 1 TO I.
           STRING "| " I DELIMITED BY SIZE " | " DELIMITED BY 
              SIZE "RANDOM_NAME_" I " |" DELIMITED BY SIZE
              INTO SHOW-DISPLAY.
           DISPLAY SHOW-DISPLAY.

       END PROGRAM P0395.