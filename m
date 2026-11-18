Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044990;
	b=up6V1JyjHHP464Q/qyiDmhd5549OLmBfCgicxtcwr91Wix+JMXUnPqOD1ZvDtGv1VklZ
	 ITKezchwq8M7NG0KSnDkgqSuqFKf6DD2fwM/QEc0FBSBKOlmPanfyiLUoufbwKt3GdR2/
	 I8AKCksnD76QN1MmZsBK/4AWNNe3nvX9/hiyy7fbWZhUCiL2rU7zofvv3umTJaHz6XlbN
	 B+UD2qMAYq/86kZd9k6nNMYL22eBF7QTkytftsXkaTFm4yoFnbV/hLcWrqw2GqhwCblzY
	 JQNQjMYr6KTtz5KftsE3XhHkAnA7wnZuoCL+OvgIupWZxs6YPjiCEGrl5/atMDFGukQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hI4GxQi5TgRAkzNoAUcEGpIpi8IQn5B5mTOUBQRyw1Q=;
	b=a5v98ADSDc1Mvzsy9rdFPAwILooYHnkomNXSWuwujQWbcntAXFrK6glYxTsGhmovwezJ
	 8vHpcz6wpybZAUvtQpdGeoq210MK6JQztal5TfWz6BJxGVNOZ3OKfrJvMiY/dfYOBAM+f
	 /deIPYvdqh5QTKOokPfv2iIs98SLhonrUR/aH0UELnKCEQPzdGXjEmOAGvbFSUDp/U3MK
	 Z190CpEcuuoAOvj3C01Rn1tN64NorQd3hY4IGErkU/f86ghGumXghxFjQEaF13tJTkgk/
	 XgBuwx5RCbybqkPryJecnva+Lv2OnAHpsU7hJ76+U7+PM+A4sa8IK82sTFM2X4RH7cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nrm8s+Tx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF20606A32F;
	Wed, 18 Nov 2026 23:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nrm8s+Tx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1671F000C5;
	Wed, 18 Nov 2026 23:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044990;
	bh=hI4GxQi5TgRAkzNoAUcEGpIpi8IQn5B5mTOUBQRyw1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nrm8s+TxLPJ4uxq43ZKRMuv3e/QOSWuX3D0LbP56vn/q/kP1qERh/DENRZASR7DSG
	 YjiEckEA+Gty7yUORQBOUIYD9zPKsZo+wm2YkDRw2PIsZpjHX926WsL68WSbUSyGDk
	 KSqIGqNOwp0zBV7yG2EzfD0MDAY/3jWH8AKS2flE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0763/2857] crypto: atmel-aes - fix AADLENR for standalone GHASH
Date: Wed, 18 Nov 2026 15:29:57 +0100
Message-ID: <20261118150229.027374911@linuxfoundation.org>
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
index 5574663d34037..c6be40e02d7bf 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1471,7 +1471,7 @@ static int atmel_aes_gcm_ghash_init(struct atmel_aes_dev *dd)
 	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
 
 	/* Set the data length. */
-	atmel_aes_write(dd, AES_AADLENR, dd->total);
+	atmel_aes_write(dd, AES_AADLENR, dd->datalen);
 	atmel_aes_write(dd, AES_CLENR, 0);
 
 	/* If needed, overwrite the GCM Intermediate Hash Word Registers */
-- 
2.53.0



