Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063959;
	b=ikcg0KHmBlipCnhAxXI593OB0NLSoVNjcI/33U4c2nkg1qS1u4p5P/JeShJlabwcy04L
	 RtGvJXeTZuivPHuBtK+W98BxixKD1UWNjnhu0jR2VsjD8Su4A1SdvzzokZ6h+1eevIJrv
	 36n1/E6ACh2+PQxMCbzjK/jWGuOfq/JQxEtGzY8rRtnUCxa77Baud41sMHJlbHMuuXHMT
	 5z3Sp85b/Y3X53twEZBfNCeUnXN3VtJeKUD09iRlcYxtniDO1ec8khBdlko5SgLN5n6rP
	 m4EeZ8OX03B9TqxZIVQG1OWYru3i3JRhmisgpsJoH61vvsYm2K6t7h5ybDwoo5b8LFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Yz5RYypp0+ypo4NNkOK5jEetxy/MtLxGYvlXPQShHc=;
	b=XBCYgAQTnwQp7ZrA+21i21rAFo/VZpvpafq621GfSxznsGBwXupb9WO0I6jse6BlGfTD
	 Ol1F7HSToIkrWqe2c2yFTcl/K8BujxykHQCkwpv/EF/ToQ4dXbV7TjXTAWrkvgWrJGTAk
	 D13WMerHM5adskR/4hSL6PSuWgpy76CdBog0Qjf1HoEfxLFQ/InGaCZd6mAAUhM6kgUPu
	 ACUEoGaCt/moNFCiQNQIDYASW486NdCVIQky7sB+ZULEz+Erjd6R3ASVi4DRwKM7yPGMw
	 8G+P20KSRcR3m8LPzm1Usgznhe4BklnLwjLEDeyeFExfNV25Gg4lRpghTrPkcHFkdxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sVi1n++A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B02C606EE97;
	Sat,  7 Nov 2026 15:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sVi1n++A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C815C1F008A1;
	Sat,  7 Nov 2026 15:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063959;
	bh=+Yz5RYypp0+ypo4NNkOK5jEetxy/MtLxGYvlXPQShHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sVi1n++Am6rbPkQslGeMWMU4fL0JpjOVSZXrOqcdi0f3MbmBEXzJWjes9nzisDoDx
	 7r9KGgCgVhClKn527cQfFhX32b70ly60ZMXUak/hDDwnl0PEuR/8nObOgboHeWuToY
	 SkeAy6rpOTi5bMvCU32kmflsJ/OHMPNn4NB+FrY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0147/1257] crypto: atmel-aes - fix AADLENR for standalone GHASH
Date: Sat,  7 Nov 2026 08:40:43 -0500
Message-ID: <20261107134943.372504440@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 0dd8cded0e6f8c9635fe1d79d60dc7b2599b099b ]

atmel_aes_gcm_ghash_init() writes dd->total, the request's text length,
to AES_AADLENR.  But the GHASH it runs hashes the dd->datalen bytes passed
in: the 16-byte length block, or the padded IV when the IV is not 96 bits.
The data sheet requires AES_AADLENR to hold the length of that input.

With empty plaintext and empty AAD, dd->total is 0 and the tag comes out
wrong.  Later requests only pass because dd->total still holds the
previous request's length.

This is testmgr's first gcm(aes) vector, so CONFIG_CRYPTO_SELFTESTS=y
fails at boot:

  alg: aead: atmel-gcm-aes encryption test failed (wrong result) on test
  vector 0, cfg="in-place (one sglist)"

Without selftests the broken atmel-gcm-aes is preferred at priority 300.
Seen on a SAM9X75 Curiosity with 6.18 and current mainline.

Write dd->datalen instead.

Fixes: d4419548dba9 ("crypto: atmel-aes - add support to GCM mode")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 50d97cef75b89..8e4de859cadc0 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1267,7 +1267,7 @@ static int atmel_aes_gcm_ghash_init(struct atmel_aes_dev *dd)
 	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
 
 	/* Set the data length. */
-	atmel_aes_write(dd, AES_AADLENR, dd->total);
+	atmel_aes_write(dd, AES_AADLENR, dd->datalen);
 	atmel_aes_write(dd, AES_CLENR, 0);
 
 	/* If needed, overwrite the GCM Intermediate Hash Word Registers */
-- 
2.53.0



