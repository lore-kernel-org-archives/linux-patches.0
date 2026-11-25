Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621514;
	b=ib4AylZXkhYb1rhJHU5xxwSUWMD5VvK7e6+vcvyyZzNOy+boeoJTh33ag+EKOdMRff1Y
	 LLwEEzn4ncbGDNwZHrPu9u27yer3wGeKQ/JNQ82aYVTge19/ieXn2xyo/AQwHg9Z2N7P7
	 h6FazOpJNlDl/OaZNoLx++N8midW0N1W5TDaFDMKSNJrspMzWLp8nfQJ9RsNc5joWYCE/
	 uX0tboNyXPhd6MSKlwiEsCQ+1cqOV1Dd4vhyFeJUj3IzKMZgQVr2Xd2AcvMZ/TnZ3VVI9
	 pUXabH8s1V50SOs6bleocBvMJ+UEFhhL3CsU//wHkq6VpDB+X9lhEMLtm5qhjzOzerw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CQv0cLolnXiG9OiiA0dqzxkwzHZNa4YaH8jhwul2hKw=;
	b=N0lcOG3+HkgA4oYUELN95/dIwUkCwKI6FTAPBiEvTD4ZsPIC4FKMTsTffmJgB7XFuAbD
	 yflQXnbcnkHYe6HplO+Vflp5dljKTLjvVmPVq9RrwD79xDmTojuiA0xkU67M4gwWOE6Rk
	 tJ7zZyNhxMtytzmie+Zel8COlCLj6UTTxw+cF4vuUz17RcKKjM58jMWo3D2FTSCDlHonP
	 K93HVHp/gDqpmJ3tCr4NRLH4AekbBUV3DB1AJnwu9a2EnCuW0zv+7Ynd10m1eH/lyQOoB
	 IwSQqh9p31xSCqGItOeeZ6k8piBNDuG22toa3mxU7Ho+OdTCmbs4wkbYlLbt154hxLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DfxwRCf3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738A8606A321;
	Wed, 25 Nov 2026 15:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DfxwRCf3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39611F000C0;
	Wed, 25 Nov 2026 15:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621514;
	bh=CQv0cLolnXiG9OiiA0dqzxkwzHZNa4YaH8jhwul2hKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DfxwRCf3K0LWCVJENKHswug3JAGpVfbJZ+W7/9batLTNBWI3RBsWdZB9Q5nHoXw0D
	 agFfFpF+LlUW32mTcUe7oSJ73q2uDffkVyck2oP6JeZi4XmpyqsUFTFuPVcc9H+XW3
	 5ewre58ELXKzai6PmuN80glfn/AXlYJo0FKvYcs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sugar Zhang <sugar.zhang@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 247/990] ASoC: rockchip: spdif: Add support for set mclk rate
Date: Wed, 25 Nov 2026 15:26:54 +0100
Message-ID: <20261125143827.876996585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sugar Zhang <sugar.zhang@rock-chips.com>

[ Upstream commit 298082783a0d6d07109f8ce09ab410a1de12876d ]

Allow setting the mclk rate from the machine driver.

Signed-off-by: Sugar Zhang <sugar.zhang@rock-chips.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://patch.msgid.link/20260203-rockchip-spdif-cleanup-and-bsp-sync-v2-7-4412016cf577@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 67a7e2073909 ("ASoC: rockchip_spdif: select REGMAP_MMIO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_spdif.c | 34 +++++++++++++++++++----------
 sound/soc/rockchip/rockchip_spdif.h |  2 +-
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_spdif.c b/sound/soc/rockchip/rockchip_spdif.c
index 7a15f680de2fe..cf6935dc40f2b 100644
--- a/sound/soc/rockchip/rockchip_spdif.c
+++ b/sound/soc/rockchip/rockchip_spdif.c
@@ -110,12 +110,15 @@ static int rk_spdif_hw_params(struct snd_pcm_substream *substream,
 			      struct snd_soc_dai *dai)
 {
 	struct rk_spdif_dev *spdif = snd_soc_dai_get_drvdata(dai);
+	unsigned int mclk_rate = clk_get_rate(spdif->mclk);
 	unsigned int val = SPDIF_CFGR_HALFWORD_ENABLE;
-	int srate, mclk;
+	int bmc, div;
 	int ret;
 
-	srate = params_rate(params);
-	mclk = srate * 128;
+	/* bmc = 128fs */
+	bmc = 128 * params_rate(params);
+	div = DIV_ROUND_CLOSEST(mclk_rate, bmc);
+	val |= SPDIF_CFGR_CLK_DIV(div);
 
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S16_LE:
@@ -131,14 +134,6 @@ static int rk_spdif_hw_params(struct snd_pcm_substream *substream,
 		return -EINVAL;
 	}
 
-	/* Set clock and calculate divider */
-	ret = clk_set_rate(spdif->mclk, mclk);
-	if (ret != 0) {
-		dev_err(spdif->dev, "Failed to set module clock rate: %d\n",
-			ret);
-		return ret;
-	}
-
 	ret = regmap_update_bits(spdif->regmap, SPDIF_CFGR,
 				 SPDIF_CFGR_CLK_DIV_MASK |
 				 SPDIF_CFGR_HALFWORD_ENABLE |
@@ -201,7 +196,24 @@ static int rk_spdif_dai_probe(struct snd_soc_dai *dai)
 	return 0;
 }
 
+static int rk_spdif_set_sysclk(struct snd_soc_dai *dai,
+			       int clk_id, unsigned int freq, int dir)
+{
+	struct rk_spdif_dev *spdif = snd_soc_dai_get_drvdata(dai);
+	int ret;
+
+	if (!freq)
+		return 0;
+
+	ret = clk_set_rate(spdif->mclk, freq);
+	if (ret)
+		dev_err(spdif->dev, "Failed to set mclk: %d\n", ret);
+
+	return ret;
+}
+
 static const struct snd_soc_dai_ops rk_spdif_dai_ops = {
+	.set_sysclk = rk_spdif_set_sysclk,
 	.probe = rk_spdif_dai_probe,
 	.hw_params = rk_spdif_hw_params,
 	.trigger = rk_spdif_trigger,
diff --git a/sound/soc/rockchip/rockchip_spdif.h b/sound/soc/rockchip/rockchip_spdif.h
index d8be9aae5b195..fcc28b6c4f586 100644
--- a/sound/soc/rockchip/rockchip_spdif.h
+++ b/sound/soc/rockchip/rockchip_spdif.h
@@ -15,7 +15,7 @@
 */
 #define SPDIF_CFGR_CLK_DIV_SHIFT	(16)
 #define SPDIF_CFGR_CLK_DIV_MASK		(0xff << SPDIF_CFGR_CLK_DIV_SHIFT)
-#define SPDIF_CFGR_CLK_DIV(x)		(x << SPDIF_CFGR_CLK_DIV_SHIFT)
+#define SPDIF_CFGR_CLK_DIV(x)		((x-1) << SPDIF_CFGR_CLK_DIV_SHIFT)
 
 #define SPDIF_CFGR_HALFWORD_SHIFT	2
 #define SPDIF_CFGR_HALFWORD_DISABLE	(0 << SPDIF_CFGR_HALFWORD_SHIFT)
-- 
2.53.0



