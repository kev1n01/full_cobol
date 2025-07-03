***********************************************************************
*     * 412213 17/06/24 ACO INNOMINADAS-INTERFAZ DATA REPORTERIA      *
***********************************************************************
      *-------------------------------------------------------------*
      *    COPY     : CDCFDREP                                      *
      *    REGISTRO : ARCHIVOS PARA DATA REPORTERÍA                 *
      *    LONGITUD : 293 BYTES                                     *
      *    CAMPOS   : 26                                            *
      *-------------------------------------------------------------*
       02  REG-CDCFDREP.
      * CODIGO UNICO TITULAR
           03  CDC-CU-TIT         PIC 9(10) VALUE ZEROES.
           03  CDC-FILLER01       PIC X(01).
      * CODIGO UNICO BENEFICIARIO
           03  CDC-CU-ADI         PIC 9(10) VALUE ZEROES.
           03  CDC-FILLER02       PIC X(01).
      * NOMBRE DEL CLIENTE
           03  CDC-NOM-CLIENTE    PIC X(40).
           03  CDC-FILLER03       PIC X(01).
      * TIPO DE CLIENTE
           03  CDC-TIPO-CLIENTE   PIC X(04).
           03  CDC-FILLER04       PIC X(01).
      * MARCA-TIPO
           03  CDC-MARCA-TIPO.
               05 CDC-MARCA       PIC 9(02).
               05 CDC-TIPO        PIC 9(02).
           03  CDC-FILLER05       PIC X(01).
      * TIPO DE DOCUMENTO
           03  CDC-TIPO-DOC       PIC X(01).
           03  CDC-FILLER06       PIC X(01).
      * NUMERO DE DOCUMENTO
           03  CDC-NUM-DOC        PIC X(11).
           03  CDC-FILLER07       PIC X(01).
      * NUMERO DE CUENTA
           03  CDC-NUM-CTA        PIC 9(12).
           03  CDC-FILLER08       PIC X(01).
      * NUMERO DE PAN
           03  CDC-PAN            PIC X(22).
           03  CDC-FILLER09       PIC X(01).
      * ALIAS
           03  CDC-ALIAS          PIC X(22).
           03  CDC-FILLER10       PIC X(01).
      * PAN TRUNCADO
           03  CDC-PAN-TRCD       PIC X(22).
           03  CDC-FILLER11       PIC X(01).
      * ID SOLICITUD
           03  CDC-SOL-PRODUCTO   PIC X(20).
           03  CDC-FILLER12       PIC X(01).
      * ESTADO SOLICITUD
           03  CDC-EST-SOL        PIC X(01).
           3   CDC-FILLER13       PIC X(01).
      * MOTIVO BAJA CTA
           03  CDC-MOTBAJA-CTA    PIC X(02).
           03  CDC-FILLER14       PIC X(01).
      * FECHA BAJA CTA
           03  CDC-FECBAJA-CTA    PIC 9(08).
           03  CDC-FILLER15       PIC X(01).
      * FECHA ALTA CTA
           03  CDC-FECALTA-CTA    PIC 9(08).
           03  CDC-FILLER16       PIC X(01).
      * SITUACION CTA
           03  CDC-SIT-CTA        PIC X(02).
           03  CDC-FILLER17       PIC X(01).
      * COD BLOQUEO TARJ
           03  CDC-CODBLOQ-TAR    PIC 9(02).
           03  CDC-FILLER18       PIC X(01).
      * FECHA BLOQ TARJ
           03  CDC-FECBLOQ-TAR    PIC 9(08).
           03  CDC-FILLER19       PIC X(01).
      * FLUJO ALTA TARJ
           03  CDC-FLUJO-ALT-TAR  PIC X(15).
           03  CDC-FILLER20       PIC X(01).
      * CANAL ALTA TARJ
           03  CDC-CANAL-ALT-TAR  PIC X(10).
           03  CDC-FILLER21       PIC X(01).
      * FECHA ALTA TARJ
           03  CDC-FEC-ALT-TAR    PIC 9(08).
           03  CDC-FILLER22       PIC X(01).
      * FECHA ACUSE TARJ
           03  CDC-FEC-ACUSE-TAR  PIC 9(08).
           03  CDC-FILLER23       PIC X(01).
      * TECNOLOGIA DE LA TARJETA
           03  CDC-TEC-TARJ       PIC X(10).
           03  CDC-FILLER24       PIC X(01).
      * SITUACION TARJETA
           03  CDC-SIT-TAR        PIC 9(02).
           03  CDC-FILLER25       PIC X(01).
      * TIPO DE TARJETA
           03  CDC-TIPO-TAR       PIC X(03).
           03  CDC-FILLER26       PIC X(01).
      * CAMBIO DE PIN
           03  CDC-CAMBIO-PIN     PIC X(01).
           03  CDC-FILLER27       PIC X(01).
      *-------------------------------------------------------------*