.PHONY: proof

CURVE25519 = obj/fe25519.o \
				     obj/fe25519_add.o \
	           obj/fe25519_invert.o \
	           obj/fe25519_red.o \
	           obj/fe25519_sub.o \
	           obj/bigint_subp.o \
	           obj/bigint_mul256.o \
	           obj/bigint_square256.o \
	           obj/curve25519.o 

proof: $(CURVE25519)

obj/fe25519.o: c/fe25519.replay
obj/fe25519_add.o: asm/fe25519_add.replay
obj/fe25519_invert.o: c/fe25519.replay
obj/fe25519_red.o: asm/fe25519_red.replay
obj/fe25519_sub.o: asm/fe25519_sub.replay
obj/fe25519_mul121666.o: asm/fe25519_mul121666.replay
obj/bigint_subp.o: asm/bigint_subp.replay
obj/bigint_mul256.o: asm/bigint_mul256_mul128.replay asm/bigint_mul256.replay
obj/bigint_square256.o: asm/bigint_square256_sqr128.replay asm/bigint_square256.replay
obj/curve25519.o: c/curve25519.replay c/curve25519_mladder.replay c/fermat.replay c/curve25519_extra.replay

c/%.replay: c/%.mlw
	why3 replay -L . -L c $<

asm/%.replay: asm/%.mlw
	why3 replay -L . -L asm $<
