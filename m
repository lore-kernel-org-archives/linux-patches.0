Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061089;
	b=p6qT4AgFt8HnU756hq5n6ds1SnnyWK7iS+OAjCFUa+MG3HDc5iIonZdLhToTfR0IEksu
	 Xsru84BMcoOhKDz65G2WlLS4NOL8/JAbyyZlrGueNv9FN/WJ/Ptpw68wXlxt/U1v5hSNr
	 Uaich/qxUzVOnr8L4yqqSFYtr4N34x8YWmD6Wa2YJ5LpszqPAg5hovl2SeJZvFIymI6KD
	 UGnifHcE2K/dIdCANsQA60CcDDXh+Y2CCvqtikT8MkO2vUG5vh+aBafKqOd+c1o18+wZj
	 dqR1LeQ1+gfYlXTrVNFmya6WuQbB1IKGMEJ3ZWX5FV6OMFWbIwiq4RhqD4J5wZjHhtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dzad6vLfBN3dXNxxxc81VhC6WwByc8Vs1ROMzUTEavg=;
	b=o47HPRMASIw2st73HWXTO2Rq84iqpPfx1CUMdZ/GGR2LMByaCr6zOaEnNMkjeVE6Omvi
	 jj7zVm9D6ThGmv9/5yRRQWRi0CRg9ewBdEYIIaqlNkkLShVchq1kxWyHnQAR/p4mQe0K9
	 dr9c6lBPNwEMT39VTgOd4MGzJXo1pt8CQCRoUplxfwh166L0gUw8Q0pHF9HzlWO0UHH6g
	 S+iKfntoKFH6ohfizBD05V/nQfVekf7Rv+x7O8GKi5oRguuTxRDkSa8Jk+ZByvtSgUi/n
	 6Zaj1MC+8qTkEcoEJIKYUne3USuaOU4Gw2wLsdmMLFMhqYAihbiu+dCGj8+Cuv2e+6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZA+PDdtv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F361606A320;
	Thu, 19 Nov 2026 04:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZA+PDdtv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AF51F000C4;
	Thu, 19 Nov 2026 04:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061089;
	bh=dzad6vLfBN3dXNxxxc81VhC6WwByc8Vs1ROMzUTEavg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZA+PDdtvD6xmsMnhxnChcDmUZpPnI5MK24D00zToQ6Tcie//ioZsmTL6iPprbvnt3
	 b9id0I7RffLr+kEZ4q/roniddCvhPKvwknEeGXF3pnp8hrE/UTeQjSNs0uJf1X2D9K
	 l3hfFKcE8Gd15OEAuxndO2iVgpFBqPdycQ+AHvIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	Vitaly Chikunov <vt@altlinux.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1430/1848] crypto: tcrypt - Fix missing return value check
Date: Wed, 18 Nov 2026 15:57:48 +0100
Message-ID: <20261118150019.399665481@linuxfoundation.org>
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

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit 7b3d52683b3a47c0ba1dfd6b5994a3a795b06972 ]

There are several places where the return value check of crypto_aead_setkey
and crypto_aead_setauthsize were lost. It is necessary to add these checks.

At the same time, move the crypto_aead_setauthsize() call out of the loop,
and only need to call it once after load transform.

Fixee: 53f52d7aecb4 ("crypto: tcrypt - Added speed tests for AEAD crypto alogrithms in tcrypt test suite")
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Reviewed-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 3a31a4baad67 ("crypto: tcrypt - Avoid reading req->base after submission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tcrypt.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index de0dadf977c08..d5a95a2267bfe 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -290,6 +290,11 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 	}
 
 	ret = crypto_aead_setauthsize(tfm, authsize);
+	if (ret) {
+		pr_err("alg: aead: Failed to setauthsize for %s: %d\n", algo,
+		       ret);
+		goto out_free_tfm;
+	}
 
 	for (i = 0; i < num_mb; ++i)
 		if (testmgr_alloc_buf(data[i].xbuf)) {
@@ -315,7 +320,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 	for (i = 0; i < num_mb; ++i) {
 		data[i].req = aead_request_alloc(tfm, GFP_KERNEL);
 		if (!data[i].req) {
-			pr_err("alg: skcipher: Failed to allocate request for %s\n",
+			pr_err("alg: aead: Failed to allocate request for %s\n",
 			       algo);
 			while (i--)
 				aead_request_free(data[i].req);
@@ -567,13 +572,19 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	sgout = &sg[9];
 
 	tfm = crypto_alloc_aead(algo, 0, 0);
-
 	if (IS_ERR(tfm)) {
 		pr_err("alg: aead: Failed to load transform for %s: %ld\n", algo,
 		       PTR_ERR(tfm));
 		goto out_notfm;
 	}
 
+	ret = crypto_aead_setauthsize(tfm, authsize);
+	if (ret) {
+		pr_err("alg: aead: Failed to setauthsize for %s: %d\n", algo,
+		       ret);
+		goto out_noreq;
+	}
+
 	crypto_init_wait(&wait);
 	printk(KERN_INFO "\ntesting speed of %s (%s) %s\n", algo,
 			get_driver_name(crypto_aead, tfm), e);
@@ -611,8 +622,13 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 					break;
 				}
 			}
+
 			ret = crypto_aead_setkey(tfm, key, *keysize);
-			ret = crypto_aead_setauthsize(tfm, authsize);
+			if (ret) {
+				pr_err("setkey() failed flags=%x: %d\n",
+					crypto_aead_get_flags(tfm), ret);
+				goto out;
+			}
 
 			iv_len = crypto_aead_ivsize(tfm);
 			if (iv_len)
@@ -622,15 +638,8 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 			printk(KERN_INFO "test %u (%d bit key, %d byte blocks): ",
 					i, *keysize * 8, bs);
 
-
 			memset(tvmem[0], 0xff, PAGE_SIZE);
 
-			if (ret) {
-				pr_err("setkey() failed flags=%x\n",
-						crypto_aead_get_flags(tfm));
-				goto out;
-			}
-
 			sg_init_aead(sg, xbuf, bs + (enc ? 0 : authsize),
 				     assoc, aad_size);
 
-- 
2.53.0



