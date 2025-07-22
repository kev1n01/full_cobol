           EVALUATE INF-COD-MAR
               WHEN 01 
                 MOVE 'VISA' TO WS-DES-MARCA
               WHEN 02 
                 MOVE 'AMERICAN EXPRESS' TO WS-DES-MARCA
               WHEN 03 
                 MOVE 'MARCA PRIVADA' TO WS-DES-MARCA
               WHEN 04 
                 MOVE 'MASTERCARD' TO WS-DES-MARCA
           END-EVALUATE.

