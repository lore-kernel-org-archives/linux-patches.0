Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052212;
	b=ynuU+uQ0IztMdBezbCHbBqL1k72XeW9UYLseC5992I6lxBIijjlv6BAUzmmqEiM6sGb0
	 /N5toSTDLAGQNkE94qb3QYK75xLioH88DTYAGwkhiSJeLCX0R9ujTWCiy/V6mkyZA+FMG
	 x6hBchLW9Q6Yq5yszD9sdhY7LB8x8jNRacQSlbpvTCmOkMDYs8ZKsC2yhpxT/m3RxvQ0Q
	 DDKzK9zxaTVyz/upPC/SN+L936GaABu6ICtGQkWiZMYmEzVVlX5B5qjA+y4QbeQRGEQZk
	 zz1/dA/vIMOmljkfhmG+kug1LKSS23GQ9fmdFEULPfLW2zzv/O2RIS/aeeJ1DfA51og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=icWBw7xl1ypqJ29q3MlJsJMtqN3nbNbHRYQ0cwbKvm4=;
	b=SDm0S+KARNHJEh+0FvT2e3G17NxXD/LWa/GbZPzmwkyTJpQREuL3p/LgyEE9zcSgIQwh
	 FJ83eFDosL1sfz+gAROJk82WURaCoo/YKw1mDzHzMxaVaNVkUemYe4zEETWcC9Q9qYy03
	 lxu4C9JZ/npCqJubEjGxGUov2HTF6REcNz75xMKjAzVMQM+T2NFGuueegL9l0H6RJ2iLK
	 XvNWuLv83Jf2wDTF/2yxGS6nyA6b2VbUud7h32cojYNG2juuxBUBXa13fBt3Hyoy8CrzM
	 ziklUyTifB+kDSlHtUXHVDWssxm7J3jEDwKNrHkEPiFPCbuMk+XBWJSq4jFnchFG2uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CzxsY1A1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BCE606A320;
	Thu, 19 Nov 2026 01:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CzxsY1A1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813C81F000C4;
	Thu, 19 Nov 2026 01:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052212;
	bh=icWBw7xl1ypqJ29q3MlJsJMtqN3nbNbHRYQ0cwbKvm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CzxsY1A1NOp9bvoFlKOTa00vifAOLiuiZFtYhBCsa220g7bC3qcOZjz2ln9v20gY9
	 EFwK96nSgOpLge4zfUenS7yUE2aB+cJQqjO5yp7OtOzWOYC45o/yd7k2ONSLCmwEh4
	 DdPsVTskwS1g+4TbUuduldFxDBahVYDgq9F+cyiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0484/2214] crypto: atmel-aes - fix AADLENR for standalone GHASH
Date: Wed, 18 Nov 2026 15:36:00 +0100
Message-ID: <20261118150030.579267443@linuxfoundation.org>
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
index 3d91b3f0e9090..d18fbb401375b 100644
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



