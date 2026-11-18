Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043768;
	b=rxrnSSADI/6khXmg2FiiK0SVTZKxU4xwDI1JwOzYxMDMnoEcda+vQw6dVnzPNUzl4Ms5
	 fye79+/hUPmb8oVq+x0K3mrxDn74oTOTHChq5qfCTubnalpqS/SvBoBk+NvR9unBm8Tn+
	 okNnc4ATyD9fQ7LhTgE6sXhNTPQ5BiK502jJhyZi8yjBBEOTi0HUe10odu0fluvpLaS7r
	 6YSCDsp8TOraBJcMf1+M+DTGyvwtCaJ4e8C0bK2PQFgX7gaMVjFGX3MpD6963Bd+Uuja/
	 meKJtVChtI29kCzaBSv3k038MkNUw0GikVuO0zv3B9R/+tCC2I1AeNaoNE2XqqcQJTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DQtS1IfRH1Jfy8rbVbHQnF4CfENl6bAuP3fPMT6pyBM=;
	b=tzGaiKNHVLntYeWwLaPtIjSwrSuBlPVy0jHp9NuBEfOqgyTlLrXeP6N53YMJMQGfHbdN
	 DuQcHCjd8C3Zll0CKl2rj2AKERp4dX19zQJGWD077cqMOMxO5mpKxVt6vyzrFqcS5naIb
	 NYrTjFj7pRdsqAi3G9QRE1PgOFBP5iISMy8EkEMRocby3DrEUX0zylLRVXEzoc9aktKOU
	 l5NsKwG9/Y5QsEMtDxuLXJDoNMXFx6LbHcw24hZrLBGv/awUDlxFSzLpqXUax4cX8BJWe
	 lJ/jfucApL45MsiSXhZluIqlI+eSTHvXgTajF8+Eq3R6b5XBm5U+wfuFBGuJ0ZOj2ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j9W9XMwP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F04606A31C;
	Wed, 18 Nov 2026 23:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j9W9XMwP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39E11F000C4;
	Wed, 18 Nov 2026 23:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043768;
	bh=DQtS1IfRH1Jfy8rbVbHQnF4CfENl6bAuP3fPMT6pyBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9W9XMwPEO/NHAL49P/ove61clU88xa3WZjtP86JjoHHpDWqvwixy3gjkf3UKyDYQ
	 FU2lQKwDjlqsTAzzYmNwYWgVGHaxVOxdsGVVDv42RlvQQyVkMPe/VBzANKqo0GuKhZ
	 QgvOSS+7iyVyyPsY2ZwpE9wKSd8kXHTnILmIAiQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0329/2857] crypto: atmel-ecc - avoid stale fallback key after set_secret failure
Date: Wed, 18 Nov 2026 15:22:43 +0100
Message-ID: <20261118150213.286195370@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit f07a0d251db7606e4792d2610788fbcc7b2c0d12 ]

Clear ->do_fallback before decoding a new ECDH secret and enable it only
after the software fallback accepts a caller-provided private key. This
avoids using a stale fallback key should crypto_kpp_set_secret() fail.

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-ecc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index b9c5832cf6fcc..a52379854a3ff 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -84,6 +84,7 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 
 	kfree(ctx->public_key);
 	ctx->public_key = NULL;
+	ctx->do_fallback = false;
 
 	if (crypto_ecdh_decode_key(buf, len, &params) < 0) {
 		dev_err(&ctx->client->dev, "crypto_ecdh_decode_key failed\n");
@@ -91,8 +92,9 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	}
 
 	if (params.key_size) {
-		ctx->do_fallback = true;
-		return crypto_kpp_set_secret(ctx->fallback, buf, len);
+		ret = crypto_kpp_set_secret(ctx->fallback, buf, len);
+		ctx->do_fallback = !ret;
+		return ret;
 	}
 
 	cmd = kmalloc(sizeof(*cmd), GFP_KERNEL);
@@ -103,8 +105,6 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	if (!public_key)
 		goto free_cmd;
 
-	ctx->do_fallback = false;
-
 	atmel_i2c_init_genkey_cmd(cmd, DATA_SLOT_2);
 
 	ret = atmel_i2c_send_receive(ctx->client, cmd);
-- 
2.53.0



