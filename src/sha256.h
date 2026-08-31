/*********************************************************************
* Filename:   sha256.h
* Author:     Brad Conte (brad AT bradconte.com)
* Copyright:
* Disclaimer: This code is presented "as is" without any guarantees.
* Details:    Defines the API for the corresponding SHA256 implementation.
*********************************************************************/

#ifndef SHA256_H
#define SHA256_H

/*************************** HEADER FILES ***************************/
#include <stddef.h>

/****************************** MACROS ******************************/
#define SHA256_BLOCK_SIZE 32            // SHA256 outputs a 32 byte digest

#ifdef _WIN32
#define DLLEXPORT __declspec(dllexport)
#else
#define DLLEXPORT extern
#endif

/*********************** FUNCTION DECLARATIONS **********************/
DLLEXPORT void compute_sha256(const unsigned char *str, size_t len, unsigned char *output);

/* Incremental (streaming) API. Caller owns the context: allocate
   sha256_stream_ctx_size() bytes, then init / update... / final.
   final writes the raw SHA256_BLOCK_SIZE byte digest to output. */
DLLEXPORT size_t sha256_stream_ctx_size(void);
DLLEXPORT void sha256_stream_init(void *ctx);
DLLEXPORT void sha256_stream_update(void *ctx, const unsigned char *data, size_t len);
DLLEXPORT void sha256_stream_final(void *ctx, unsigned char *output);

#endif   // SHA256_H
