      *Obtener fecha y hora del sistema
      *    ACCEPT FECHA-SIS FROM DATE YYYYMMDD
      *    ACCEPT HORA-SIS  FROM TIME
        
      *Parsear la fecha
      *    MOVE FECHA-SIS(7:2) TO OUT-DIA      *> Día: posición 7-8
      *    MOVE FECHA-SIS(5:2) TO OUT-MES      *> Mes: posición 5-6
      *    MOVE FECHA-SIS(1:2) TO OUT-SIG.   *> Siglo: posición 1-2
      *    MOVE FECHA-SIS(3:4) TO OUT-ANO      *> Año: posición 3-4
      
      *Parsear la hora
      *    MOVE HORA-SIS(1:2) TO HH
      *    MOVE HORA-SIS(3:2) TO MM
      *    MOVE HORA-SIS(5:2) TO SS.

      * WITH USTRING AND FUNCTION CURRENT-DATE
           UNSTRING FUNCTION CURRENT-DATE
           INTO OUT-SIGANO OUT-MES OUT-DIA
           HH MM SS
           END-UNSTRING.