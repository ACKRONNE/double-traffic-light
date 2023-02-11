;Programa con 3 leds que simula un semaforo, el verde estara encendido 4 segundos, el amarillo 1 y el rojo 2

		LIST P=16F84A

OP		EQU		01H
TMR0	EQU		01H
INTCON	EQU		0BH
TRISA	EQU		05H
PA		EQU		05H
STATUS	EQU		03H
VAR		EQU		10H
						;INICIALIZACION DE PUERTOS
;--------------------------------------------------------------
		ORG 	0
		GOTO	INICIO

INICIO	ORG		10
		BSF		STATUS,5	;Cambio al banco de memoria
		MOVLW	B'00000111'	;Muevo 256 a W
		MOVWF	OP			;Muevo W a OP
		CLRF	TRISA		;Declaro PA como puerto de salida
		BCF		STATUS,5	;Cambio banco de memoria
		
		MOVLW	B'10100000'
		MOVWF	INTCON
		MOVLW	D'200'		
		MOVWF	VAR
		MOVLW	D'178'
		MOVLW	TMR0

		BSF		PA,0		;Enciendo el LED
		BCF		PA,1
		BCF		PA,2	
							;INICIO DEL PROGRAMA
;--------------------------------------------------------------		
START	NOP
		NOP
		NOP
		GOTO	START
						;INICIO DE LA INTERRUPCION
;--------------------------------------------------------------		

		ORG		4
		GOTO	INTER

INTER	ORG		100
		BTFSC	PA,0		;Pregunto si el led verde esta apagado
		GOTO	GREEN
		BTFSC	PA,1		;Pregunto si el Led Amarillo esta encendido
		GOTO	YELLOW
RED		DECFSZ	VAR,1		;Decrementa en 1 a var, si es Cero salta
		GOTO	SALIR		;Sale para seguir decrementando
		MOVLW	D'200'		
		MOVWF	VAR
		BSF		PA,0		;Enciendo y apago LEDS
		BCF		PA,1
		BCF		PA,2
		GOTO	SALIR
		
				
YELLOW	DECFSZ	VAR,1
		GOTO	SALIR
		MOVLW	D'100'		
		MOVWF	VAR
		BCF		PA,0		;Enciendo y apago LEDS
		BCF		PA,1
		BSF		PA,2
		GOTO	SALIR


GREEN	DECFSZ	VAR,1
		GOTO	SALIR		;Sale para seguir decrementando
		MOVLW	D'50'		
		MOVWF	VAR
		BCF		PA,0		;Enciendo y apago LEDS
		BSF		PA,1
		BCF		PA,2		

SALIR	MOVLW	D'178'
		MOVWF	TMR0
		BCF		INTCON,2
		RETFIE	

		END

