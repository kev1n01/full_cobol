      ******************************************************************
      *  Author: Kevin Arnold 
      *  Date: 23/06/2025
      *  Purpose: Expresiones aritmeticas
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. P0394.
       AUTHOR. KEVIN ARNOLD.
       DATE-WRITTEN. 23/06/2025.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       
       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
      *VARIABLES DE NUMERO CON VALOR POR DEFECTO
       01 WS-NUM1 PIC 9(3) COMP VALUE 423.
       01 WS-NUM2 PIC S9(3)V99 COMP VALUE 122.50.
       
      *VARIABLES TOTALES
       01 WS-TOTAL PIC S9(5)V99.

      *VARIABLES EDITADAS TOTALES
       01 WS-TOTAL-EDIT PIC ZZZZZ.99. *>QUITANTO CEROS SIN PERDER EL .00
       01 WS-TEXT-DISPLAY PIC A(100).
       PROCEDURE DIVISION.
      *SUMA -> ADD [VAR1] TO [VAR2] GIVING [VAR_RESULT]
       ADD-ACTION.
           ADD WS-NUM1 TO WS-NUM2 GIVING WS-TOTAL.
           MOVE WS-TOTAL TO WS-TOTAL-EDIT.
           DISPLAY WS-NUM1 " + " WS-NUM2 " es: "
              WS-TOTAL-EDIT.

      *RESTA -> SUBTRACT [VALUE-1] FROM [VAR_TOTAL]
       SUBTRACT-ACTION.
           SUBTRACT WS-NUM1 FROM WS-NUM2 GIVING WS-TOTAL.
           MOVE WS-TOTAL TO WS-TOTAL-EDIT.
           DISPLAY WS-NUM1 " - " WS-NUM2 " es: "
              WS-TOTAL-EDIT.
                                          
      *MULTIPLICACION -> MULTIPLY [VAR1] BY [VAR2] GIVING [VAR_RESULT]
       MULTIPLY-ACTION.
           MULTIPLY WS-NUM1 BY WS-NUM2 GIVING WS-TOTAL.
           MOVE WS-TOTAL TO WS-TOTAL-EDIT.
           DISPLAY WS-NUM1 " x " WS-NUM2 " es: " WS-TOTAL-EDIT.

      *DIVISION -> DIVIDE [VAR-DIVIDE] INTO [VAR2]
       DIVIDE-ACTION.
           DIVIDE WS-NUM2 INTO WS-NUM1 GIVING WS-TOTAL.
           MOVE WS-TOTAL TO WS-TOTAL-EDIT.
           DISPLAY WS-NUM1  " / " WS-NUM2 " es: " WS-TOTAL-EDIT.
       
      *COMPUTE -> COMPUTE NAME_COMPUTE = ADD,DIVISION,MULTUPLY,SUBSTRACT
       COMPUTE-ACTION.
           COMPUTE WS-TOTAL = (WS-NUM1 * WS-NUM2 ) / (WS-NUM2**2) - 20 
           MOVE WS-TOTAL TO WS-TOTAL-EDIT.
           DISPLAY "El resultado es: " WS-TOTAL-EDIT.
           
           STOP RUN.
       END PROGRAM P0394.


