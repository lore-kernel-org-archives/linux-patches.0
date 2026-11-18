Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041485;
	b=3cvYjc2Z2fqKUFcJB9hxNNTCs6Uf6R/+Wu7zsgIV+EJ/8EL5am5aaXqut9nkhKL1TU8H
	 KPLtYSl6jg+tUcMwkOL0TIgCesWl/KpkF6v1+P2kSEQhcYvbBC/LQJQj8SqEbpVPLDfOO
	 Ogc4FVB9okIhy00YWh2meAXOnB1ocIxaQm0xye0a1Xrgl2iDl7OR0ZlT4LzWe1uAaFRG/
	 dWOqXTR+tvYzrJvBKx8yfDAE+p9GkK0FEaBiQJe9WAI4OhvqK5ObxT4JAnEhtsyynmXnf
	 dOCzYIc6/aEwrS2PBAw8G7I/Rgs8M9PcsbPcgztyedssJ9y0UHyeIuAZL166g9rEzOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+NogD+UPcrtZlzb+XjQVE06EbpPFRTxQvPA/KkRMGN4=;
	b=bjvseKIEyJKyLl5ZYcGFFam1CScVr3pQiMXYhE99XH6rPp7d56o1Nujqy+UpblGuN8d4
	 Ec00CxIa63K3yqyF6wC6/sdrcHb8GSmqiLWm2iIpOqDmnkNkfgD83OdJauINjLrpnMqZN
	 VPHJjezu4jZIROhPjeNgSY/RaFJR4/ht86G3Ey02tkmbZHPkYiHVYOqB+tXbYJIBBbIdY
	 t1cgjruNkSJIOEEj4MvmCbahb4eLsIrMTHmKQDDjKAC6xLZsDhVrRTD+QhKj3qggclNN+
	 yEkSl6qgXNcEmrOXKiRUA3ymqSGLNJXzBzaCoHk4W1aI8ARMi0KdYokpUkT6w9+wjhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ORj6M9zY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72504606A332;
	Wed, 18 Nov 2026 22:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ORj6M9zY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7470B1F000C6;
	Wed, 18 Nov 2026 22:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041485;
	bh=+NogD+UPcrtZlzb+XjQVE06EbpPFRTxQvPA/KkRMGN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ORj6M9zYLgqS3mmM7Yso0/Gf7GR03UdCv+b+FnEMYhG+24oUoMuhz8cqoO+4QXGRQ
	 uXRfX0MiFI1Rcml3BKifIpPCiqIG7PJV/oy0AT+ZPQMKoc/KSKKwaBUfAtGN1t7s1k
	 3oB9RJskWS8TbPNqYLRtABWT0PW/1V6nHkUZhNqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2830/3318] ASoC: atmel-i2s: fix MCK generator error handling
Date: Wed, 18 Nov 2026 15:57:32 +0100
Message-ID: <20261118150445.532836451@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 2e2da92de9bffd2cdbb9a2558fe60de7f1bb09e3 ]

Disable the gclk and reset the MCK configuration when an error occurs
while enabling the MCK generator.

This prevents the gclk from remaining enabled after a failed clock
configuration.

Fixes: 73ad0df57290 ("ASoC: atmel-i2s: Remove unnecessary audio PLL clock (aclk)")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261002043856.97295-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-i2s.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/sound/soc/atmel/atmel-i2s.c b/sound/soc/atmel/atmel-i2s.c
index 6c20c643f3218..e26d6cf864dec 100644
--- a/sound/soc/atmel/atmel-i2s.c
+++ b/sound/soc/atmel/atmel-i2s.c
@@ -466,11 +466,21 @@ static int atmel_i2s_switch_mck_generator(struct atmel_i2s_dev *dev,
 	mr |= ATMEL_I2SC_MR_IMCKMODE_I2SMCK;
 	ret = regmap_update_bits(dev->regmap, ATMEL_I2SC_MR, mr_mask, mr);
 	if (ret)
-		return ret;
+		goto err_disable_gclk;
 
 	/* Finally enable the I2S Master Clock generator. */
-	return regmap_write(dev->regmap, ATMEL_I2SC_CR,
-			    ATMEL_I2SC_CR_CKEN);
+	ret = regmap_write(dev->regmap, ATMEL_I2SC_CR, ATMEL_I2SC_CR_CKEN);
+	if (ret)
+		goto err_reset_mr;
+
+	return 0;
+
+err_reset_mr:
+	regmap_update_bits(dev->regmap, ATMEL_I2SC_MR, mr_mask, 0);
+err_disable_gclk:
+	clk_disable_unprepare(dev->gclk);
+
+	return ret;
 }
 
 static int atmel_i2s_trigger(struct snd_pcm_substream *substream, int cmd,
-- 
2.53.0



