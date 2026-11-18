Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048938;
	b=FWOdNt5fibgLjaJAeKpfs59eewLS49kHiMh3CnqO9smIq6QJHwU/xtOSAPn8PDxb7mNC
	 9okhEndBhj7qEoCsvBk+jyDMxqTiJNACzTOEpTRtLX3SNNGHcQZJihFDuHMAwVSE7GY+2
	 8chu9+8GTbUUJseXTL5ft19ircroiZdQZCDM4EaAA1I9e9bdgthHv2QHkKEkwJn3NP2pt
	 gnSL3paOjxjt+6Ln3lcvAGlT3mWgEp3KmoHrE7qw+WSIvYmeFP6SlQzJY+yJ8Wkf44rz2
	 MWZaXsaJsGNlHyUVyMzQm5HhhMcZNbN9Sn0vqyTOAx5Snr6bnA6eBwE+TeKfx0oVVNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wOjk1fZHXF1C4eghyRRWzRsxvJK1SpRfCj6Y1iy4zds=;
	b=zswwpCP0d/SEn3kffqVyXaTZOrr7uqHe3BrFi+PFCGveJkzcQYtRvnkrA7DH9wXVxPtI
	 LLJ//DLWSBIKliNMTcaOJsWMBVW6zmlNQ2P4TlsB9hWanHij7/v8hmkmQLhAiKmghvg4u
	 TniPR+nHImAzn7N9zjdNIM+X93OmomNsw1iSxPgOX9EmIDiuIucbUtslzWaYprakUTnoq
	 LpemTzpVcTWOjY2gZyb46A349tPu/jXhryJYRljGtb6zEtwPU8Q/+d2VtgAYRJlmDXoSc
	 GLV7YNWE09wzPDr0lr1ZpjaXdEe/Pk36C2CYmDOAWf4SyBQbyXgD0wOOGHRSyUEtcLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZEtlGaiN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14EC606A320;
	Thu, 19 Nov 2026 00:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZEtlGaiN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A27D1F000C4;
	Thu, 19 Nov 2026 00:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048938;
	bh=wOjk1fZHXF1C4eghyRRWzRsxvJK1SpRfCj6Y1iy4zds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZEtlGaiNKivfygWH2wOAzv6VKE6TJG6iB5IY3h+qjhYGhr9W78F+VyLQtOhIXOcJx
	 esu5/tCTZmTJKGZ4cprFSmIT0yEd6Tb6r95ReEL7Y7DBZdfIgYR6533Fjpk3cPvBKF
	 J0kpWcVeRrPQvleTHPf+2mYcZ2lyq9m66dE3iD8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2174/2857] crypto: tcrypt - Use pr_info/pr_err
Date: Wed, 18 Nov 2026 15:53:28 +0100
Message-ID: <20261118150319.680564086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

[ Upstream commit 837a99f59043c3505d69761575172da1d09220b5 ]

Currently, there's mixed use of printk() and pr_info()/pr_err(). The latter
prints the module name (because pr_fmt() is defined so) but the former does
not. As a result there's inconsistency in the printed output. For example:

modprobe mode=211:

[...] test 0 (160 bit key, 16 byte blocks): 1 operation in 2320 cycles (16 bytes)
[...] test 1 (160 bit key, 64 byte blocks): 1 operation in 2336 cycles (64 bytes)

modprobe mode=215:

[...] tcrypt: test 0 (160 bit key, 16 byte blocks): 1 operation in 2173 cycles (16 bytes)
[...] tcrypt: test 1 (160 bit key, 64 byte blocks): 1 operation in 2241 cycles (64 bytes)

Replace all instances of printk() with pr_info()/pr_err() so that the
module name is printed consistently.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 3a31a4baad67 ("crypto: tcrypt - Avoid reading req->base after submission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tcrypt.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index b23235d58a122..a1807652d1325 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -575,8 +575,8 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	}
 
 	crypto_init_wait(&wait);
-	printk(KERN_INFO "\ntesting speed of %s (%s) %s\n", algo,
-			get_driver_name(crypto_aead, tfm), e);
+	pr_info("\ntesting speed of %s (%s) %s\n", algo,
+		get_driver_name(crypto_aead, tfm), e);
 
 	req = aead_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
@@ -624,8 +624,8 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 				memset(iv, 0xff, iv_len);
 
 			crypto_aead_clear_flags(tfm, ~0);
-			printk(KERN_INFO "test %u (%d bit key, %d byte blocks): ",
-					i, *keysize * 8, bs);
+			pr_info("test %u (%d bit key, %d byte blocks): ",
+				i, *keysize * 8, bs);
 
 			memset(tvmem[0], 0xff, PAGE_SIZE);
 
@@ -877,8 +877,8 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 		return;
 	}
 
-	printk(KERN_INFO "\ntesting speed of async %s (%s)\n", algo,
-			get_driver_name(crypto_ahash, tfm));
+	pr_info("\ntesting speed of async %s (%s)\n", algo,
+		get_driver_name(crypto_ahash, tfm));
 
 	if (crypto_ahash_digestsize(tfm) > MAX_DIGEST_SIZE) {
 		pr_err("digestsize(%u) > %d\n", crypto_ahash_digestsize(tfm),
@@ -2876,7 +2876,7 @@ static int __init tcrypt_mod_init(void)
 	err = do_test(alg, type, mask, mode, num_mb);
 
 	if (err) {
-		printk(KERN_ERR "tcrypt: one or more tests failed!\n");
+		pr_err("one or more tests failed!\n");
 		goto err_free_tv;
 	} else {
 		pr_debug("all tests passed\n");
-- 
2.53.0



