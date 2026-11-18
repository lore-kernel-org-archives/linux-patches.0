Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020001;
	b=23GZlr3RhI3drriASj88Ispj2gv6umeRGM6PEVstgd7fGvl7kpyKa1Kp9jD82bqFCr6b
	 AYU4So95wIaceDDzou1ZvhgZmJZTHNJW6Edpcsu7LbIIy+6cMpuhQMRfzkigugF6PkWMQ
	 v2lQxcivBshKAGThQv1Du9wtp7V0nFiL+lYQeUABZ5168rD6W55VRNL8+/DIWOOOeGD5o
	 XL88AudZbZveCb/hzhquy7IJG4QZGByNeh/2RbFAULDhbbXRSKAcueNHQr2TBqk8B/Xi3
	 m78oqH48SgOXDywnp8uuCBukOj725ipf1bRnuuIm6upUlLc50fIYmFb8lgkt3ZW/Ilw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=82sEStR98WK3+u7zBL9TV5Wxl59x8vhlsfjjnbQ/EOU=;
	b=q4VqZGz508oK0OyPlX0UbJvahxotchFMI0LdwO/hhe1v92bNPgFuK/lGqBukGzFgQ/oY
	 +BW4AyBC3Qrt2xEf+mhygaPkk8FXLv0xro/d9xEG6N/6VKD4Sbty5s04rtKLt0T+aANm0
	 nrOzETihTNjFdvCkfrnPanAW3lzGoBrR21Alczt5RRwt2cJBlaqwRY3a5Tth6rK/TqUuo
	 Sj3tsfFbkxqWz8MhccYEwDccTY83RvlMcrM3Fvinc8UGJIVixXARLwfFp9aUEF88rjWxh
	 rLcbkRhzLvQ+MK4Ew+T30aM0R23mpCOCPEjqkvO4T/ARe0uGRI3KfdCQSVCClufgiDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0V6oBW88;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A17606A31C;
	Wed, 18 Nov 2026 16:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0V6oBW88
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012451F000C4;
	Wed, 18 Nov 2026 16:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020001;
	bh=82sEStR98WK3+u7zBL9TV5Wxl59x8vhlsfjjnbQ/EOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0V6oBW88KDv6+CH49lXf48pgbn9zEjUL9rZ1iE+V9LbQrjDsuNBZOK0u7CrR2aUsn
	 enbAe+F8on+vL0ideLJcvWLXBzYWpdHy9swlsdIx6f3w2jIMzv2wp8QIYfzmaGFtsi
	 R5sFCBXXUuBoNQ5uSI59FZcFwQ2m0qbYOdDeLFi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1789/2651] ASoC: atmel-i2s: use optional API for muxclk
Date: Wed, 18 Nov 2026 15:50:29 +0100
Message-ID: <20261118150351.739916311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit be952abd69c1f2c845e42e72147751e4c910cd81 ]

The muxclk is an optional clock according to the device tree
binding.

Use devm_clk_get_optional() to handle the optional muxclk instead of
handling the missing clock explicitly.

When muxclk is not available, devm_clk_get_optional() returns NULL.
clk_set_parent() returns 0 when passed NULL, preserving the existing
behavior.

Unlike the existing code, errors other than -EPROBE_DEFER are now
returned instead of being silently ignored.

Fixes: b543e467d1a9 ("ASoC: atmel-i2s: add driver for the new Atmel I2S controller")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261002043856.97295-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-i2s.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/sound/soc/atmel/atmel-i2s.c b/sound/soc/atmel/atmel-i2s.c
index f28808d980ce6..c52d048449f8f 100644
--- a/sound/soc/atmel/atmel-i2s.c
+++ b/sound/soc/atmel/atmel-i2s.c
@@ -589,21 +589,15 @@ static int atmel_i2s_sama5d2_mck_init(struct atmel_i2s_dev *dev,
 				      struct device_node *np)
 {
 	struct clk *muxclk;
-	int err;
 
 	if (!dev->gclk)
 		return 0;
 
-	/* muxclk is optional, so we return error for probe defer only */
-	muxclk = devm_clk_get(dev->dev, "muxclk");
-	if (IS_ERR(muxclk)) {
-		err = PTR_ERR(muxclk);
-		if (err == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
-		dev_dbg(dev->dev,
-			"failed to get the I2S clock control: %d\n", err);
-		return 0;
-	}
+	/* muxclk is optional */
+	muxclk = devm_clk_get_optional(dev->dev, "muxclk");
+	if (IS_ERR(muxclk))
+		return dev_err_probe(dev->dev, PTR_ERR(muxclk),
+				     "failed to get the I2S clock control\n");
 
 	return clk_set_parent(muxclk, dev->gclk);
 }
-- 
2.53.0



