            EVALUATE INF-COD-BLOQ
               WHEN 01 
                 MOVE 'BLOQ. CUENTA TEMP. S/RETENC.' TO WS-DES-BLOQ
               WHEN 02 
                 MOVE 'BLOQ. CUENTA TEMP. C/RETENC.' TO WS-DES-BLOQ
               WHEN 03 
                 MOVE 'BLOQUEO MOROSIDAD TEMPORAL' TO WS-DES-BLOQ
               WHEN 04 
                 MOVE 'BLOQUEO MOROSIDAD DEFINITIVA' TO WS-DES-BLOQ
               WHEN 06 
                 MOVE 'BLOQUEO POR REFINANCIADO' TO WS-DES-BLOQ
               WHEN 07 
                 MOVE 'BLOQ. POR GIRO CHEQUE S/FONDOS' TO WS-DES-BLOQ
               WHEN 08 
                 MOVE 'BLOQUEO PASE A PRE JUDICIAL' TO WS-DES-BLOQ
               WHEN 09 
                 MOVE 'BLOQUEO MANUAL DEFINITIVO' TO WS-DES-BLOQ
               WHEN 10 
                 MOVE 'BLOQUEO POR COLATERALES' TO WS-DES-BLOQ
               WHEN 11 
                 MOVE 'BLOQUEO SOBRE ENDEUDAMIENTO' TO WS-DES-BLOQ
               WHEN 12 
                 MOVE 'BLOQUEO LIMITE DE SOBREGIRO' TO WS-DES-BLOQ
               WHEN 13 
                 MOVE 'BLOQUEO PREVENTIVO' TO WS-DES-BLOQ
               WHEN 14 
                 MOVE 'BLOQUEO DE LINEA SOBREGIRO' TO WS-DES-BLOQ
               WHEN 16 
                 MOVE 'TRANSFERENCIA VEA A TC NUEVA' TO WS-DES-BLOQ
               WHEN 17 
                 MOVE 'BLOQUEO TC PROVISIONAL' TO WS-DES-BLOQ
               WHEN 50 
                 MOVE 'BLOQUEO TARJETA POR ROBO' TO WS-DES-BLOQ
               WHEN 51 
                 MOVE 'BLOQUEO TARJETA POR PERDIDA' TO WS-DES-BLOQ
               WHEN 52 
                 MOVE 'BLOQ TARJ. ROBO (S/COBRO)' TO WS-DES-BLOQ
               WHEN 53 
                 MOVE 'BLOQ TARJ. PERDIDA (S/COBRO)' TO WS-DES-BLOQ
               WHEN 54 
                 MOVE 'BLOQUEO TARJETA POR DETERIORO' TO WS-DES-BLOQ
               WHEN 55 
                 MOVE 'BLOQUEO TARJETA POR FRAUDE' TO WS-DES-BLOQ
               WHEN 56 
                 MOVE 'BLOQ POR REZAGO' TO WS-DES-BLOQ
               WHEN 57 
                 MOVE 'BLOQUEO REEMISION REZAGO' TO WS-DES-BLOQ
               WHEN 58 
                 MOVE 'BLOQ TARJ. DETERIORO (S/COBRO)' TO WS-DES-BLOQ
               WHEN 59 
                 MOVE 'BLOQUEO SOSPECHA DE FRAUDE' TO WS-DES-BLOQ
               WHEN 60 
                 MOVE 'BLOQUEO TEMPORAL S/RETENCION' TO WS-DES-BLOQ
               WHEN 61 
                 MOVE 'BLOQUEO TEMPORAL C/ RETENCION' TO WS-DES-BLOQ
               WHEN 62 
                 MOVE 'BLOQUEO UPGRADE' TO WS-DES-BLOQ
               WHEN 66 
                 MOVE 'BLOQUEO TRANSFER. NSAT' TO WS-DES-BLOQ
               WHEN 67 
                 MOVE 'TARJETA EMPRESA NO EMITIDA' TO WS-DES-BLOQ
               WHEN 68 
                 MOVE 'BLOQUEO TEMPORAL DE APAGAR TC' TO WS-DES-BLOQ
               WHEN 69 
                 MOVE 'BLOQUEO POR DISPOSICION DE EFE' TO WS-DES-BLOQ
               WHEN 70 
                 MOVE 'BLOQUEO PERSONALIZACI N TARJET' TO WS-DES-BLOQ
               WHEN 71 
                 MOVE 'BLOQUEO LÍNEA SOBREGIRO SSAA' TO WS-DES-BLOQ
               WHEN 72 
                 MOVE 'BLOQUEO POR TARJETA INNOMINADA' TO WS-DES-BLOQ
               WHEN 99 
                 MOVE 'BLOQUEO DE LIQUIDACION' TO WS-DES-BLOQ
               WHEN OTHER 
                 MOVE 'TARJETA ACTIVA' TO WS-DES-BLOQ
           END-EVALUATE.

