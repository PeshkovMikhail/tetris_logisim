asect 0x00

jsr getNew
jsr draw
mainloop:
	ldi r0, keyboard
	ld r0, r1
	if
		ldi r2, 0
		cmp r2, r1
	is nz 
		if
			ldi r2, 3
			cmp r1, r2
		is z
			jsr rotate
			br mainloop
		fi
		ldi r0, x
		ld r0, r2
		ldi r3, tempX
		st r3, r2
		if
			ldi r3, 2
			cmp r1, r3
		is z
			dec r2
		else
			inc r2
		fi
		st r0, r2
		jsr check
		if
			tst r3
		is nz
			ldi r1, tempX
			ld r1, r2
			ldi r0, x
			st r0, r2
		fi
		ldi r3, 0
		jsr draw		
		br mainloop
	fi
	jsr moveDown
	br mainloop

getNew:
	ldi r0, control
	ldi r1, 0b00000111
	st r0, r1
	jsr read
	ldi r1, 0
	st r0, r1
	ldi r0, x
	ldi r1, 3
	st r0, r1
	ldi r0, y
	ldi r1, 0
	st r0, r1
	rts

check:
	ldi r0, control
	ldi r1, 0b00010010
	st r0, r1
	jsr writeFig
	ldi r1, 0
	st r0, r1
	ldi r1, status
	ld r1, r3
	rts

writeFig:
	ldi r1, dataOut
	ld r1, r3
	ld r1, r3
	ld r1, r3
	ld r1, r3
	rts
	
moveDown:
	ldi r0, y
	ld r0, r1
	inc r1
	st r0, r1
	jsr check
	if
		tst r3
	is nz
		ldi r0, y
		ld r0, r1
		dec r1
		st r0, r1
		jsr union
		jsr getNew
		ldi r0, status
		ld r0, r3
	fi
	jsr draw
	rts

union:
	ldi r0, control
	ldi r1, 0b01100010
	st r0, r1
	
	ldi r1, dataOut
	ld r1, r3
	ld r1, r3
	ld r1, r3
	ld r1, r3
	ld r1, r3
	ld r1, r3
	ld r1, r3
	ld r1, r3
	
	ldi r1, 0
	st r0, r1
	ldi r0, dataOut
	ld r0, r2
	if
		tst r2
	is nz
		ldi r1, score
		ld r1, r0
		if
			ldi r3, 1
			cmp r3, r2
		is z
			ldi r3, 1
		else
			if
				ldi r3, 2
				cmp r3, r2
			is z
				ldi r3, 3			
			else
				if
					ldi r3, 3
					cmp r3, r2
				is z
					ldi r3, 7
				else
					ldi r3, 15
				fi
			fi
		fi
		add r3, r0
		st r1, r0	
	fi
	rts

draw:
	ldi r0, control
	ldi r1, 0b01000010
	st r0, r1
	jsr writeFig
	ldi r1, 0
	st r0, r1
	rts

rotate:
	ldi r0, control
	ldi r1, 0b00001011
	st r0, r1
	jsr read
	jsr check
	if
		tst r3
	is nz
		ldi r1, 0b10000111
		st r0, r1
		jsr read
	fi
	jsr draw
	rts

read:
	ldi r1, dataIn
	ldi r2, dataOut
	ld r2, r3
	st r1, r3
	ld r2, r3
	st r1, r3
	rts

tempX: dc 0
asect 0xf0
control: ds 1
dataIn: ds 1
dataOut: dc 1
x: ds 1
y: ds 1
score: ds 1
keyboard: ds 1
status: dc 1
end