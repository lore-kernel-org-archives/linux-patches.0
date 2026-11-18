Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055642;
	b=GeCZpnCPIz5peabrES0iAGjX/Xy4y/DbvuFpar+isR4lGV7waUt/s10xnLa1ar3PEoda
	 2P9ua7Rv0KfsMZLMKJNTFrgq1k1YggFUmLRg7L5Af9xhPe0AKZcW8SbHGPli0ModAqaMP
	 oaXcGH4jhqFuxcD2+wRpZxDdtWVgQQ0tQv5L/PZnI8hUz4c+LYva/WCgv8vM7duqOpdi5
	 +9krCFy4zncd9WNwMDAumBXc8QlGaM9iBYyUoqYgaa7RkZ2racSgi2a+/1d7ROTj+m53G
	 0a2WqBjCoFd/d6ph483eFPVtCCteob+VQoikNTRy9Gyc5EWk9ozr7vSrCtlj6QJAGuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gw0Zfvipx8GSNonCaQGs2JjnKFRlqnvM5YnXHZPp57A=;
	b=GoRVMJAIO+xO6IEx5FqnsSPmWx8qSLBCAzxsnpHw5Pca+3mqM4dS8IBUAs84be4lo5Oa
	 JmnUueCCCVkSXVwi2GMi7wqZZSo2A7oubwZbNIuAJY93mpS6JR2pzJY3fTRY33aTdWp08
	 k9ZClaEVwVAujCtYG01oPEBdgZQYDKUW29INADA1ua9+s6rDtRJtNk/8ZzwrPuZhLb98N
	 Zx/wB5Osfo+eXqZqrv4z0mnnxY02fv8pprDWF9YqqLEdJxGccwtLy+/cdwB3f0gGMYKoP
	 zGS1SyMBxwRUewKryz1XfH2z5X9cn1lNqRbqCYpEdX11gByzWQcml4/eA2kZ6/YpAWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="odp1/bs9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DD4606A320;
	Thu, 19 Nov 2026 02:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=odp1/bs9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30DB1F000C4;
	Thu, 19 Nov 2026 02:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055642;
	bh=Gw0Zfvipx8GSNonCaQGs2JjnKFRlqnvM5YnXHZPp57A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=odp1/bs9NAHnUTFr2XKDMwiu+TqneE+I2xg4Y+N1yxJ0Pq0yOjx74fXdP6wEt4QZL
	 GiQgkpMbNIEszNaOmswS3enFduvI2vc3XRoaL8Hh6rBpMP6s753Czu+tg1aKtFpZm+
	 DvyhYnvNc+wrkp1YTBcH0cfF39negMIz07Bi8fv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1704/2214] crypto: tcrypt - add asynchronous speed test for SM3
Date: Wed, 18 Nov 2026 15:56:20 +0100
Message-ID: <20261118150119.956193444@linuxfoundation.org>
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
index 4ada7e7493904..d350f07d189b7 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2550,31 +2550,35 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
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



