asect 0x00
delay: dc 1
ldi r0, 0xf0 # control
ldi r1, 0b00010001
st r0, r1
ldi r1, 1
st r0, r1
jsr getNew
ldi r0, 0xe8 # tempCoords
ldi r1, 0xe0 # coords
jsr memcpy
jsr drawFig
mainLoop:
	ldi r0, delay
	ldc r0, r0
	while
		dec r0
	stays nz
		push r0
		ldi r0, 0xf3 # keyboard
		ld r0, r1
		if
			tst r1
		is nz
			if
				ldi r0, 0b11000000
				cmp r0, r1
			is z
				jsr moveDown
			else
				ldi r0, 1
				or r1, r0
				jsr moveXorRotate
			fi
		fi
		pop r0
	wend	
	jsr moveDown
	br mainLoop

getNew:
	ldi r0, control
	ldi r1, 0b00010001
	st r0, r1
	ldi r0, dataOut # data
	ldi r2, 0xe0 # coords
	ldi r1, 9
	while
		dec r1
	stays nz
		ld r0, r3
		st r2, r3
		inc r2
	wend
	ldi r0, 0xf0 # control
	ldi r1, 0
	st r0, r1
	rts
	
readWrite:
	ldi r0, 9
	ldi r1, 0xe0 # coords
	while
		dec r0
	stays nz
		ld r1, r3
		ldi r2, dataIn
		st r2, r3
		ldi r2, dataOut
		ld r2, r3
		st r1, r3
		push r0
		if
			ldi r0, 255
			cmp r0, r3
		is z
			break
		fi
		pop r0
		inc r1
	wend
	rts

# r0 - dest
# r1 - src
memcpy:
	ldi r2, 9
	while
		dec r2
	stays nz
		ld r1, r3
		st r0, r3
		inc r0
		inc r1
	wend
	rts

moveDown:
	ldi r0, 0xf0 # control
	ldi r1, 0b11000001
	st r0, r1
	jsr readWrite
	if
		ldi r1, 255
		cmp r1, r3
	is z
		jsr unionFig
		jsr getNew
	fi
	jsr drawFig
	rts
	
moveXorRotate:
	push r0
	ldi r0, 0xe8 # tempCoords
	ldi r1, 0xe0 # coords
	jsr memcpy
	ldi r0, 0xf0 # control
	pop r1
	st r0, r1
	jsr readWrite
	if
		ldi r1, 255
		cmp r1, r3
	is z
		ldi r0, 0xe0 # coords
		ldi r1, 0xe8 # tempCoords
		jsr memcpy
		jsr unionFig
		jsr getNew
	fi
	jsr drawFig
	rts


unionFig:
	ldi r1, 0b00001110
	ldi r2, 0xe8 # tempCoords
	jsr write
	rts

# r1 - bit mask
# r2 - var addr
drawFig:
	ldi r1, 0b00100100
	ldi r2, 0xe0 # coords
	jsr write
	ldi r0, 0xf0
	ldi r1, 0
	st r0, r1
	rts
	
write:
	ldi r0, 0xf0 # control
	st r0, r1
	move r2, r1
	ldi r2, 9
	ldi r0, dataIn # data
	while
		dec r2
	stays nz
		ld r1, r3
		st r0, r3
		inc r1
	wend
	rts
	
	
checkRows:
	ldi r0, 0xf0 # control
	ldi r1, 0b00100010
	st r0, r1
	ldi r0, 0xe0 # coords
	ldi r1, 0xf1 # data
	ldi r2, 5
	while
		dec r2
	stays nz
		ld r0, r3
		st r1, r3
		inc r0
		ld r0, r3
		st r1, r3
		inc r0
		ld r1, r3
		push r2
		if
			ldi r2, 1
			and r2, r3
		is nz
			break
		fi
		pop r2
		
	wend
	rts	

asect 0xf0
control: dc 0
dataIn: dc 5
dataOut: dc 0
keyboard: dc 0
score: dc 0
end