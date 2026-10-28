Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213226;
	b=F+wRxwhgyjQ6WifQyIdRpHgDEI5wqugOagGExomrc4wCeqSmYZQNvRYI9u93wASWq6yA
	 JHPxcjMhjLisV5gyUN+qJOdCKpyRkekqSLDuvtbUJnGw/KIwpeTl3Z6C6IyM8wBzF/jFc
	 FmMoaisIf61ksva6sHB+MqUBJ1224MfTvuTJQrogp9S8j6UUXdIPd1+XcSb4GSUt0p/hV
	 +WZCmY8HxNkiniAjM7OzHCw9BWJPkS+cD/3JvtT77UHZGJbf0cNZOs97UePbVk4BhHQNw
	 Bs/SKLpUCsuGM9wDN86hkEQo+PhSdB4lmZgf77V/ug5jcRrVPc0/TSpUfdhtnO1tNyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213226;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tyzMJ4iNow4wH+NXtDX6mgjZ0Bc7yZcsP1XwZjASp3M=;
	b=oaYyb2GoYzwc8XZXhTPiOISlGD4gEObYPsi7Z6aVfeYwMpy6uB/iDeMk50MLCU6uqNad
	 xp+XYphkW3Oaezac1HY74KffvOzHhtfoAEwqes/pvirvNFqzyVBCXQz2fKuvkI5dfPUdR
	 y/RS7TPQP2ejIjCgeMOe89PBPoW5J/xBJdBXMNAQW96xVqMA7QlFKfbaM1OWOsgHYdRLQ
	 ezTdQPrNFlL0k0z/OWpXyFMlOUg3XyPQKCxBC5PalIYxAhZEBhvsUHV7nZCrxASMIDyxU
	 VjD1uWxdgFcKYp/qr8njN0T9mrdbeTJS315s5k491BsdX+IhEBjW55q9VPd/C5gR3Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tXhtOpKI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D429606A31C;
	Wed, 28 Oct 2026 18:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tXhtOpKI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2BC1F01825;
	Wed, 28 Oct 2026 18:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213226;
	bh=tyzMJ4iNow4wH+NXtDX6mgjZ0Bc7yZcsP1XwZjASp3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tXhtOpKIws4RNX8fOvKK02TRPLW3sTY5XoG3glji4+TcLi++B9M3BuxfPhSihTycC
	 Bpd3GJsvm3Sb+8wylhWwh29Xmff62eK92QGsAPebctLLvPktFe5Ew0zGU8CsSS2Dlp
	 j7H1AyLXmaI3U+6PPEIg8K1T6jnZ93o2j///z0Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0429/1887] crypto: drbg - Fix ineffective sanity check
Date: Wed, 28 Oct 2026 17:42:05 +0100
Message-ID: <20261028170508.995871750@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit 040ad83b0e8aa065fd2fc641cacba8491a8b186d upstream.

Fix drbg_healthcheck_sanity() to correctly check the return value of
drbg_generate().  drbg_generate() returns 0 on success, or a negative
errno value on failure.  drbg_healthcheck_sanity() incorrectly assumed
that it returned a positive value on success.

This didn't make the sanity check fail, but it made it ineffective.

Fixes: cde001e4c3c3 ("crypto: rng - RNGs must return 0 in success case")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/drbg.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 211757f3f9723..8d6dff6f8c9d1 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -2001,7 +2001,6 @@ static int drbg_kcapi_seed(struct crypto_rng *tfm,
  */
 static inline int __init drbg_healthcheck_sanity(void)
 {
-	int len = 0;
 #define OUTBUFLEN 16
 	unsigned char buf[OUTBUFLEN];
 	struct drbg_state *drbg = NULL;
@@ -2043,12 +2042,12 @@ static inline int __init drbg_healthcheck_sanity(void)
 	max_addtllen = drbg_max_addtl(drbg);
 	max_request_bytes = drbg_max_request_bytes(drbg);
 	drbg_string_fill(&addtl, buf, max_addtllen + 1);
-	/* overflow addtllen with additonal info string */
-	len = drbg_generate(drbg, buf, OUTBUFLEN, &addtl);
-	BUG_ON(0 < len);
+	/* overflow addtllen with additional info string */
+	ret = drbg_generate(drbg, buf, OUTBUFLEN, &addtl);
+	BUG_ON(ret == 0);
 	/* overflow max_bits */
-	len = drbg_generate(drbg, buf, (max_request_bytes + 1), NULL);
-	BUG_ON(0 < len);
+	ret = drbg_generate(drbg, buf, max_request_bytes + 1, NULL);
+	BUG_ON(ret == 0);
 
 	/* overflow max addtllen with personalization string */
 	ret = drbg_seed(drbg, &addtl, false);
-- 
2.53.0



