Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055650;
	b=S1MMLzHeL0yEP5L1NTdggCM580zeNmQuM52tJ9pMMPoMxhNTNs0Vxf1gmdNAwCjDE3Q7
	 jGLrqWfBM0Klemjzunx6bp1HwZqptEjpyxZYq43/oyy9CmZV0QEqYiykifnzZ9taoz0RX
	 zlOQE5B6q43ospfU7/uBc/kTthz+YBotzBkDEHrOMRAqH30OiWPYIPLsi9xtBWisThZxY
	 QTcIqSaWyNfty2SusAebaOBrkFZOAO495uAvKX6uYpbZSMxPERd0yUWWz6Hlx60Eppk4E
	 aX/ZaQmFmURdQ5a8/0IinHyHoHc+riUd5Est9xqh1IZDYVvLbkhkDCyw4cLSG9/PuVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055650;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=37RSR2hiwWXP+KmQpUcF0rMtjPXEb4Q7Cf2TBYU7sjo=;
	b=SkzdHU3Wiry4OkKGHGrl+FHcATp6UaexcTTIJiOIttBVuFDlkuo9zkZyj2c4IxMXke6O
	 xC/TIJTJ3R4ZEFIY55OliqeE+t8Uqg6OyHBy1BP3Mwcd6UHtGBIzqCUADDlNc4UXe24BS
	 g9NflhRq2MyCaJWgbVJ5NO4lNXNT6+Mwoui+1+c9/VVBKcjFSbMAuzBoPrxLKYTTHhUjh
	 ktQJMi3dTA5o1XxPUEZP/U3baRAsXbevpc69PBqXLp1JQ6P3yQhLE04xPle+q+I6Zu66p
	 +DRFWv8qG6j1vxPic/3bqgufl3qUBf8f//SurnvBTEntSDIv/LuiEL+u7gRceC8tgpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HM/BZQnC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C383606A32A;
	Thu, 19 Nov 2026 02:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HM/BZQnC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FCE1F000C4;
	Thu, 19 Nov 2026 02:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055650;
	bh=37RSR2hiwWXP+KmQpUcF0rMtjPXEb4Q7Cf2TBYU7sjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HM/BZQnCQN98uc2gaFTh3OZlfaBuyW+WDznxw6OCeCWY+pr0K4oax3oFwdO8ggs/A
	 PAWS2rUGUSx58M1V8/s8R6rLyi7B/10F7fhZicVgz+nHu86Q7jR6JzYgN1IIVO2ny/
	 9k/QeyO9sRhm/fZiNQqfe9Np5nzTg7xkb56VrFQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1707/2214] crypto: tcrypt - Drop leading newlines from prints
Date: Wed, 18 Nov 2026 15:56:23 +0100
Message-ID: <20261118150120.067605199@linuxfoundation.org>
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

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

[ Upstream commit 3513828cb8f6db714ee48b1559e6253a57ecf1f6 ]

The top level print banners have a leading newline. It's not entirely
clear why this exists, but it makes it harder to parse tcrypt test output
using a script. Drop said newlines.

tcrypt output before this patch:

[...]
      testing speed of rfc4106(gcm(aes)) (rfc4106-gcm-aesni) encryption
[...] test 0 (160 bit key, 16 byte blocks): 1 operation in 2320 cycles (16 bytes)

tcrypt output with this patch:

[...] testing speed of rfc4106(gcm(aes)) (rfc4106-gcm-aesni) encryption
[...] test 0 (160 bit key, 16 byte blocks): 1 operation in 2320 cycles (16 bytes)

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 3a31a4baad67 ("crypto: tcrypt - Avoid reading req->base after submission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tcrypt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 32fbdde60a669..fd45788a1529e 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -335,7 +335,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 					  crypto_req_done, &data[i].wait);
 	}
 
-	pr_info("\ntesting speed of multibuffer %s (%s) %s\n", algo,
+	pr_info("testing speed of multibuffer %s (%s) %s\n", algo,
 		get_driver_name(crypto_aead, tfm), e);
 
 	i = 0;
@@ -586,7 +586,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	}
 
 	crypto_init_wait(&wait);
-	pr_info("\ntesting speed of %s (%s) %s\n", algo,
+	pr_info("testing speed of %s (%s) %s\n", algo,
 		get_driver_name(crypto_aead, tfm), e);
 
 	req = aead_request_alloc(tfm, GFP_KERNEL);
@@ -888,7 +888,7 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 		return;
 	}
 
-	pr_info("\ntesting speed of async %s (%s)\n", algo,
+	pr_info("testing speed of async %s (%s)\n", algo,
 		get_driver_name(crypto_ahash, tfm));
 
 	if (crypto_ahash_digestsize(tfm) > MAX_DIGEST_SIZE) {
@@ -1119,7 +1119,7 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 		crypto_init_wait(&data[i].wait);
 	}
 
-	pr_info("\ntesting speed of multibuffer %s (%s) %s\n", algo,
+	pr_info("testing speed of multibuffer %s (%s) %s\n", algo,
 		get_driver_name(crypto_skcipher, tfm), e);
 
 	i = 0;
@@ -1326,7 +1326,7 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 		return;
 	}
 
-	pr_info("\ntesting speed of %s %s (%s) %s\n", async ? "async" : "sync",
+	pr_info("testing speed of %s %s (%s) %s\n", async ? "async" : "sync",
 		algo, get_driver_name(crypto_skcipher, tfm), e);
 
 	req = skcipher_request_alloc(tfm, GFP_KERNEL);
-- 
2.53.0



