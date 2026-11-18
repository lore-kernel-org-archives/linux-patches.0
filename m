Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061097;
	b=i4sc4jMz1j8GB0nX0A775/8ur5LSNilSWAmnO+qP1TJdRUWcoOBaNY0+u/2A9e/w8ihL
	 Qz++jBIzaKdagDg79V6rBZTNby1xNJph5b9uu80mpbE5o2WC2EDwcj9dwUcAhqDUxtnvV
	 Z+S9hYS2LWfJ617++H9tJ+b9r6J73MksZYv3N3D8uHVYMh9F+CqigaG9XqHfzXq7upfnT
	 H7OYX+jRhuJzDogK0RJcKFuGzcBdrCK+mwD4SK+lbH6ZftpTHDy83CYy98hrBHizMwAC8
	 OfdWRtil17GL+5wiz9ZpxLYGxAiIwElvNNRvYrp28jmUc7/XKs6xrqiWRP3uyXtKXtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WxFmYrgL838IS07yZsOXax4XrE3/VSiZ0Tx6hpEvJ0c=;
	b=b5nQTqCkiXyf6iru60fKIlqWKTqhidrED467ojKGGdxSxw+Q02EvfFkYm6zijZL/ILjH
	 bzpegsrZOzIDjoZvn2fvpvf01UIDpjvErXMcB1OgmHXAHlQ4hdHMg7WDwINYjrY+3iEdC
	 Y9etw68unkDD7PhbMZmwWP3LETzw7hi7dRTJyHOl9eIlKOCj9qKU0jIHnGa6st6hV3yqu
	 SETk98ne4ltMM3VpIJm2Umr4aC4W6N8m8aAUPFI06/+KAZr7qTXMpPN4CGoKL9YNCkcUh
	 cGeek0w4QAjgBSBOMhZXidJrGzuc05pMiouLOiad/m0fPJThfu49aq5picCY43ulqSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uxBz4r8f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF185606A325;
	Thu, 19 Nov 2026 04:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uxBz4r8f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390161F000C4;
	Thu, 19 Nov 2026 04:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061097;
	bh=WxFmYrgL838IS07yZsOXax4XrE3/VSiZ0Tx6hpEvJ0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uxBz4r8f69LYiZ443wqYHQ1Iq2gLjpByE1WgWqQSfr8LxVV5RKRa5VzbtnLjZN0Jv
	 h4P4JhKUI8ctF44W1d/ETR3Rmdr3Drx89XmnEEdBoUknDK1DMMggTSEfMHkRJQcw16
	 zQX5gHqOUTV32kh5BPTJJcZ7QmidmygF8faGBz40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1433/1848] crypto: tcrypt - Use pr_info/pr_err
Date: Wed, 18 Nov 2026 15:57:51 +0100
Message-ID: <20261118150019.505986255@linuxfoundation.org>
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
index 2dfe1ef471a0b..2e5ac68dd2c22 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -586,8 +586,8 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	}
 
 	crypto_init_wait(&wait);
-	printk(KERN_INFO "\ntesting speed of %s (%s) %s\n", algo,
-			get_driver_name(crypto_aead, tfm), e);
+	pr_info("\ntesting speed of %s (%s) %s\n", algo,
+		get_driver_name(crypto_aead, tfm), e);
 
 	req = aead_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
@@ -635,8 +635,8 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 				memset(iv, 0xff, iv_len);
 
 			crypto_aead_clear_flags(tfm, ~0);
-			printk(KERN_INFO "test %u (%d bit key, %d byte blocks): ",
-					i, *keysize * 8, bs);
+			pr_info("test %u (%d bit key, %d byte blocks): ",
+				i, *keysize * 8, bs);
 
 			memset(tvmem[0], 0xff, PAGE_SIZE);
 
@@ -888,8 +888,8 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 		return;
 	}
 
-	printk(KERN_INFO "\ntesting speed of async %s (%s)\n", algo,
-			get_driver_name(crypto_ahash, tfm));
+	pr_info("\ntesting speed of async %s (%s)\n", algo,
+		get_driver_name(crypto_ahash, tfm));
 
 	if (crypto_ahash_digestsize(tfm) > MAX_DIGEST_SIZE) {
 		pr_err("digestsize(%u) > %d\n", crypto_ahash_digestsize(tfm),
@@ -2824,7 +2824,7 @@ static int __init tcrypt_mod_init(void)
 	err = do_test(alg, type, mask, mode, num_mb);
 
 	if (err) {
-		printk(KERN_ERR "tcrypt: one or more tests failed!\n");
+		pr_err("one or more tests failed!\n");
 		goto err_free_tv;
 	} else {
 		pr_debug("all tests passed\n");
-- 
2.53.0



