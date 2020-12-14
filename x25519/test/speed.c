#include <stdlib.h>
#include "../api.h"
#include "print.h"
#include "cpucycles.h"
#include "fail.h"
#include "avr.h"

#define NRUNS 5

#define nlen crypto_scalarmult_SCALARBYTES
#define plen crypto_scalarmult_BYTES

static unsigned char *n;
static unsigned char *p;

int main(void)
{
  unsigned int i;
  unsigned long long t[NRUNS];

  n = calloc(nlen,1);
  if(!n) fail("allocation of n failed");
  p = calloc(plen,1);
  if(!p) fail("allocation of p failed");

  for (i = 0;i < nlen;++i) n[i] = i + 1;
  for (i = 0;i < plen;++i) p[i] = i + 2;


  for(i=0;i<NRUNS;i++)
  {
    t[i] = cpucycles();
    crypto_scalarmult_base(p,n);
  }
  print_speed("crypto_scalarmult_base",-1,t,NRUNS);

  for(i=0;i<NRUNS;i++)
  {
    t[i] = cpucycles();
    crypto_scalarmult(p,n,p);
  }
  print_speed("crypto_scalarmult",-1,t,NRUNS);


  free(n);
  free(p);

  avr_end();
  return 0;
}
