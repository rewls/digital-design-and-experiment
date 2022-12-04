#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define DEBUG 1

#define BYTE2BIT 8
#define WORD2BYTE 4
#define N_ROUND 64
#define MESSAGE_SIZE 512 / BYTE2BIT
#define HASH_SIZE 256 / BYTE2BIT / sizeof(int)

#define ROTR(x, n) (((x) >> (n)) | ((x) << (sizeof(int) * BYTE2BIT - (n))))

// SHA-256 Functions
#define CH(x, y, z) (((x) & (y)) ^ (~(x) & (z)))
#define MAJ(x, y, z) (((x) & (y)) ^ ((x) & (z)) ^ ((y) & (z)))
#define BSIG0(x) (ROTR((x), 2) ^ ROTR((x), 13) ^ ROTR((x), 22))
#define BSIG1(x) (ROTR((x), 6) ^ ROTR((x), 11) ^ ROTR((x), 25))
#define SSIG0(x) (ROTR((x), 7) ^ ROTR((x), 18) ^ ((x) >> 3))
#define SSIG1(x) (ROTR((x), 17) ^ ROTR((x), 19) ^ ((x) >> 10))

// SHA-256 Constants
const unsigned int K[N_ROUND] = {
	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b,
	0x59f111f1, 0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01,
	0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7,
	0xc19bf174, 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
	0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152,
	0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147,
	0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc,
	0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
	0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819,
	0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116, 0x1e376c08,
	0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f,
	0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
	0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
};

#if DEBUG
int count = 0;
#endif

void parse(unsigned char text[MESSAGE_SIZE], unsigned char text_parse[MESSAGE_SIZE]);
void process(unsigned char text_parse[MESSAGE_SIZE], unsigned int hash[HASH_SIZE]);
void print(unsigned int hash[HASH_SIZE]);

int main() {
	unsigned char text[MESSAGE_SIZE], text_parse[MESSAGE_SIZE] = {};
	// SHA-256 Initialization
	unsigned int hash[HASH_SIZE] = {
	0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A, 0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19
	};
	int i, j;

	printf("input text: ");
	scanf("%s", text);

	parse(text, text_parse);

#if DEBUG
	printf("input 512 bits: ");
	for (i = 0; i < MESSAGE_SIZE; i++) {
		printf("%02x", text_parse[i]);
	}
	printf("\n\n");
#endif

	process(text_parse, hash);

	printf("\nresult: ");
	print(hash);

	return 0;
}

// SHA-256 Message Pading and Parsing
void parse(unsigned char text[MESSAGE_SIZE], unsigned char text_parse[MESSAGE_SIZE]) {
	int len, i;
	len = strlen(text);
	for (i = 0; i < len; i++) {
		text_parse[i] = text[i];
	}
	text_parse[i] = 1 << 7;
	text_parse[MESSAGE_SIZE - 1] = len * BYTE2BIT;
}

/*
 * SHA-256 Processing
 * 1. prepare the message schedule W
 * 2. initialize the working variables
 * 3. perform the main hash computation
 * 4. compute the hash value
 */
void process(unsigned char text_parse[MESSAGE_SIZE], unsigned int hash[HASH_SIZE]) {
	unsigned int W[N_ROUND] = {}, a, b, c, d, e, f, g, h, T1, T2;
	int i, j;

	// 1. prepare the message schedule W
	for (i = 0; i < 16; i++) {
		for (j = 0; j < WORD2BYTE; j++) {
			W[i] |= text_parse[WORD2BYTE * i + j] << BYTE2BIT * (WORD2BYTE - (j + 1));
		}
	}
	for (; i < N_ROUND; i++) {
		W[i] = SSIG1(W[i - 2]) + W[i - 7] + SSIG0(W[i - 15]) + W[i - 16];
	}

	// 2. initialize the working variables
	a = hash[0];
	b = hash[1];
	c = hash[2];
	d = hash[3];
	e = hash[4];
	f = hash[5];
	g = hash[6];
	h = hash[7];

	// 3. perform the main hash computation
	for (i = 0; i < N_ROUND; i++) {
		T1 = h + BSIG1(e) + CH(e, f, g) + K[i] + W[i];
		T2 = BSIG0(a) + MAJ(a, b, c);
		h = g;
		g = f;
		f = e;
		e = d + T1;
		d = c;
		c = b;
		b = a;
		a = T1 + T2;
#if DEBUG
		printf("Round: %d --> A: %08x, B: %08x, C: %08x, D: %08x, E: %08x, F: %08x, G: %08x, H: %08x, T1: %08x, T2: %08x\n", ++count, a, b, c, d, e, f, g, h, T1, T2);
#endif
	}

	// 4. compute the hash value
	hash[0] = a + hash[0];
	hash[1] = b + hash[1];
	hash[2] = c + hash[2];
	hash[3] = d + hash[3];
	hash[4] = e + hash[4];
	hash[5] = f + hash[5];
	hash[6] = g + hash[6];
	hash[7] = h + hash[7];
}

// Print hash value
void print(unsigned int hash[HASH_SIZE]) {
	int i;
	for (i = 0; i < HASH_SIZE; i++) {
		printf("%08x", hash[i]);
	}
}
