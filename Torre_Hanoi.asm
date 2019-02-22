#*********************************************************************#
#                        Torre de Hanoi
#*********************************************************************#
# 22 de febrero 2019
# Arquitectura de Computadoras, ITESO
# Javier Chavez ie712295
# Armando Correa ie708826 

#*********************************************************************#

.text

		addi $s0,$zero,3     # numero de discos iniciales
		addi $t0,$zero,$s0   # auxiliar para n
		
		#agregar direciones iniciales de las torres (vistas en el video de ejemplo)
		
		addi $s1,$zero,0x10010000 #origen
		addi $s2,$zero,0x10010020 #intermedio
		addi $s3,$zero,0x10010040 #destino		 
		
		#cargar todos los dicos a al poste 1,(s1)
		
	Cargar_Torre:
		
		beq $t0,$zero,Hanoi  #if n==0 saltar a Hanoi
		sw $t0,0($s1) #almacenar en la primera posición de s1
		addi $t0,$t0,-1 #restar para poner un disco más pequeño
		addi $s1,$s1,4 #aumentar el indice para el siguiente disco
	j Cargar_Torre
	
	Hanoi:					
																