      ******************************************************************
      *  Author: Kevin Arnold 
      *  Date: 23/06/2025
      *  Purpose: Introduction
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. P0392.
       AUTHOR. KEVIN ARNOLD.
       DATE-WRITTEN. 23/06/2025.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       
       DATA DIVISION.
       FILE SECTION.       
       WORKING-STORAGE SECTION.
       01 WS-EDAD               PIC 9(2) VALUE 18.
       01 WS-NIVEL              PIC 9(1) VALUE 2.
       01 WS-ESTADO-CIVIL       PIC X(1) VALUE "S".
           88 SOLTERO           VALUE "S".
           88 CASADO            VALUE "C".
       01 WS-NOMBRE             PIC X(10) VALUE "TYRON".
       01 WS-ACTIVO             PIC X(1).
           88 ACTIVO            VALUE "Y".
           88 INACTIVO          VALUE "N".
       01 WS-CALIFICACION       PIC 9(2) VALUE 75.
       
       01 WS-NUM1               PIC S9 VALUE 5.
       01 WS-NUM2               PIC S9 VALUE -3.


       PROCEDURE DIVISION.
      *IF/ELSE CON NUMERICOS Y DE NOMBRE CON NIVEL 88
      *CONDICIONES COMPLEJAS CON AND, OR, NOT
       CONDITIONAL-IFELSE.
           IF WS-EDAD >= 18
               DISPLAY "Mayor de edad."
           ELSE
               DISPLAY "Menor de edad."
           END-IF
           
           MOVE 'Y' TO WS-ACTIVO.

           IF ACTIVO
               DISPLAY "Usuario activo"
           ELSE
               DISPLAY "Usuario inactivo".

           IF NOT CASADO OR WS-CALIFICACION < 60
               DISPLAY "No casado o calificación baja"
           END-IF.
           
           IF WS-EDAD >= 18 AND SOLTERO AND WS-NIVEL > 1
               DISPLAY "Adulto soltero con nivel superior a 1"
           END-IF.

      *EVALUATE CON TRUE, CON VARIABLE Y SIGNOS
       CONDITIONAL-EVALUATE.
           EVALUATE TRUE
               WHEN WS-EDAD < 13
                   DISPLAY "Niño"
               WHEN WS-EDAD < 18
                   DISPLAY "Adolescente"
               WHEN WS-EDAD <= 65
                   DISPLAY "Adulto"
               WHEN OTHER
                   DISPLAY "Adulto mayor"
           END-EVALUATE.

           EVALUATE WS-ESTADO-CIVIL
               WHEN "S"
                   DISPLAY "Soltero"
               WHEN "C"
                   DISPLAY "Casado"
               WHEN OTHER
                   DISPLAY "Otro estado"
           END-EVALUATE.

      *TYPE RELATIONS COMPARATIVASPALABRAS RESERVADAS Y 
      *CON SIMBOLOS >,<,<=,>=,=, NOT =
       CONDITIONAL-RELATIONS.
           IF WS-NUM1 IS GREATER THAN WS-NUM2
               DISPLAY WS-NUM1 " > "  WS-NUM2.

           IF WS-NUM1 IS LESS THAN OR EQUAL TO WS-NUM2
               DISPLAY WS-NUM1 " <= " WS-NUM2.

           IF WS-NUM1 IS POSITIVE
               DISPLAY WS-NUM1 " es positivo".

           IF WS-NUM2 IS NOT NEGATIVE
               DISPLAY WS-NUM2 " no es negativo"
           ELSE
              DISPLAY WS-NUM2 " es negativo"
           END-IF 

           IF WS-NUM2 IS NOT ZERO
               DISPLAY WS-NUM2 " no es cero".

           STOP RUN.
       END PROGRAM P0392.


