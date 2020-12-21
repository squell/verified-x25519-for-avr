#include "fe25519.h"

extern char bigint_subp(unsigned char* restrict r, const unsigned char* a);
extern char bigint_mul256(unsigned char* restrict r, const unsigned char* a, const unsigned char* b);
extern char bigint_square256(unsigned char* restrict r, const unsigned char* a);

/* m = 2^255-19 = 7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed */
// --------------------------- modulo-arithmetic operations -----------------------------

/* reduction modulo 2^255-19 */
void fe25519_freeze(fe25519 *r)
{
  unsigned char c;
  fe25519 rt;
  c = bigint_subp(rt.v, r->v);
  fe25519_cmov(r,&rt,1-c);
}

void fe25519_setzero(fe25519 *r)
{
  unsigned char i;
  for(i=0;i<32;i++)
    r->v[i]=0;
}

void fe25519_setone(fe25519 *r) 
{
  unsigned char i;
  r->v[0] = 1;
  for(i=1;i<32;i++) 
    r->v[i]=0;
}

void fe25519_neg(fe25519 *r, const fe25519 *x) 
{
  fe25519 t;
  fe25519_setzero(&t);
  fe25519_sub(r, &t, x);
}

void fe25519_cmov(fe25519 *r, const fe25519 *x, unsigned char b)
{
  unsigned char i;
  unsigned char mask = b;
  mask = -mask;
  for(i=0;i<32;i++) 
    r->v[i] ^= mask & (x->v[i] ^ r->v[i]);
}

void fe25519_unpack(fe25519 *r, const unsigned char x[32])
{
  unsigned char i;
  for(i=0;i<32;i++)
    r->v[i] = x[i];
  r->v[31] &= 127;
}

/* Assumes input x being reduced below 2^255 */
void fe25519_pack(unsigned char r[32], const fe25519 *x)
{
  unsigned char i;
  fe25519 y = *x;
  fe25519_freeze(&y);
  for(i=0;i<32;i++)
    r[i] = y.v[i];
}
	
void fe25519_mul(fe25519 *r, const fe25519 *x, const fe25519 *y)
{
  unsigned char t[64];
  bigint_mul256(t,x->v,y->v);
  fe25519_red(r,t);
} 

/*
static const fe25519 _121666 = {{0x42, 0xDB, 0x01, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}};

void fe25519_mul121666(fe25519 *r, const fe25519 *x)
{
  unsigned char t[64];
  bigint_mul256(t,x->v,_121666.v);
  fe25519_red(r,t);
} 
*/

void fe25519_square(fe25519 *r, const fe25519 *x)
{
  unsigned char t[64];
  bigint_square256(t,x->v);
  fe25519_red(r,t);
}


