/* pk7_mime.c */
/*
 * Written by Dr Stephen N Henson (steve@openssl.org) for the OpenSSL
 * project.
 */
/* ====================================================================
 * Copyright (c) 1999-2005 The OpenSSL Project.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. All advertising materials mentioning features or use of this
 *    software must display the following acknowledgment:
 *    "This product includes software developed by the OpenSSL Project
 *    for use in the OpenSSL Toolkit. (http://www.OpenSSL.org/)"
 *
 * 4. The names "OpenSSL Toolkit" and "OpenSSL Project" must not be used to
 *    endorse or promote products derived from this software without
 *    prior written permission. For written permission, please contact
 *    licensing@OpenSSL.org.
 *
 * 5. Products derived from this software may not be called "OpenSSL"
 *    nor may "OpenSSL" appear in their names without prior written
 *    permission of the OpenSSL Project.
 *
 * 6. Redistributions of any form whatsoever must retain the following
 *    acknowledgment:
 *    "This product includes software developed by the OpenSSL Project
 *    for use in the OpenSSL Toolkit (http://www.OpenSSL.org/)"
 *
 * THIS SOFTWARE IS PROVIDED BY THE OpenSSL PROJECT ``AS IS'' AND ANY
 * EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE OpenSSL PROJECT OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 *
 */

#include <stdio.h>
#include <ctype.h>
#include "cryptlib.h"
#include <openssl/rand.h>
#include <openssl/x509.h>
#include <openssl/asn1.h>

/* PKCS#7 wrappers round generalised MIME routines */

PKCS7 *SMIME_read_PKCS7(BIO *bio, BIO **bcont)
{
    return (PKCS7 *)SMIME_read_ASN1(bio, bcont, ASN1_ITEM_rptr(PKCS7));
}

/* Callback for int_smime_write_ASN1 */

static int pk7_output_data(BIO *out, BIO *data, ASN1_VALUE *val, int flags,
                           const ASN1_ITEM *it)
{
    PKCS7 *p7 = (PKCS7 *)val;
    BIO *tmpbio, *p7bio;

    if (!(flags & SMIME_DETACHED)) {
        SMIME_crlf_copy(data, out, flags);
        return 1;
    }

    /* Let PKCS7 code prepend any needed BIOs */

    p7bio = PKCS7_dataInit(p7, out);

    if (!p7bio)
        return 0;

    /* Copy data across, passing through filter BIOs for processing */
    SMIME_crlf_copy(data, p7bio, flags);

    /* Finalize structure */
    if (PKCS7_dataFinal(p7, p7bio) <= 0)
        goto err;

 err:

    /* Now remove any digests prepended to the BIO */

    while (p7bio != out) {
        tmpbio = BIO_pop(p7bio);
        BIO_free(p7bio);
        p7bio = tmpbio;
    }

    return 1;

}

int SMIME_write_PKCS7(BIO *bio, PKCS7 *p7, BIO *data, int flags)
{
    STACK_OF(X509_ALGOR) *mdalgs;
    int ctype_nid = OBJ_obj2nid(p7->type);
    if (ctype_nid == NID_pkcs7_signed)
        mdalgs = p7->d.sign->md_algs;
    else
        mdalgs = NULL;

    return int_smime_write_ASN1(bio, (ASN1_VALUE *)p7, data, flags,
                                ctype_nid, NID_undef, mdalgs,
                                pk7_output_data, ASN1_ITEM_rptr(PKCS7));
}
