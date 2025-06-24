       IDENTIFICATION DIVISION.
       PROGRAM-ID. COMP-VS-DISPLAY.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 I-NORMAL       PIC 9(6) VALUE ZERO.
       01 I-COMP          PIC 9(6) COMP VALUE ZERO.

       01 START-TIME      PIC 9(6).
       01 END-TIME        PIC 9(6).
       01 START-TIME-COMP PIC 9(6).
       01 END-TIME-COMP   PIC 9(6).

       PROCEDURE DIVISION.
           PERFORM TIMER-NO-COMP
           PERFORM TIMER-COMP
           DISPLAY "NO COMP -> Tiempo inicial: " START-TIME.
           DISPLAY "NO COMP -> Tiempo final  : " END-TIME.
           DISPLAY "COMP    -> Tiempo inicial: " START-TIME-COMP.
           DISPLAY "COMP    -> Tiempo final  : " END-TIME-COMP.
           STOP RUN.
       TIMER-NO-COMP.
       *> TIMER SIN  COMP
           ACCEPT START-TIME FROM TIME.
           PERFORM VARYING I-NORMAL FROM 1 BY 1 
                 UNTIL I-NORMAL > 100000
               CONTINUE
           END-PERFORM.
           ACCEPT END-TIME FROM TIME.
       TIMER-COMP.
       *> TIMER USANDO COMP
           ACCEPT START-TIME-COMP FROM TIME.
           PERFORM VARYING I-COMP FROM 1 BY 1 UNTIL I-COMP > 1000000
               CONTINUE
           END-PERFORM.
           ACCEPT END-TIME-COMP FROM TIME.

