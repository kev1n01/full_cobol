# ANALISIS DE PROGRAMA CDCB14Q
## DESCRIPCION
-> Tener en cuenta *SOLICITUDES PROCESADAS(ESTADO 1).
-> PAN = Del acrónimo de 'Personal Account Number' es el número de la tarjeta credito, debito, etc, 16 longitud.

Entiendo que es un programa que busca **coincidencias** entre los archivos INPUT FTOTT09I (input) y FFECACTI (input). Especificamente por el campo **CDC-PAN** Y **CDC-PANINNO**, es decir si un numero PAN normal figura como un numero PAN INNOMINADA.

## CONSULTAS:
- porque el numero 512972? acaso es un identificador para saber que lineas se han agregado o modificado?

## CARACTERISTICAS:
- Control de error de status de los archivos input y output, que no cumplan el codigo 00 o 97(lo que indica que se utiliza VSAM).
- Uso de clausulas en los File Description, donde indica que los registros deben te tener una etiqueta o cabecera. También que los registros tiene una logitud fija.
- Uso de copy para reutilizar codigo en este caso para la definicion de variables.
- Uso de parrafos con prefijos jerarquizados o identificados 1000-1001-1002.., 2000-2001..., 3000 en los perform.
- Uso de variables LINKAGE
- Acumuladores por tipo de tarjeta IDK...
- Uso de variables condicionales para verificar cuando se encuentre y no un match

## FLUJO DE EJECUCION:
1. Ejecuta el perform 1000-INICIO-PROGRAMA y este ejecuta: 
1001-OPEN-FILES, 1003-READ-FTOTT09I, 1002-READ-FFECACTI, 1004-OBTENER-FECHA respectivamente
2. Abrir archivos FTOTT09I (input), FFECACTI (input) y FECACTVO (output): 1001-OPEN-FILES
3. Validar status de OPEN con codigo 00 y 97, si es asi continua con la ejecucion, sino muestra el estado y ejecuta el parrafo 9000-ERROR-PGM, parando el programa: en el parrafo 1001-OPEN-FILES
4. Leer el archivo input FTOTT09I, al finalizar la lectura mueve 22 nueves a CDC-PAN, evalua el estado de archivo:
-> si es 00 añade 1 al contador WSV-CONT-ACFI1
-> si es 10 se setea 1 a la variable FIN-FTOTT09I-OK
-> sino significa que hubo un tipo de error y se asignan
el nombre de la rutina y de la accion 
asignar el estado a WSV-FSTATUS
ejecutando la rutina de stop de ejecucion 9000-ERROR-PGM
: 1003-READ-FTOTT09I
5. Leer el archivo input FFECACTI, al finalizar la lectura mueve 22 nueves a CDC-PANINNO, evalua el estado de archivo:
-> si es 00 añade 1 al contador WSV-CONT-ACFI2
-> si es 10 se setea 1 a la variable FIN-FFECACTI-OK
-> sino significa que hubo un tipo de error y se asignan
el nombre de la rutina y de la accion 
asignar el estado a WSV-FSTATUS
ejecutando la rutina de stop de ejecucion 9000-ERROR-PGM
: 1002-READ-FFECACTI
6. Obtener fecha y hora del sistema al ejecutar el programa: 1004-OBTENER-FECHA
7. Ejecuta el perform 2000-PROCESO-PROGRAMA y este ejecuta: 
2001-MATCHING-X-PAN hasta que FIN-FTOTT09I-OK sea TRUE
8. Se reasigna los spaces en WS-MATCH y WS-NO-MATCH para asi se pueda verificar un matching o coincidencia del siguiente registro y
se hace una evaluacion hasta que sea TRUE, cuando:
- EQUAL => CDC-PAN = CDC-PANINNO este:
  -> setea que hay una coincidencia entre un PAN y un PAN INNOMINADA, en SW-MATCH-SI con un valor TRUE
  -> ejecuta el 2002-MOVER-DATOS
  -> ejecuta el 1003-READ-FTOTT09I
  -> ejecuta el 1002-READ-FFECACTI
- LESS THEN => CDC-PAN < CDC-PANINNO este:
  -> setea que no hay una coincidencia entre el PAN y un PAN INNOMINADA, en SW-NO-MATCH-SI con un valor TRUE
  -> ejecuta el 2002-MOVER-DATOS
  -> ejecuta el 1003-READ-FTOTT09I
- GRANT THEN => CDC-PAN > CDC-PANINNO este:
  -> ejecuta el 1002-READ-FFECACTI
: 2001-MATCHING-X-PAN.
9. Si ejecuta el 2002-MOVER-DATOS se mueve los registro del primer archivo de entrada(FD: REG-DATAREPO) al arhcivo de salida(FD: REG-SALIDA)
Y condiciona:
-> Si hubo un MATCH guarda en los campos:
  - CDC-FECACTI a REP-FEC-ACUSE-TAR <- Fecha de activacion de tarjeta
  - FEC-ACT1 a REP-TEC-TARJ <- Tecnologia de tarjeta = ACTIVACION
  - TIP-VEN2 a REP-LINEVENT <- Tipo de venta = NP
  - y ejecuta 2004-GRABAR-SALIDA
-> Si no hubo MATCH guarda:
  - TIP-SPAC a REP-FEC-ACUSE-TAR <- Fecha de activacion de tarjeta
  - FEC-ACT2 a REP-TEC-TARJ <- Tecnologia de tarjeta = ACTIVACION
  - FEC-VEN1 a REP-LINEVENT <- Tipo de venta = P
  - y ejecuta 2004-GRABAR-SALIDA
10. Al grabar con 2004-GRABAR-SALIDA:
- escribe en REG-SALIDA es decir en el archivo FECACTVO
- se valida que la escritura haya sido exitosa, verificando que el FS-FECACTVO es diferente de 00.
  -> Se guarda el nombre de:
  rutina 2003-SAVE-FECACTVO a WSV-RUTINA
  accion REG-FECACTVO a WSV-ACCION
  y el status del archivo FS-FECACTVO a WSV-FSTATUS
  -> finalmente se termina la ejecucion del programa con 9000-ERROR-PGM
- agrega 1 al contador de WSV-CONT-ACFO1 registro grabados en archivo de salida
12. Se ejecuta el 3000-FIN-PROGRAMA donde este:
  -> ejecuta 3001-CLOSE-FILES, donde se cierran los archivos de entrada y salida y se valida sus estado a 00 mostrando
  -> en caso no hay error al cerrar los archivos, te muestra los detalles en la ejecucion de 3002-CARGA-DETALLES, mostrando la cantidad de registros leidos en FTOTT09I y FFECACTI, y los grabados o escritos en FECACTVO 


## OBSERVACIONES:
- El copy CDCFDREP tiene un nivel 01 (REG-CDCFDREP), por lo que no corresponde al nivel donde se hace el COPY en el programa (ERROR linea 41).
- Los copies COMWUPSI y COMWLUPS no existen (ERROR lina 129 y 134 respectivamente)
- Como se hace un COPY COMWLUPS dentro de la LINKAGE SECTION no se puede acceder a la variable LKUPSI (ERROR linea 137)
- Se podria reutilizar tambien las variables NUMPLAST y NUMBEN, tanto en CDC como REP es decir podria estar dentro del archivo copy
- En el archivo copy la logintud de la variable CDC-PAN es de 22 pero se sabe que deberia ser 16,
y al corregirse, el parrafo 1003-READ-FTOTT09I y 1002-READ-FFECACTI al asignar a CDC-PAN y a CDC-PANINNO ya que este ultimo debe tener una longitud de 21.
- En la lina 204 hay un error del nombre de rutina que se guarda en la variable WSV-RUTINA: 1004-READ-FFECACTI y deberia ser 1002
- 