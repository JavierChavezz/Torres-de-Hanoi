#*********************************************************************#
#                        Torre de Hanoi
#*********************************************************************#
# 22 de febrero 2019
# Arquitectura de Computadoras, ITESO
# Javier Chavez ie712295
# Armando Correa ie708826 

#*********************************************************************#

.text
 
	
	ori $s0,$s0,3    # numero de discos iniciales
	lui $at,0x1001   #origen
	
	Cargar_Torre:
		bne $s0,$zero,cargar #if s0 != zero ir a cargar
	 	j main               # si fue igual a 0 continuar con el programa
	cargar:
		sw $s0,0($at)#almacenar en la posición de $at
		addi $s0,$s0,-1  #restar en uno el numero de discos
		addi $at,$at,4   #aumentar el indice de $at
	j Cargar_Torre           #regresar a veridicar si faltan discos por cargar
	
	main:

    		and $s0,$s0,$zero       #nos aseguramos que exista un zero en $s0     
   		ori $t9,$t9,1		#para comparar en el caso base 
    	
    					#restauramos resgistros que seran apuntadores de las torres
    		lui $s0,0x1001         #  $s0 = 0x10010000
    		lui $s1,0x1001
   		lui $s2,0x1001
    		ori $s1,$s1,0x0040     #  $s1 = 0x10010040
   		ori $s2,$s2,0x0080     #  $s2 = 0x10010080            #dejamos espacio hasta 16 discos sin problemas de traslape de datos entre torres
    									#si se desean mas o ver mas compactas las torres, modificar las direcciones 	
    																
    	jal Hanoi #	Hanoi(altura,origen,destino,intermedio) (s0,a1,a2,a3) #primera llamada de la función Hanoi


	endMain:   #despues de que terminan todas las llamadas simplemente salimos del programa
	j exit
	
	Hanoi:
	
		sw $ra, 0($sp) 		 # guardamos la dirección de retorno en el stack
		addi $sp, $sp,-4	 # decrementamos el stack para volver a guardar datos	
		lw $at,0($s0)		# Ponemos en el registro $at el numero de disco actual
		bne $at, $t9,RecCase    # if $at != 1 ir a caso recursivo
		
			#si fue 1 estamos en el caso base
		
		sw $zero, 0($s0)	# limpiar la ultimo posicion en el indice s0
		sw $at  , 0($s2)	# Escribir en la nueva posicion
		sw   $s2,-8($sp)	# Escribir en el destino con un offset
		addi $s2,$s2,4		# incrementamos el indice en uno para el siguiente numero
		addi $sp,$sp,4		#Hacemos que el sp apunte al return address, Eso despues de realizar los movimientos del disco.
		lw   $ra ,0($sp)	# Restaurar el return address
		
	jr $ra
	
	RecCase:
		#Hacemos un push del origen auxiliar y destino en el stack
		sw $s0, 0($sp)	      
	        sw $s1, -4($sp)	
	        sw $s2, -8($sp)
	        addi $sp, $sp,-12# decrementamos el indice del stack 4 palabras
	        
	        #se hace un swap de los aountadores para la siguiente llamada a Hanoi
	        lw $s1,4($sp)# 
	        lw $s2,8($sp)#
	        
	        #nos vamos al numero que esta arriba, para alejarlo
	        addi $s0,$s0,4
		
			jal Hanoi
			#ahora es imporante recuperar posiciones anteriores
			lw $s2,4($sp)
			lw $s1,8($sp)
			lw $s0,12($sp)
			 
			lw $at  , 0($s0)
			sw $zero, 0($s0) # limpiar la ultimo posicion en el indice s0
			sw $at  , 0($s2) # Escribir en la nueva posicion
			addi $s2,$s2,4   # incrementamos el indice en uno para el siguiente numero

			#Recuperamos valores del stack para el regreso de lafuncion
			lw $s1,12($sp)
			lw $s0,-12($sp)
			
			jal Hanoi
			addi $sp,$sp,16
			lw $ra,0($sp)
		jr $ra
exit:  #Fin de programa
