      ******************************************************************
      *  Author: Kevin Arnold 
      *  Date: 23/06/2025
      *  Purpose: Tipos de datos
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. P0393.
       AUTHOR. KEVIN ARNOLD.
       DATE-WRITTEN. 23/06/2025.
              
       DATA DIVISION.       
       WORKING-STORAGE SECTION.
      ******************************************************************
      *NIVELES DE JERARQUIA PARA CADA CASO DE USO
      *01-49 TIENEN JERARQUI
      *66 SOLO PARA VARIABLES CON CLAUSULA RENAME
      *77 VARIABLES NO TIENEN JERARQUIA
      *88 PARA USAR EN CONDICIONALES
      ******************************************************************

      *VARIABLES POR TIPO DE DATO
       01 WS-STUDENT.
      *Alfanumericas
           03 WS-USERNAME        PIC X(10) VALUE "KEVAR12340".
      *Numéricas
           03 WS-AGE             PIC 9(3) VALUE 24.
           03 WS-CALIFICATION    PIC S9(2) VALUE -24.
           03 WS-WEIGHT          PIC 9(3)V9(2) VALUE 69.80.
      *Alfabeticas
           03 WS-PROFILE.
              05 WS-NAME         PIC A(12) VALUE "KEVIN ARNOLD".
              05 WS-FILLER1      PIC A(01) VALUE SPACES.
              05 WS-LAST-NAME    PIC A(14) VALUE "FLORES PACHECO".
      *CLAUSULA REDEFINE -> OJO SE REFEDINE JUSTO DESPUES DE DEFINIR LA VARIABLE A REDEFINIR Y DEBEN TENER EL MISMO NIVEL JERARQUICO
           03 WS-PROFILE-NAME REDEFINES WS-PROFILE PIC X(27).   
      
      *CLAUSULA RENAME -> USAR EL NIVEL 66 SIEMPRE
       66 WS-RENAME RENAMES WS-AGE THRU WS-WEIGHT.

      *CONSTANTES FIGURATIVAS
       01 WS-SPACES              PIC X(3) VALUE SPACES.
       01 WS-ZEROES              PIC X(3) VALUE ZEROES.

      *DATOS EMPAQUETADOS - MAXIMO 18 BYTES
      *EXISTE COMP2 COMP4 ...  PERO COMP Y COMP3 SON LOS MAS USADOS  
      *FORMATO COMP PARA ENTEROS
      *FORMATO COMP3 PARA DECIMALES
      *n = IMPAR -> SUMAR 1 Y DIVIDE 2 | PAR -> DIVIDE 2 Y SUMAR 1
       01 WS-COMPNUM             PIC S9(3) COMP.

      *DATOS EDITADOS O CONVERTIDOS A MONEDA $, CON COMAS Y SIN CEROS
       01 WS-WEIGHT-OUTPUT       PIC 9,999.99.
       01 WS-WEIGHT-NO-ZEROS     PIC Z,ZZZ.99.
       
       PROCEDURE DIVISION.
      *    MOVE EN ENTEROS Y DECIMALES
           MOVE WS-WEIGHT TO WS-WEIGHT-OUTPUT.
           MOVE WS-WEIGHT TO WS-WEIGHT-NO-ZEROS.
      *    MOVE EN ALFANUMERICOS
      
           DISPLAY 'Tipos de datos OK!'.
           DISPLAY WS-PROFILE-NAME.
           DISPLAY WS-SPACES.
           DISPLAY WS-ZEROES.
           DISPLAY WS-RENAME.
           DISPLAY WS-WEIGHT-OUTPUT.
           DISPLAY WS-WEIGHT-NO-ZEROS.
           STOP RUN.
       END PROGRAM P0393.


