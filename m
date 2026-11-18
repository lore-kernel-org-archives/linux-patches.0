Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035901;
	b=u/Vj1ImQHkXpJRO2gxl1yd/CvZ0/B/DKqs8cPPjAHHNI64d5Fr1ldZlt2IakQAukYB3k
	 kG7SB3gs8aL6gKL1LCwjvG1DQ7QSa89urfKYWkSnGimoy0ckIESXEJtmOHOlnPKDO32KG
	 04j/sXgFgZlyczgbep0J/Ano4bYLEtjZxn28coWzdjKK3HbkyJbkdlm1TcB1Cd7DH59Yc
	 Yp3rsMzo94uqLeefrfMIihX2fXxdrn8M4OKbH48TSPejhJ/iblTmQLd+PcUvhlcVjHm7i
	 uJRzb9H+UnEaF/BK1DMflmtsXhP1PxeEgnI8S3bBuJ1xzxqyWF0xYkdy38pUxcAGpaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u2Oqck/41z2kMx3vP3K0ND0tJIEKngsZo0yvNrxxN1Q=;
	b=JXh+E9PrzKOD50qLpEyhcPrAGSgCLJqX3opQfvwI90XZ/l+crbIp2wa/lWQNmjTDT07f
	 mnZ48OvzK29gwPsUojxZOpNWgcbT8D9IVU3dTy1eAEtLjlax+jLHUSmczIpkT0axD2eE6
	 UWkxDwJB+RI/os9iPz8EEk/MmIe2IerotijXpIm2CpDoyzb5kTsB0dbwCcz9eXv6XJy4t
	 hlzVcQL1HJIc5IKbMbUPFRuoRJZX/BkOZf6Tqd25rT/8lv4D1UTCrio6oug9xCNAYQJld
	 Nc372tFp1RjIG1VrmSlcybVfPFVEGW7BJAoENZduBdMrF+1SjYJnthIc2htF6eDB5VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bdg2ivDN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAC7606CB4B;
	Wed, 18 Nov 2026 21:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bdg2ivDN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27B91F000C6;
	Wed, 18 Nov 2026 21:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035901;
	bh=u2Oqck/41z2kMx3vP3K0ND0tJIEKngsZo0yvNrxxN1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bdg2ivDNumbMCneu6dPqx9ua1DQwYRalkACbbhgpUZTR5LeiY9b6vqq5gJkK8E6Kw
	 4H1SCHjinGG/pcVc7KxLvinDsfkBovsgOqmnl5X8Kzy6vVkILwByk9u8D2Rt4N3cHt
	 cRiD/89xKy7uH+DzbBldTCfJwGz6T63JVDZAbDb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0867/3318] crypto: atmel-aes - fix AADLENR for standalone GHASH
Date: Wed, 18 Nov 2026 15:24:49 +0100
Message-ID: <20261118150345.313113739@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3402cf3f017f1..c968646d8104a 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1272,7 +1272,7 @@ static int atmel_aes_gcm_ghash_init(struct atmel_aes_dev *dd)
 	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
 
 	/* Set the data length. */
-	atmel_aes_write(dd, AES_AADLENR, dd->total);
+	atmel_aes_write(dd, AES_AADLENR, dd->datalen);
 	atmel_aes_write(dd, AES_CLENR, 0);
 
 	/* If needed, overwrite the GCM Intermediate Hash Word Registers */
-- 
2.53.0



