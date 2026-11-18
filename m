Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061092;
	b=BQpkbT+lO3gUk3eNfSApxYFW4eODLUPTMkHvPmoA3S7jzTp2aDB1/sTYko9SZeSoIczn
	 t0exUPMcq7IAubCgLJNRAcyZK4wYbCchm11anjcXfSoEMkwUHV+k5ig6nD5FX8B86nJL/
	 afyuzk3Sk6sklAUsF1t1oHgtxKBnnTjTCJUg5RBeTs78pAoOZUGYT/BEhWW6dqPAFKdiA
	 OL1mMmDMsiySSYvmbAKSEi6eVS5VQDvkMPh3e72i/9aamqr/zu4OQA4JhYmzcEdbzwVjG
	 6/hXyUjHH19GFWKw3pUoUmr7xX0Q3i3U2mJel0R3XLhCvFd9PXegtAzdPwoPwJYBUJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YUZUBZE8O4IqVEjvc5KZRwXA5nY3g/Lmb8kagWL2ltg=;
	b=qmnoLyZOAtj4ptmXetSk66c4g+Qj9K9Ox5syWSlllmyQHzvFQ0b5S8x8wCi/XU0CFg7I
	 I9gIgsWjJX+zAMAMf8837rWRfQJwpWj5p320YHjcnhyJyL42hJWssk+K71ikVIll+clVM
	 NF5VDHlW/jyJh1WLPgRN+yRVdrEWK0cc1E4yNfS7ZFkzG4GgyEo3gNlf/SbfJuu/PvAim
	 jWUFpXLAKCaEZn+6HsDHmzmSchfZ3GhOGwaCrN1Wxpt4pjaIaYa0rfSck3or+Ap2LFbjn
	 1b5Qx6pLLwC1DJs+OWpJIOV7pY6pv6z+Eh5faVFdQ6pk7ck10cNX1+QqyHvNrEdEQ/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxlKlkdb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41EB606A32C;
	Thu, 19 Nov 2026 04:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxlKlkdb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587251F000C4;
	Thu, 19 Nov 2026 04:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061091;
	bh=YUZUBZE8O4IqVEjvc5KZRwXA5nY3g/Lmb8kagWL2ltg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cxlKlkdbNeOBkAhBKkvs/GSxTD0xQQcxGrAEysUfjVt8bIaEJ4xTc7GLQaVYzgOlZ
	 rSuc6KM5wko5pJlDi/UU1fcAwr5dAPu8kC4Gy6viAZrgWLg/smeZZ1CI7B5k1PimTo
	 0MU7XZe7e4miaNe+rnW8U2Rw+e85dhaU5VysoJBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1431/1848] crypto: tcrypt - add asynchronous speed test for SM3
Date: Wed, 18 Nov 2026 15:57:49 +0100
Message-ID: <20261118150019.435510423@linuxfoundation.org>
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

[ Upstream commit ba2c149d0812cee653a186c9cfe451699b211c91 ]

tcrypt supports testing of SM3 hash algorithms that use AVX
instruction acceleration.

In order to add the sm3 asynchronous test to the appropriate
position, shift the testcase sequence number of the multi buffer
backward and start from 450.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 3a31a4baad67 ("crypto: tcrypt - Avoid reading req->base after submission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tcrypt.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index d5a95a2267bfe..7cc943af95137 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2566,31 +2566,35 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 422:
+		test_ahash_speed("sm3", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+		fallthrough;
+	case 450:
 		test_mb_ahash_speed("sha1", sec, generic_hash_speed_template,
 				    num_mb);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
-	case 423:
+	case 451:
 		test_mb_ahash_speed("sha256", sec, generic_hash_speed_template,
 				    num_mb);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
-	case 424:
+	case 452:
 		test_mb_ahash_speed("sha512", sec, generic_hash_speed_template,
 				    num_mb);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
-	case 425:
+	case 453:
 		test_mb_ahash_speed("sm3", sec, generic_hash_speed_template,
 				    num_mb);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
-	case 426:
+	case 454:
 		test_mb_ahash_speed("streebog256", sec,
 				    generic_hash_speed_template, num_mb);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
-	case 427:
+	case 455:
 		test_mb_ahash_speed("streebog512", sec,
 				    generic_hash_speed_template, num_mb);
 		if (mode > 400 && mode < 500) break;
-- 
2.53.0



