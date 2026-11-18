Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020183;
	b=sYipOI7yNcHcwwS6A0twztILoXU/74X8312SRpvkLAh4sx9+phzGsFn2ZeN2plBllG6x
	 G+Xn4N94DFTGBQ6PvShXUA4Kv4O1WkoyepTAVmCstXWLxdAnoqDSTpi3GD5RTRUdlTqRE
	 ytsvk9VM7OF0pUhqjrHx7bnZ4PT/RM2UsQqPrpzUrdtpRSWF2uh1HZhfBZgvKUoFg5BB6
	 UAzc7caGH4NscXptsMjFOgm8VwUkhCG4k/j0hjZQ/j3d2HZoEm9Z9NZv8k6/PMWz2IDB3
	 dIfTsfoMs8ohoIG/Lq4npmDK2ucxCmkDFRo4zau/hat6TIIqhWAKc9Ahylf/Tg3WsIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ms2OZWxmV++24jIEcENoeTz3w+BdpCPfebU77n9jd1w=;
	b=CPMluh1qHpwPGKdc/cHXTCg6nLfLNPb7dfPgZujNh4w5B0P0UXM8IL1Efx+uJkb7l+wy
	 WNy1OerZ5syjzOt3gnC/QBM5AlUZsL2Cs3cc4DFb8tSELL9vzL1qmdQdfqHmMF70dD1pz
	 jFeOmMftt6/nr+0OALVsQBY/yro2ZLxyNYxSzpR5JiIswdntCNZGBJaP6hDjs/viZblDD
	 65Mb80MTRYlSZS3hGUv9iuk2v33mwzL8DsePxYyTLGhRQLo15DK1mDUBCeK3/aN3vyZIt
	 yyHbDPMqAK7Tx3OqgDWcgbVZUlPe0dbc1fsR96pdw8zlxrUSBWTJamEVj6mKla5Lmaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s8cxYsgv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858EE606A331;
	Wed, 18 Nov 2026 16:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s8cxYsgv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25521F000C4;
	Wed, 18 Nov 2026 16:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020183;
	bh=ms2OZWxmV++24jIEcENoeTz3w+BdpCPfebU77n9jd1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8cxYsgvuowSjrId5K2Cq8RKBJtPcoZUbbhFXpK/uRO73lWrWcMgIRl08/1u9UtKE
	 EtyZdGGy+5RV9TcHp5F5rFiRQmoZIPKaOZCUPFMO95k8YWYFGF1oq/KDtaX29S9iWj
	 15dc7gzAwNDs0RK74u9SKfWNNbZykX2/FXgBX/2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Le Qi <le.qi@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1861/2651] ASoC: codecs: da7213: Get MCLK in I2C probe
Date: Wed, 18 Nov 2026 15:51:41 +0100
Message-ID: <20261118150353.994257672@linuxfoundation.org>
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

From: Le Qi <le.qi@oss.qualcomm.com>

[ Upstream commit 2923259d08b097bb3c39733f67e635a542ad8917 ]

With deferrable card binding, a card that fails to bind is retried only
when a new ASoC component is registered. da7213 requests its MCLK in the
component probe callback, so if the clock provider registers late, the
card bind defers and the provider's later registration never triggers
a rebind, leaving the sound card unregistered.

Request MCLK in the I2C probe instead, so a missing clock defers the
codec driver probe through the driver core before the component is
registered.

Fixes: 42d99857d6f0 ("ASoC: core: Move all users to deferrable card binding")
Signed-off-by: Le Qi <le.qi@oss.qualcomm.com>
Link: https://patch.msgid.link/20261014065321.740850-1-le.qi@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/da7213.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/da7213.c b/sound/soc/codecs/da7213.c
index 923b997efbc43..4990feaa8259c 100644
--- a/sound/soc/codecs/da7213.c
+++ b/sound/soc/codecs/da7213.c
@@ -2091,16 +2091,6 @@ static int da7213_probe(struct snd_soc_component *component)
 
 	pm_runtime_put_sync(component->dev);
 
-	/* Check if MCLK provided */
-	da7213->mclk = devm_clk_get_optional(component->dev, "mclk");
-	if (IS_ERR(da7213->mclk))
-		return PTR_ERR(da7213->mclk);
-	if (da7213->mclk)
-		/* Do automatic PLL handling assuming fixed clock until
-		 * set_pll() has been called. This makes the codec usable
-		 * with the simple-audio-card driver. */
-		da7213->fixed_clk_auto_pll = true;
-
 	/* Default infinite tone gen, start/stop by Kcontrol */
 	snd_soc_component_write(component, DA7213_TONE_GEN_CYCLES, DA7213_BEEP_CYCLES_MASK);
 
@@ -2229,6 +2219,19 @@ static int da7213_i2c_probe(struct i2c_client *i2c)
 
 	mutex_init(&da7213->ctrl_lock);
 
+	/* Check if MCLK provided */
+	da7213->mclk = devm_clk_get_optional(&i2c->dev, "mclk");
+	if (IS_ERR(da7213->mclk))
+		return dev_err_probe(&i2c->dev, PTR_ERR(da7213->mclk),
+				      "failed to get mclk\n");
+	if (da7213->mclk)
+		/*
+		 * Do automatic PLL handling assuming fixed clock until
+		 * set_pll() has been called. This makes the codec usable
+		 * with the simple-audio-card driver.
+		 */
+		da7213->fixed_clk_auto_pll = true;
+
 	pm_runtime_set_autosuspend_delay(&i2c->dev, 100);
 	pm_runtime_use_autosuspend(&i2c->dev);
 	pm_runtime_set_active(&i2c->dev);
-- 
2.53.0



