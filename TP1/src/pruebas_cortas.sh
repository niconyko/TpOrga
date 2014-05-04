prueba="Archivo vacio"
touch /tmp/zero.txt
./tp1 -a encode -i /tmp/zero.txt -o /tmp/zero.txt.b16
longitud=`ls -la /tmp/zero.txt.b16 | awk '{print $5}'`
if [[ $longitud -eq 0 ]] ; then echo "ok: $prueba"; else echo "ERROR: $prueba" ; fi
rm -f /tmp/zero.txt /tmp/zero.txt.b16

prueba="Codificacion de 'M' por entrada estandar"
hexa=`echo -n M | ./tp1`
if [[ "$hexa" == "4D" ]] ; then echo "ok: $prueba"; else echo "ERROR: $prueba" ; fi

prueba="Codificacion de 'Ma' por entrada estandar"
hexa=`echo -n Ma | ./tp1`
if [[ "$hexa" == "4D61" ]] ; then echo "ok: $prueba"; else echo "ERROR: $prueba" ; fi

prueba="Codificacion de 'Man' por entrada estandar"
hexa=`echo -n Man | ./tp1`
if [[ "$hexa" == "4D616E" ]] ; then echo "ok: $prueba"; else echo "ERROR: $prueba" ; fi

prueba="Codificacion y decodificacion de 'Man' por entrada estandar"
mensaje=`echo -n Man | ./tp1 | ./tp1 -a decode`
if [[ "$mensaje" == "Man" ]] ; then echo "ok: $prueba"; else echo "ERROR: $prueba" ; fi

prueba="Verificacion bit a bit de codificacion y decodificacion de xyz\n"
esperado="0000000   x   y   z  \n
0000004"
resultado=`echo xyz | ./tp1 | ./tp1 -a decode | od -t c`
if [[ "$resultado" == "$esperado" ]] ; then echo "ok: $prueba"; else echo "ERROR: $prueba" ; fi
