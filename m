Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058169;
	b=a2GkKyJmAveFpo7hxygl4bgODD/qMmRU1pLODaFki1jQsL+ie1SKSgIf/c8sMZOWbWz9
	 C1j4Wzcfr6t6T5l2MKUyj1KMt3a/aOX4s03zDQIcQXPQqtyPl1iheiaMEfpxqmrVIWA/X
	 RnPTfVR0tZotM/dgLmqzfyYxR2xKTXd3km1rSlg2YbQCHsIws2l8E8QJrGVfLYn6wq7I2
	 O43mWr4uCbSMeng7RUdF3O9VZZrHU0IWGAgRNN7h6MCGYmxzJ8PtPdzNhTMaojwwoTWHH
	 EtEYs9wWTDUl3UnX2zNWqrahCWD37yp59l0ke2ocDkTcn4tTe4CuJJybKpUdTV0J6nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pi3Fos6NwTUM08J9xmkPYzJj5GKgFNUI5PH0FVAhZg4=;
	b=jUkjwPlzF0KUSRi9wnYK0ZiffDY0S21XLkStW5oHQ4MY+Nkxn3Ourh0xmXm5TOD29Ad/
	 J7dz92d1NkZOqTQ91akIhnF5MkiBrEk9LGXw5rdasv8QTlA9Pt6/Q2oJfjn/eVHVAzIO2
	 BclNxmvtSPL7PpdoUG1KC3uwVvdUHMUk66Z+nZWLCyZUVZY2FiW44xaiwdywW3+t/kZps
	 XpoaVe9RpX8lZH/e3en1qnJKRWkAgC91cWbaPndYjKpYqfenFhB9PVSeCu8yq61hswFV3
	 8rVKLN0JNZZW5d1T1AU85MLgTgWOmVGcd+J0ummxkay6ksxc5OXmlmdJYzpdPUEb8kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QwCsVdlX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EFF606A31C;
	Thu, 19 Nov 2026 03:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QwCsVdlX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7BC1F000C4;
	Thu, 19 Nov 2026 03:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058169;
	bh=pi3Fos6NwTUM08J9xmkPYzJj5GKgFNUI5PH0FVAhZg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QwCsVdlXJlyiR1Jk9Lk1BLmexnkHesg7jfqCUHWo0gylC6YvhDDDgnOG/GennmjFu
	 iFENmXqJdqh1YDMDpmgVI0Qtdla21kkYKOdXCjkAAEs9eInlcXHgB9ivDuv24EfLDy
	 horbu8rAvYGQR+LbmB7x0wBqomZ4E6wbxsqoF8kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0389/1848] crypto: atmel-aes - fix AADLENR for standalone GHASH
Date: Wed, 18 Nov 2026 15:40:27 +0100
Message-ID: <20261118145929.995576649@linuxfoundation.org>
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
index 059c7db591fac..8f69245660a6d 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1434,7 +1434,7 @@ static int atmel_aes_gcm_ghash_init(struct atmel_aes_dev *dd)
 	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
 
 	/* Set the data length. */
-	atmel_aes_write(dd, AES_AADLENR, dd->total);
+	atmel_aes_write(dd, AES_AADLENR, dd->datalen);
 	atmel_aes_write(dd, AES_CLENR, 0);
 
 	/* If needed, overwrite the GCM Intermediate Hash Word Registers */
-- 
2.53.0



