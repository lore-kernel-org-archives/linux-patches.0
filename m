Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055645;
	b=HlxLti1sBKxiET77MmzmZI8v9WttH5X6tbmTuOwEI+ZNb6hNBelZvkXEx94NEGUJawXL
	 TLq4YOLl6eLmiNI8c9eIomKRNL/mjkEh1QEjL3V5MpuiFKhcEaFkEca4CzVGx3VlsapFr
	 eTN3G7xOgrgfDYUWATtRwQ5u7RH36gP6KE2e2EMy9Pld3d9ZB6upoje6gY5q+6kHe+0NV
	 8yEi1MJ7faRuSTOBx05ZrBWsxs9LreRVGvyOr8H23j1DPcNGnjqM792lSxz3OEc8LSata
	 E2eam7srV7Z3fuZj7Ve8eY0hkUKhf9tjOSg8EpO+UjTPWcuYnqixfzg1kf+jVnkeJpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055645;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4e64HgLxxufJYYswXBfYtb00gIlITvzHUuR+4jPXfBI=;
	b=ibJckOm+qL5yAlFifSk0/8/FBi/gI51Ybhe57MlZti8gvKEiKAdcZJFyCbkNwDcQYvxZ
	 VZqgdiNWQgoV2KVl6WocavzLw1M7Mi2JyvefwPYlk/hR3kVUJrp+qTzPvuklLFXLEiKAJ
	 r+f/0uwkXMIbl8wXRBfeAFGA6p1X0dasHx2Ws0HuVxEFOQeQjy9S+iBnIWtraDjdfjsfx
	 wD6ka9fle9fQgdjLxfSeai7UsbZQqOgN8XRweLYHC7pATMZY6ZVefE+b4EmXmQ3Df7J4y
	 UfCp/57xmFlniznRB7vHOkDo+mX4clS7eWZCeKMJppooEWvlFZxP9djNmOLZ7YV6WVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wEg7pIp+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F934606A325;
	Thu, 19 Nov 2026 02:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wEg7pIp+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792C11F000C4;
	Thu, 19 Nov 2026 02:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055645;
	bh=4e64HgLxxufJYYswXBfYtb00gIlITvzHUuR+4jPXfBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wEg7pIp+S9MAUwtaYv/ENMch27EW/hNDeqd0lkjsCBOgVa4rMNrmUo319xIQHaPoH
	 rYeoDaP84Un00fhRA87pCf2L97HWrdtkJe8xkOteqQQagHvahoniPmJvI9DCcS9WKP
	 pVx28IjOEGEeLqiTEK28jNbRBXlLI9N/jP9nEIVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1705/2214] crypto: tcrypt - remove all multibuffer ahash tests
Date: Wed, 18 Nov 2026 15:56:21 +0100
Message-ID: <20261118150119.994461772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit 388ac25efc8ce3bf9768ce7bf24268d6fac285d5 ]

The multibuffer algorithms was removed already in 2018, so it is
necessary to clear the test code left by tcrypt.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 3a31a4baad67 ("crypto: tcrypt - Avoid reading req->base after submission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tcrypt.c | 224 ------------------------------------------------
 1 file changed, 224 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index d350f07d189b7..1558c17614cfa 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -724,200 +724,6 @@ static inline int do_one_ahash_op(struct ahash_request *req, int ret)
 	return crypto_wait_req(ret, wait);
 }
 
-struct test_mb_ahash_data {
-	struct scatterlist sg[XBUFSIZE];
-	char result[64];
-	struct ahash_request *req;
-	struct crypto_wait wait;
-	char *xbuf[XBUFSIZE];
-};
-
-static inline int do_mult_ahash_op(struct test_mb_ahash_data *data, u32 num_mb,
-				   int *rc)
-{
-	int i, err = 0;
-
-	/* Fire up a bunch of concurrent requests */
-	for (i = 0; i < num_mb; i++)
-		rc[i] = crypto_ahash_digest(data[i].req);
-
-	/* Wait for all requests to finish */
-	for (i = 0; i < num_mb; i++) {
-		rc[i] = crypto_wait_req(rc[i], &data[i].wait);
-
-		if (rc[i]) {
-			pr_info("concurrent request %d error %d\n", i, rc[i]);
-			err = rc[i];
-		}
-	}
-
-	return err;
-}
-
-static int test_mb_ahash_jiffies(struct test_mb_ahash_data *data, int blen,
-				 int secs, u32 num_mb)
-{
-	unsigned long start, end;
-	int bcount;
-	int ret = 0;
-	int *rc;
-
-	rc = kcalloc(num_mb, sizeof(*rc), GFP_KERNEL);
-	if (!rc)
-		return -ENOMEM;
-
-	for (start = jiffies, end = start + secs * HZ, bcount = 0;
-	     time_before(jiffies, end); bcount++) {
-		ret = do_mult_ahash_op(data, num_mb, rc);
-		if (ret)
-			goto out;
-	}
-
-	pr_cont("%d operations in %d seconds (%llu bytes)\n",
-		bcount * num_mb, secs, (u64)bcount * blen * num_mb);
-
-out:
-	kfree(rc);
-	return ret;
-}
-
-static int test_mb_ahash_cycles(struct test_mb_ahash_data *data, int blen,
-				u32 num_mb)
-{
-	unsigned long cycles = 0;
-	int ret = 0;
-	int i;
-	int *rc;
-
-	rc = kcalloc(num_mb, sizeof(*rc), GFP_KERNEL);
-	if (!rc)
-		return -ENOMEM;
-
-	/* Warm-up run. */
-	for (i = 0; i < 4; i++) {
-		ret = do_mult_ahash_op(data, num_mb, rc);
-		if (ret)
-			goto out;
-	}
-
-	/* The real thing. */
-	for (i = 0; i < 8; i++) {
-		cycles_t start, end;
-
-		start = get_cycles();
-		ret = do_mult_ahash_op(data, num_mb, rc);
-		end = get_cycles();
-
-		if (ret)
-			goto out;
-
-		cycles += end - start;
-	}
-
-	pr_cont("1 operation in %lu cycles (%d bytes)\n",
-		(cycles + 4) / (8 * num_mb), blen);
-
-out:
-	kfree(rc);
-	return ret;
-}
-
-static void test_mb_ahash_speed(const char *algo, unsigned int secs,
-				struct hash_speed *speed, u32 num_mb)
-{
-	struct test_mb_ahash_data *data;
-	struct crypto_ahash *tfm;
-	unsigned int i, j, k;
-	int ret;
-
-	data = kcalloc(num_mb, sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return;
-
-	tfm = crypto_alloc_ahash(algo, 0, 0);
-	if (IS_ERR(tfm)) {
-		pr_err("failed to load transform for %s: %ld\n",
-			algo, PTR_ERR(tfm));
-		goto free_data;
-	}
-
-	for (i = 0; i < num_mb; ++i) {
-		if (testmgr_alloc_buf(data[i].xbuf))
-			goto out;
-
-		crypto_init_wait(&data[i].wait);
-
-		data[i].req = ahash_request_alloc(tfm, GFP_KERNEL);
-		if (!data[i].req) {
-			pr_err("alg: hash: Failed to allocate request for %s\n",
-			       algo);
-			goto out;
-		}
-
-		ahash_request_set_callback(data[i].req, 0, crypto_req_done,
-					   &data[i].wait);
-
-		sg_init_table(data[i].sg, XBUFSIZE);
-		for (j = 0; j < XBUFSIZE; j++) {
-			sg_set_buf(data[i].sg + j, data[i].xbuf[j], PAGE_SIZE);
-			memset(data[i].xbuf[j], 0xff, PAGE_SIZE);
-		}
-	}
-
-	pr_info("\ntesting speed of multibuffer %s (%s)\n", algo,
-		get_driver_name(crypto_ahash, tfm));
-
-	for (i = 0; speed[i].blen != 0; i++) {
-		/* For some reason this only tests digests. */
-		if (speed[i].blen != speed[i].plen)
-			continue;
-
-		if (speed[i].blen > XBUFSIZE * PAGE_SIZE) {
-			pr_err("template (%u) too big for tvmem (%lu)\n",
-			       speed[i].blen, XBUFSIZE * PAGE_SIZE);
-			goto out;
-		}
-
-		if (klen)
-			crypto_ahash_setkey(tfm, tvmem[0], klen);
-
-		for (k = 0; k < num_mb; k++)
-			ahash_request_set_crypt(data[k].req, data[k].sg,
-						data[k].result, speed[i].blen);
-
-		pr_info("test%3u "
-			"(%5u byte blocks,%5u bytes per update,%4u updates): ",
-			i, speed[i].blen, speed[i].plen,
-			speed[i].blen / speed[i].plen);
-
-		if (secs) {
-			ret = test_mb_ahash_jiffies(data, speed[i].blen, secs,
-						    num_mb);
-			cond_resched();
-		} else {
-			ret = test_mb_ahash_cycles(data, speed[i].blen, num_mb);
-		}
-
-
-		if (ret) {
-			pr_err("At least one hashing failed ret=%d\n", ret);
-			break;
-		}
-	}
-
-out:
-	for (k = 0; k < num_mb; ++k)
-		ahash_request_free(data[k].req);
-
-	for (k = 0; k < num_mb; ++k)
-		testmgr_free_buf(data[k].xbuf);
-
-	crypto_free_ahash(tfm);
-
-free_data:
-	kfree(data);
-}
-
 static int test_ahash_jiffies_digest(struct ahash_request *req, int blen,
 				     char *out, int secs)
 {
@@ -2553,36 +2359,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		test_ahash_speed("sm3", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
-	case 450:
-		test_mb_ahash_speed("sha1", sec, generic_hash_speed_template,
-				    num_mb);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
-	case 451:
-		test_mb_ahash_speed("sha256", sec, generic_hash_speed_template,
-				    num_mb);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
-	case 452:
-		test_mb_ahash_speed("sha512", sec, generic_hash_speed_template,
-				    num_mb);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
-	case 453:
-		test_mb_ahash_speed("sm3", sec, generic_hash_speed_template,
-				    num_mb);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
-	case 454:
-		test_mb_ahash_speed("streebog256", sec,
-				    generic_hash_speed_template, num_mb);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
-	case 455:
-		test_mb_ahash_speed("streebog512", sec,
-				    generic_hash_speed_template, num_mb);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
 	case 499:
 		break;
 
-- 
2.53.0



