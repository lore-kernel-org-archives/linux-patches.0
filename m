Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026968;
	b=lOdJcLNLe5gsDruu/Brdt2FQV8EVk82Cg0BCWIBLFbaSnHORZGnyppVzdHJ9GKfAK5FZ
	 KG99LYwK7p0w+YhqwZQMFTVB0MY36lcsZK6gnsdpzMhcLVip/aBKb2p1HFpTsPyUJ06bQ
	 XaDThT92K6XV2rLkrX4IGZBpUUKKx+i7qz1vVEaV1lBM9HuRdI1QaAx88MqdZFHSOcxJo
	 irCGcKTI8SDNdQVyH4nrgLN2SrCq3x0e7lka3wKuZuOEi1H4rEDShyE/DHeOI7eICnUH0
	 b7jMmx9P/VDQeOxlfhqWpyep3Y0dWrxizV0IQSw62oroCjQF15ncsnmugf7Od4z/C5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n6a+j5/ODSiwaqht+2PgzOpiPQ7pOunMkpXthQLIjpE=;
	b=UtfM793wqkPQ07Lb2v6nyipc9WCrX5Mk7qKZxOUDFcGBojCDM7Z3bVICp7PBUH8dXRB9
	 Ra19qYCIjlvbE/WM2EoIOTfpVjNcFT4YcVHeg3nDLX+Ux00gmUCk9i4ptZTTPwvrc7MQ8
	 oKTGJU9p0CZ8x7LnlFaQo4IYvum89KDPs8Yiy6IsTiEsMbTaebjqIzCYRZeLsPnLlGtEX
	 iZpucH93Rc6R+wQlwbqOjdy/KPjTg/ouPTlMWX45bOW50AMi88hz70Js7P/bUpzedZ5Mz
	 wsVzqwLLiaLWIMyyvhXLGbFyZdtXtJmK0+jqYLTF54Ipgb2txY0kcT8+kHo6xEqHREQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LoJVXySC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00BB606A338;
	Wed, 18 Nov 2026 18:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LoJVXySC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C861F000C5;
	Wed, 18 Nov 2026 18:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026968;
	bh=n6a+j5/ODSiwaqht+2PgzOpiPQ7pOunMkpXthQLIjpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LoJVXySCLcKXWe/MvfUpueL5yRx6SUJ4w/sOyREZ3ilRezMTaEHl+3Nhz376bMUbN
	 oUnOYz/tWAc2sn5CBMQr1ArPAiuNAEErFq7fvQF1i+g2iZK473bnteJnO8AqslKAv7
	 4DDeBDwsTgeoeh5XeZjLpOS53MhDFk2sX+dRMWfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1623/2151] ASoC: rockchip: fix device node reference leak in rk3288_hdmi_analog
Date: Wed, 18 Nov 2026 15:55:58 +0100
Message-ID: <20261118150220.998744389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit f15b2df0b940cb2c01797f78791de3279d514086 ]

snd_rk_mc_probe() acquires references to the codec and CPU device nodes
with of_parse_phandle() and stores them in the static rk_dailink, but the
driver never calls of_node_put() on them. All error paths and the success
path simply return, and the driver has no remove callback, so the
references are leaked for the whole lifetime of the card and each failed
or repeated probe leaks another pair. The same pattern was fixed for the
sibling rockchip_rt5645.c driver.

Release the codec and CPU device nodes on every probe error path and in a
new remove callback, and also drop the extra reference placed in args.np
by of_parse_phandle_with_fixed_args().

Fixes: eaae2ea73593 ("ASoC: rockchip: Add machine driver for RK3288 boards that use analog/HDMI")
Assisted-by: DeepSeek-V4.1-Flash
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20261008181459.2762862-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rk3288_hdmi_analog.c | 42 +++++++++++++++++++------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/sound/soc/rockchip/rk3288_hdmi_analog.c b/sound/soc/rockchip/rk3288_hdmi_analog.c
index d5395f2e6a5c6..4cfb0f290928c 100644
--- a/sound/soc/rockchip/rk3288_hdmi_analog.c
+++ b/sound/soc/rockchip/rk3288_hdmi_analog.c
@@ -200,36 +200,59 @@ static int snd_rk_mc_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(&pdev->dev,
 			"Unable to parse property 'rockchip,audio-codec'\n");
-		return ret;
+		goto put_codec_of_node;
 	}
 
 	ret = snd_soc_get_dai_name(&args, &rk_dailink.codecs[0].dai_name);
-	if (ret)
-		return dev_err_probe(&pdev->dev, ret,
-				     "Unable to get codec_dai_name\n");
+	of_node_put(args.np);
+	if (ret) {
+		dev_err_probe(&pdev->dev, ret,
+			      "Unable to get codec_dai_name\n");
+		goto put_codec_of_node;
+	}
 
 	rk_dailink.cpus->of_node = of_parse_phandle(np, "rockchip,i2s-controller",
 						  0);
 	if (!rk_dailink.cpus->of_node) {
 		dev_err(&pdev->dev,
 			"Property 'rockchip,i2s-controller' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_codec_of_node;
 	}
 
 	rk_dailink.platforms->of_node = rk_dailink.cpus->of_node;
 
 	ret = snd_soc_of_parse_audio_routing(card, "rockchip,routing");
 	if (ret)
-		return ret;
+		goto put_cpu_of_node;
 
 	snd_soc_card_set_drvdata(card, machine);
 
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
-	if (ret)
-		return dev_err_probe(&pdev->dev, ret,
-				     "Soc register card failed\n");
+	if (ret) {
+		dev_err_probe(&pdev->dev, ret,
+			      "Soc register card failed\n");
+		goto put_cpu_of_node;
+	}
 
 	return 0;
+
+put_cpu_of_node:
+	of_node_put(rk_dailink.cpus->of_node);
+	rk_dailink.cpus->of_node = NULL;
+put_codec_of_node:
+	of_node_put(rk_dailink.codecs[0].of_node);
+	rk_dailink.codecs[0].of_node = NULL;
+
+	return ret;
+}
+
+static void snd_rk_mc_remove(struct platform_device *pdev)
+{
+	of_node_put(rk_dailink.cpus->of_node);
+	rk_dailink.cpus->of_node = NULL;
+	of_node_put(rk_dailink.codecs[0].of_node);
+	rk_dailink.codecs[0].of_node = NULL;
 }
 
 static const struct of_device_id rockchip_sound_of_match[] = {
@@ -241,6 +264,7 @@ MODULE_DEVICE_TABLE(of, rockchip_sound_of_match);
 
 static struct platform_driver rockchip_sound_driver = {
 	.probe = snd_rk_mc_probe,
+	.remove = snd_rk_mc_remove,
 	.driver = {
 		.name = DRV_NAME,
 		.pm = &snd_soc_pm_ops,
-- 
2.53.0



