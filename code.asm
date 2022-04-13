asect 0x00

ldi r0, 0x01
push r0
ldi r0, 0x00
push r0
ldi r0, 0b10000000
push r0
rti
jsr main



dir: ds 1 
tempX: ds 4
tempY: ds 4
buttons: dc 255
field: ds 40
asect 0xb7
loadFlag: ds 1
coordsX: ds 4
coordsY: ds 4
asect 0xc0
rotateMapX: ds 16
asect 0xd0
rotateMapY: ds 16
asect 0xe0
randomInput: dc 55
dispOut: ds 1
dispRow: ds 1
dispSector: ds 1
asect 0x0100


main:

	jsr loadFigure
	halt
game_loop:
	ldi r0, loadFlag
	ldc r0, r0
	tst r0
	beq game_loop
		
		
	ldi r0, coordsX
	ldi r1, coordsX
	
	jsr loadCoords
	
	ldi r0, coordsY
	ldi r1, coordsY
	
	jsr loadCoords
	
	ldi r0, loadFlag
	ldi r1, 0
	st r0, r1
	ldi r0, randomInput
	ldi r1, 255
	st r0, r1

br game_loop


rotateFigure:
	ldi r0, dir
	ldc r0, r0
	inc r0
	ldi r1, 4
	cmp r0, r1
	beq rotate_then1
	ldi r0, 0
rotate_then1:
	ldi r1, dir
	st r1, r0

	ldi r0, tempX
	ldi r1, coordsX
	ldi r2, 4
	jsr memcpy
	
	ldi r0, tempY
	ldi r1, coordsY
	ldi r2, 4
	jsr memcpy
	
	ldi r0, tempX
	ldi r1, rotateMapX
	ldi r2, dir
	ldc r2, r2
	add r2, r1
	jsr sumCoords
	
	ldi r0, tempY
	ldi r1, rotateMapY
	ldi r2, dir
	ldc r2, r2
	add r2, r1
	jsr sumCoords
	
	ldi r0, tempX
	ldi r1, tempY
	jsr checkFigure
	tst r3
	beq rotate_then2
	rts
rotate_then2:
	ldi r0, coordsX
	ldi r1, tempX
	ldi r2, 4
	jsr memcpy
	ldi r0, coordsY
	ldi r1, tempY
	ldi r2, 4
	jsr memcpy
	rts


# sumCoords function
# r0 - dest address
# r1 - coef address
sumCoords:
	ldi r2, 4
sumCoords_while_start:
	tst r2
	beq sumCoords_while_end
	push r2
	ldc r2, r0
	ldc r3, r1
	add r3, r2
	st r0, r2
	pop r2
	dec r2
	br sumCoords_while_start
sumCoords_while_end:
	rts

# checkFigure function
# r0 - tempX coords address
# r1 - tempY coords address
# if temp coords are valid r3 will be 1 else 0
checkFigure:
	ldi r2, 4
checkFigure_iterator_start:
	tst r2
	beq checkFigure_iterator_finish
		push r1
		push r2
		push r0
		move r0, r3
		ldi r1, 2
		jsr multiply # r0 stores address of y row
		move r0, r2
		pop r0
		push r0
		ldi r1, 8
		ld r0, r0
			cmp r1, r0
		bgt checkFigure_size_check_finish
			sub r0, r1
			inc r2
checkFigure_size_check_finish:
		jsr shift_right
		ldc r2, r2
		
			and r0, r2
			tst r2
		bne checkFigure_field_check_finish
checkFigure_field_check_fail:
			ldi r3, 0
			rts
checkFigure_field_check_finish:
		pop r0
		pop r2
		pop r1
		dec r2
	br checkFigure_iterator_start
checkFigure_iterator_finish:
	ldi r3, 1
	rts


# loadCoords function
# r0 - destination
# r1 - bytes count
loadCoords:
loadCoords_while_begin:
	tst r1
	beq loadCoords_while_finish
	ld r0, r2
	inc r0
	dec r1
	br loadCoords_while_begin
loadCoords_while_finish:
	rts

loadFigure:
	ldi r0, randomInput
	ld r0, r0

	ldi r0, loadFlag
	ldi r1, 1
	st r0, r1

	ldi r0, coordsX
	ldi r1, 4
	jsr loadCoords


	ldi r0, coordsY
	ldi r1, 4
	jsr loadCoords

	ldi r0, loadFlag
	ldi r1, 1
	st r0, r1
	rts

# ################################################################# #

#                       UTILITY FUNCTIONS                           #

# ################################################################# #


# memcpy function
# r0 - dest address
# r1 - src address
# r2 - length
# all registers will be corrupted

memcpy:
	tst r2
	beq memcpy_while_end
	ldc r1, r3
	st r0, r3
	inc r0
	inc r1
	dec r2
	br memcpy
memcpy_while_end:
	rts


# multiply functions
# r0 - number, result will be stored here
# r1 - multiplier
# other registrers are safe

multiply:
	push r2
	move r0, r2
    ldi r0, 0
multiply_start:
	tst r1
	beq multiply_finish
	add r2, r0
	dec r1
    br multiply_start
multiply_finish:
	pop r2
	rts

# shift left function
# r0 - result
# r1 - shift count
shift_right:
	ldi r0, 0b10000000
shift_right_while_start:
	tst r1
	beq shift_right_while_finish
	shr r0
	dec r1
	br shift_right_while_start
shift_right_while_finish:
	rts

# ################################################################# #

#                            CONSTANSTS                             #

# ################################################################# #

move_down: dc 0, 255, 0, 255, 0, 255
move_right: dc 1, 0, 1, 0, 1, 0, 1, 0
move_left: dc 255, 0, 255, 0, 255, 0, 255, 0


asect 0xffe0
# pcl, pch, ps
# first vector
dc 0xff, 0xf1, 0x00
ds 1
# scond vector
dc 0xfe, 0xf2, 0x00
ds 1

end