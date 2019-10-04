#include <openssl/opensslconf.h>

#ifdef OPENSSL_FIPS
# include "fips_err.h"
#else
static void *dummy = &dummy;
#endif
void fips_err_dummy(){}
