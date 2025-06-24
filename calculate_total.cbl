      ******************************************************************
      *  Author: Kevin Arnold 
      *  Date: 23/06/2025
      *  Purpose: Calcular total aplicando descuento
      * Tectonics: cobc
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ORDER-DISCOUNT.
       AUTHOR. KEVIN ARNOLD.
       DATE-WRITTEN. 23/06/2025.                  
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION. 
       SPECIAL-NAMES. DECIMAL-POINT IS COMMA. *>Los numero decimales se separan con "," y ya no con "."
       INPUT-OUTPUT SECTION. 
       FILE-CONTROL.

       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
      *COMPANY VARIABLES
       01 COMPANY.
           05 COMPANY-NAME        PIC X(60) VALUE "Mopal SAC".
           05 COMPANY-ADDRESS. *> DETAIL ADDRESS
               10 STREET          PIC X(80) VALUE "CC KM. 15.".
               10 CITY.
                   15 CITY-NAME   PIC X(40) VALUE "Huánuco".
                   15 CITY-CODE   PIC x(3) VALUE "HCO".
                   15 POSTAL-CODE PIC 9(5) VALUE 10000.
      *PRODUCTS VARIABLES
       01 LINE-ITEM.
           05 ITEM                PIC X(20) VALUE "Aceite 10W-40".
           05 QUANTITY            PIC 999 VALUE 30.
           05 PRICE               PIC 9999V99 VALUE 39,95.
      *CALCULATION VARIABLES
       77 DISCOUNT-THRESHOLD      PIC 999999V99 VALUE 1111,11.
       77 DISCOUNT-PERCENT        PIC 99 VALUE 20.
       77 DISCOUNT-AMOUNT         PIC 99999999V99.
       77 TOTAL-AMOUNT            PIC 999999V99.
      *OUTPUT VARIABLES
       77 DISCOUNT-AMOUNT-OUTPUT   PIC $$$$$$9,99.
       77 TOTAL-FOR-OUTPUT        PIC $$$$$$9,99.
       77 SUB-TOTAL-FOR-OUTPUT    PIC $$$$$$9,99.

       PROCEDURE DIVISION.
       PERFORM-TASK.
            PERFORM COMPUTE-TOTAL.
            PERFORM DISPLAY-TOTAL.
            STOP RUN.

       COMPUTE-TOTAL.
           MULTIPLY QUANTITY BY PRICE GIVING TOTAL-AMOUNT.
           IF TOTAL-AMOUNT > DISCOUNT-THRESHOLD
             MULTIPLY TOTAL-AMOUNT BY DISCOUNT-PERCENT
                       GIVING DISCOUNT-AMOUNT
             DIVIDE 100 INTO DISCOUNT-AMOUNT
             SUBTRACT DISCOUNT-AMOUNT FROM TOTAL-AMOUNT.

       DISPLAY-TOTAL.
           MOVE TOTAL-AMOUNT TO TOTAL-FOR-OUTPUT.
           MOVE DISCOUNT-AMOUNT TO DISCOUNT-AMOUNT-OUTPUT.
           MULTIPLY QUANTITY BY PRICE GIVING TOTAL-AMOUNT.
           MOVE TOTAL-AMOUNT TO SUB-TOTAL-FOR-OUTPUT.
           DISPLAY "========================================"
           DISPLAY "           INFORMACION DE COMPRA        "
           DISPLAY "========================================"
           DISPLAY COMPANY-NAME
           DISPLAY STREET
           DISPLAY CITY-NAME
           DISPLAY CITY-CODE
           DISPLAY POSTAL-CODE
           DISPLAY "========================================"
           DISPLAY "Producto         :     " ITEM
           DISPLAY "Cantidad         :     " QUANTITY 
           DISPLAY "Precio           :     " PRICE
           DISPLAY "Sub Total        :   " SUB-TOTAL-FOR-OUTPUT
           IF DISCOUNT-AMOUNT > 0
              DISPLAY "% descuento      :     " DISCOUNT-PERCENT "%"
              DISPLAY "Total descuento  :  " DISCOUNT-AMOUNT-OUTPUT
              DISPLAY "Total a pagar    :  " TOTAL-FOR-OUTPUT
              DISPLAY "========================================".
       END PROGRAM ORDER-DISCOUNT.