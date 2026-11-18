Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061101;
	b=HeibkrvURzFYx7v4l7oynqA3JMP3V+o/8+Y2vMW/d5OU987xbkCrAmAb+VGXtPL+KgeC
	 VbPdYON/eZchllHY5oaU74/ufoB2Y8IbF5Fs95/v2NmfCZCb103tZspv2m1sE96CS4lX4
	 6UK2SppU5LHp+j31BReT9PMrmC+HIDX6WIExDioAKmGzdk1j4yKs187EQQahLAlHDu4fg
	 N6TOGhv36bsobw5SrTt4ol0CTZZl6/kX3FLdyJEitYqPQGRxT1Jb+UlCSCc0f6Ki4qgRa
	 8HYnGduytyrmJn3CB7BuUydjcqq5wTpu2NiHv6Q7dUI+Ih3tL6LQ63jLP3pOmtSoWEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QFLACDlBzI3eP72UvLrDOfLjLtXKjmJUGKxkJTjJ4zo=;
	b=hjdU7y+cz0uWMzbNcIBfZIPyuEU0v2SuU4XTglFnY4e4q8unJu9FqAVADx1t0OzlOzn7
	 ott8MJb6ry6hbZb404Hd9ZbfC7MKl9vJxBukg/v24wMpCccIMqIm5QRxuOBAIeeyxg6b9
	 AVsJV0OdUYRWKMeeP3k+9vOeAariCgLNYDjdE8cEqPrFlAZ6ySu28BrNgJLJZUXnEKvUS
	 xYB+dPz9u/Rb0RTIzWxT5/fI8m3BdzOEpUh1neuEZlrSZe2GydH6QWDABEUAQOCQLZ5g2
	 PUmK37dnjS97bjpisFiolTPvIs/UZmW+EjdBmzaNOSUqkwrxkuvY2rjbMK2xvDhm6eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MkpiebzM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE59D606A325;
	Thu, 19 Nov 2026 04:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MkpiebzM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B541F000C5;
	Thu, 19 Nov 2026 04:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061100;
	bh=QFLACDlBzI3eP72UvLrDOfLjLtXKjmJUGKxkJTjJ4zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MkpiebzMkjOh3Kpweu/iugROuGuS+hmTOeyxyf4XfENzvAxFjfiR0kLd9eb8sWh5E
	 iLLVTK1BRURevaFUtGjVVdGI0rwYj9pkJMwPTXRi2gGe7P73yB6V3HH/SKEXhYSARC
	 fiNAWP4tW9zbra0MzAgTg0F/RNLSeln/udPL+c9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1434/1848] crypto: tcrypt - Drop leading newlines from prints
Date: Wed, 18 Nov 2026 15:57:52 +0100
Message-ID: <20261118150019.541882043@linuxfoundation.org>
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
index 2e5ac68dd2c22..3e06b02ff4d78 100644
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
@@ -1327,7 +1327,7 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 		return;
 	}
 
-	pr_info("\ntesting speed of %s %s (%s) %s\n", async ? "async" : "sync",
+	pr_info("testing speed of %s %s (%s) %s\n", async ? "async" : "sync",
 		algo, get_driver_name(crypto_skcipher, tfm), e);
 
 	req = skcipher_request_alloc(tfm, GFP_KERNEL);
-- 
2.53.0



