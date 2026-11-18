Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061086;
	b=qUv6/5ig+1C8JUihVKiCGOMa+w6gbsqNSryZwybXwgXdTFiDBcx1nQyoU6ZyWecywfWM
	 MMrl9a9VSKzOD3fVZl5hvnLRVhhWws6xLvRawsXVMFVwqp08RzxxzJksuAB4iT9lrqNa4
	 I/TwM4E2jc5FyF/2Msx7jP2baNuKCN0JaOXkMxqQFEeiLrHBv5W0qffpoRXwDVfEk9+kf
	 ntUBlNtCA/3U8MlnP+gqGWt5V9dVMGz+ujaQ5vmrlDSAO/G6eVzN5M/vt8b53r9p3QU2Q
	 zH1ykaUhJlIE70pgY3FPHzyRAeLK1iTPJin4Ux4og1yq5Qcw5/hQ35Ifl8u5GKF2uoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+TwunEMsgm5e2ao8U0dixPPeoidAzGwFGur986GN810=;
	b=xQITIHMX30EfJp3QlbsaJYjI99XJQG52uJWNOzUcSesV8cTBsSNZfcE3OAFDG/Mjwipq
	 OJ5RzygQfiLgfxBZEmu9wrYHJbYQRsf80t4sRCWh5LvGLwauBaLoxNt83YtzIahwRDK3f
	 SOZHLFs8G0xi4LHbHKCL0Yxhb+bnzRUvJb2LhuxI8K54h7PTaAfhJlCHyD5HBH93kNx3t
	 FpnFNg+K8B0CQzDF2och1ty3BpmqiQPPrFEliFPgsFbSjcrl9AU2u4oVoMmHVsfV42OAo
	 LVS/p9pcjZHwPAvOTfua09VzE/6SuW75K1/7COwkKybHUJQgpsiJgG416SJi9CQf5kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PVuB1ZII;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D2C606A325;
	Thu, 19 Nov 2026 04:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PVuB1ZII
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6DE1F000C4;
	Thu, 19 Nov 2026 04:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061086;
	bh=+TwunEMsgm5e2ao8U0dixPPeoidAzGwFGur986GN810=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PVuB1ZIILN8y5arPhCRyA3yZuh3vP70q14D9VW8dM3u5ydtJdPF+YQnlfw4f2nRsK
	 BJJi+Xew5rVTVPCYdtQaeGYhthHX2oQ4vSqGwm00M/bbXBFJeW5+a+hLk+O5mgq2Ku
	 AkmbpvJ6wPFcv1ci/jTr0k2XZ8JXxYz02qDxKNBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1429/1848] crypto: tcrypt - include 1420 byte blocks in aead and skcipher benchmarks
Date: Wed, 18 Nov 2026 15:57:47 +0100
Message-ID: <20261118150019.362102818@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit ad6d66bcac77e5145eb67449f8354ed0f936258c ]

WireGuard and IPsec both typically operate on input blocks that are
~1420 bytes in size, given the default Ethernet MTU of 1500 bytes and
the overhead of the VPN metadata.

Many aead and sckipher implementations are optimized for power-of-2
block sizes, and whether they perform well when operating on 1420
byte blocks cannot be easily extrapolated from the performance on
power-of-2 block size. So let's add 1420 bytes explicitly, and round
it up to the next blocksize multiple of the algo in question if it
does not support 1420 byte blocks.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 3a31a4baad67 ("crypto: tcrypt - Avoid reading req->base after submission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tcrypt.c | 81 +++++++++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 37 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 7972d2784b3b5..de0dadf977c08 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -77,8 +77,8 @@ static const char *check[] = {
 	NULL
 };
 
-static u32 block_sizes[] = { 16, 64, 256, 1024, 1472, 8192, 0 };
-static u32 aead_sizes[] = { 16, 64, 256, 512, 1024, 2048, 4096, 8192, 0 };
+static const int block_sizes[] = { 16, 64, 256, 1024, 1420, 4096, 0 };
+static const int aead_sizes[] = { 16, 64, 256, 512, 1024, 1420, 4096, 8192, 0 };
 
 #define XBUFSIZE 8
 #define MAX_IVLEN 32
@@ -256,10 +256,10 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 	struct test_mb_aead_data *data;
 	struct crypto_aead *tfm;
 	unsigned int i, j, iv_len;
+	const int *b_size;
 	const char *key;
 	const char *e;
 	void *assoc;
-	u32 *b_size;
 	char *iv;
 	int ret;
 
@@ -337,15 +337,17 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 	do {
 		b_size = aead_sizes;
 		do {
-			if (*b_size + authsize > XBUFSIZE * PAGE_SIZE) {
+			int bs = round_up(*b_size, crypto_aead_blocksize(tfm));
+
+			if (bs + authsize > XBUFSIZE * PAGE_SIZE) {
 				pr_err("template (%u) too big for buffer (%lu)\n",
-				       authsize + *b_size,
+				       authsize + bs,
 				       XBUFSIZE * PAGE_SIZE);
 				goto out;
 			}
 
 			pr_info("test %u (%d bit key, %d byte blocks): ", i,
-				*keysize * 8, *b_size);
+				*keysize * 8, bs);
 
 			/* Set up tfm global state, i.e. the key */
 
@@ -380,11 +382,11 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 				memset(assoc, 0xff, aad_size);
 
 				sg_init_aead(cur->sg, cur->xbuf,
-					     *b_size + (enc ? 0 : authsize),
+					     bs + (enc ? 0 : authsize),
 					     assoc, aad_size);
 
 				sg_init_aead(cur->sgout, cur->xoutbuf,
-					     *b_size + (enc ? authsize : 0),
+					     bs + (enc ? authsize : 0),
 					     assoc, aad_size);
 
 				aead_request_set_ad(cur->req, aad_size);
@@ -394,7 +396,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 					aead_request_set_crypt(cur->req,
 							       cur->sgout,
 							       cur->sg,
-							       *b_size, iv);
+							       bs, iv);
 					ret = crypto_aead_encrypt(cur->req);
 					ret = do_one_aead_op(cur->req, ret);
 
@@ -406,18 +408,18 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 				}
 
 				aead_request_set_crypt(cur->req, cur->sg,
-						       cur->sgout, *b_size +
+						       cur->sgout, bs +
 						       (enc ? 0 : authsize),
 						       iv);
 
 			}
 
 			if (secs) {
-				ret = test_mb_aead_jiffies(data, enc, *b_size,
+				ret = test_mb_aead_jiffies(data, enc, bs,
 							   secs, num_mb);
 				cond_resched();
 			} else {
-				ret = test_mb_aead_cycles(data, enc, *b_size,
+				ret = test_mb_aead_cycles(data, enc, bs,
 							  num_mb);
 			}
 
@@ -534,7 +536,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	char *xbuf[XBUFSIZE];
 	char *xoutbuf[XBUFSIZE];
 	char *axbuf[XBUFSIZE];
-	unsigned int *b_size;
+	const int *b_size;
 	unsigned int iv_len;
 	struct crypto_wait wait;
 
@@ -590,12 +592,14 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	do {
 		b_size = aead_sizes;
 		do {
+			u32 bs = round_up(*b_size, crypto_aead_blocksize(tfm));
+
 			assoc = axbuf[0];
 			memset(assoc, 0xff, aad_size);
 
-			if ((*keysize + *b_size) > TVMEMSIZE * PAGE_SIZE) {
+			if ((*keysize + bs) > TVMEMSIZE * PAGE_SIZE) {
 				pr_err("template (%u) too big for tvmem (%lu)\n",
-				       *keysize + *b_size,
+				       *keysize + bs,
 					TVMEMSIZE * PAGE_SIZE);
 				goto out;
 			}
@@ -616,7 +620,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 
 			crypto_aead_clear_flags(tfm, ~0);
 			printk(KERN_INFO "test %u (%d bit key, %d byte blocks): ",
-					i, *keysize * 8, *b_size);
+					i, *keysize * 8, bs);
 
 
 			memset(tvmem[0], 0xff, PAGE_SIZE);
@@ -627,11 +631,11 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 				goto out;
 			}
 
-			sg_init_aead(sg, xbuf, *b_size + (enc ? 0 : authsize),
+			sg_init_aead(sg, xbuf, bs + (enc ? 0 : authsize),
 				     assoc, aad_size);
 
 			sg_init_aead(sgout, xoutbuf,
-				     *b_size + (enc ? authsize : 0), assoc,
+				     bs + (enc ? authsize : 0), assoc,
 				     aad_size);
 
 			aead_request_set_ad(req, aad_size);
@@ -644,7 +648,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 				 * reversed (input <-> output) to calculate it
 				 */
 				aead_request_set_crypt(req, sgout, sg,
-						       *b_size, iv);
+						       bs, iv);
 				ret = do_one_aead_op(req,
 						     crypto_aead_encrypt(req));
 
@@ -656,15 +660,15 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 			}
 
 			aead_request_set_crypt(req, sg, sgout,
-					       *b_size + (enc ? 0 : authsize),
+					       bs + (enc ? 0 : authsize),
 					       iv);
 
 			if (secs) {
-				ret = test_aead_jiffies(req, enc, *b_size,
+				ret = test_aead_jiffies(req, enc, bs,
 							secs);
 				cond_resched();
 			} else {
-				ret = test_aead_cycles(req, enc, *b_size);
+				ret = test_aead_cycles(req, enc, bs);
 			}
 
 			if (ret) {
@@ -1253,9 +1257,9 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 	struct test_mb_skcipher_data *data;
 	struct crypto_skcipher *tfm;
 	unsigned int i, j, iv_len;
+	const int *b_size;
 	const char *key;
 	const char *e;
-	u32 *b_size;
 	char iv[128];
 	int ret;
 
@@ -1307,14 +1311,16 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 	do {
 		b_size = block_sizes;
 		do {
-			if (*b_size > XBUFSIZE * PAGE_SIZE) {
+			u32 bs = round_up(*b_size, crypto_skcipher_blocksize(tfm));
+
+			if (bs > XBUFSIZE * PAGE_SIZE) {
 				pr_err("template (%u) too big for buffer (%lu)\n",
 				       *b_size, XBUFSIZE * PAGE_SIZE);
 				goto out;
 			}
 
 			pr_info("test %u (%d bit key, %d byte blocks): ", i,
-				*keysize * 8, *b_size);
+				*keysize * 8, bs);
 
 			/* Set up tfm global state, i.e. the key */
 
@@ -1344,7 +1350,7 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 
 			for (j = 0; j < num_mb; ++j) {
 				struct test_mb_skcipher_data *cur = &data[j];
-				unsigned int k = *b_size;
+				unsigned int k = bs;
 				unsigned int pages = DIV_ROUND_UP(k, PAGE_SIZE);
 				unsigned int p = 0;
 
@@ -1368,12 +1374,12 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 
 			if (secs) {
 				ret = test_mb_acipher_jiffies(data, enc,
-							      *b_size, secs,
+							      bs, secs,
 							      num_mb);
 				cond_resched();
 			} else {
 				ret = test_mb_acipher_cycles(data, enc,
-							     *b_size, num_mb);
+							     bs, num_mb);
 			}
 
 			if (ret) {
@@ -1488,8 +1494,8 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 	char iv[128];
 	struct skcipher_request *req;
 	struct crypto_skcipher *tfm;
+	const int *b_size;
 	const char *e;
-	u32 *b_size;
 
 	if (enc == ENCRYPT)
 		e = "encryption";
@@ -1524,17 +1530,18 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 		b_size = block_sizes;
 
 		do {
+			u32 bs = round_up(*b_size, crypto_skcipher_blocksize(tfm));
 			struct scatterlist sg[TVMEMSIZE];
 
-			if ((*keysize + *b_size) > TVMEMSIZE * PAGE_SIZE) {
+			if ((*keysize + bs) > TVMEMSIZE * PAGE_SIZE) {
 				pr_err("template (%u) too big for "
-				       "tvmem (%lu)\n", *keysize + *b_size,
+				       "tvmem (%lu)\n", *keysize + bs,
 				       TVMEMSIZE * PAGE_SIZE);
 				goto out_free_req;
 			}
 
 			pr_info("test %u (%d bit key, %d byte blocks): ", i,
-				*keysize * 8, *b_size);
+				*keysize * 8, bs);
 
 			memset(tvmem[0], 0xff, PAGE_SIZE);
 
@@ -1556,7 +1563,7 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 				goto out_free_req;
 			}
 
-			k = *keysize + *b_size;
+			k = *keysize + bs;
 			sg_init_table(sg, DIV_ROUND_UP(k, PAGE_SIZE));
 
 			if (k > PAGE_SIZE) {
@@ -1573,22 +1580,22 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 				sg_set_buf(sg + j, tvmem[j], k);
 				memset(tvmem[j], 0xff, k);
 			} else {
-				sg_set_buf(sg, tvmem[0] + *keysize, *b_size);
+				sg_set_buf(sg, tvmem[0] + *keysize, bs);
 			}
 
 			iv_len = crypto_skcipher_ivsize(tfm);
 			if (iv_len)
 				memset(&iv, 0xff, iv_len);
 
-			skcipher_request_set_crypt(req, sg, sg, *b_size, iv);
+			skcipher_request_set_crypt(req, sg, sg, bs, iv);
 
 			if (secs) {
 				ret = test_acipher_jiffies(req, enc,
-							   *b_size, secs);
+							   bs, secs);
 				cond_resched();
 			} else {
 				ret = test_acipher_cycles(req, enc,
-							  *b_size);
+							  bs);
 			}
 
 			if (ret) {
-- 
2.53.0



