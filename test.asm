asect 0x00
jsr 0x100
asect 0xe0
storage: ds 5

asect 0x0100
ldi r2, 5
ldi r0, storage
ldi r3, 0
main:
tst r2
beq result

ld r0, r1
st r3, r1
inc r3
inc r0
dec r2
br main
result:
    halt
end
