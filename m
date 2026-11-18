Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031730;
	b=bQlxBs3fQCxKsUpJm4P3WR8N9S5oLPXpwtbLhe3EtCYdVErG4OE7Yk1cA3FZyNvjvhZA
	 7YwB9c4WP6SDhL+dKuEB7+/F1aS155RVdAaBd/rjl+9Y5vsD+Z6lxdJ8IuQGkhuygH6c5
	 emBn/201geNVclW4UYaljRylghU7rfQJVkuABG6hHyj4iZ8pQKwdlSfcJHZx3QiTxU8gX
	 ZprJudkdeccOeYxtQEJbjGf3MM5Z6yjE1tUYM6b8Lf+Zs7hf8P+nQlHSjavpbjxa+/GLo
	 C5II9fW4A6/KllZ4h5LrJzid6iOOmKeZWa9u6PFuZrs/lwd+Zlu8sZBHxUZr2Qj4Pcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V92VplOL36nNuuCAvAYccDzNnr9namgylpSyinoY+bc=;
	b=uGAl+1/6AXQiwHvtqjjz9xMlfQ2Il+s51SUAIFtuL6Q/XHTIiUFp3kM3PeSzGBUw4UuZ
	 Dx0QTF5lj2LaadX7EEVEFUHTT/56sfLTQfk0wwNqD+FUP3PKibbxXFJARKSZU8Ffx2JQi
	 L/q5rwnj35WyVs4VOcVW8nRhBqSOjXORmEq9TYP1fjwd64AmNMel5yBOl4MUMHp9S3TT1
	 4D563/VAJu3xtHYMoYmkjHaV+vvQ2jOzcOwjpc5qPI3HghgBC/jdDi55zrgK2jOmz87a/
	 50uxQgeHVR87KpXPkzx75Hk8lxnDkzZnLUg6eSMUTc/JbEh31sHPgbgRrkJ6S1/II6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ceoIVRhX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA231606A320;
	Wed, 18 Nov 2026 19:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ceoIVRhX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3F21F000C4;
	Wed, 18 Nov 2026 19:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031730;
	bh=V92VplOL36nNuuCAvAYccDzNnr9namgylpSyinoY+bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ceoIVRhXeLT78x0lIfL21eDh0tpzaZcVc1gf9pT1n+1tbtgiPyQFYd2aNRmu2tuLI
	 MpIQnSkaPhs9hyON9aMx6UiCoGp3LB4I5m+cKhSkpuxhbRFZ7wjs5CvWf6ERjKcZ56
	 autR+rqO798wUW875E4f0jrW3JejMBTcITs+xuu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1162/1756] ASoC: atmel-i2s: fix MCK generator error handling
Date: Wed, 18 Nov 2026 15:54:49 +0100
Message-ID: <20261118150056.259012505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 762199faf872e..f1f8a2d0008ce 100644
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



