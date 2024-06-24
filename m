Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590E313A25D
	for <patches@lists.linux.dev>; Mon, 24 Jun 2024 11:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719228878; cv=none; b=O1iruebLBcqXxxpX1c2XDSngNldOlBz011r1bmkUtB/9yGUr1EE2z1W1h7E39JisyE6aMj92BgmG8ABDEIdeGuoGD0rb7VtBfZdH1DN2P9A+cu3symob78a8R6HqUE0QaBrXXql7JbHGz+8tusDcJRPAEMy8H88RRvawbyRoHXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719228878; c=relaxed/simple;
	bh=v4pEOq2KyOczU7HAYfd6jAGUPqtbLowFOyH3Gcsf68k=;
	h=From:To:Cc:Date:Message-Id:In-Reply-To:References:Subject; b=MPlBl43MoDcSoWm0lFBPZ3TcW+XebKbCQ7mfoZ4y4eT4eBAc0tCVPNQxD4ScToXjOjWpJO2tesa9DR9EYxveDnDoq9o7vo6KbvhxBep45h1gUwwUJR0WMCrQ6Zb3awm3SchUO53H78V4uCxhpqpx4NHrKdFWjwnWd3YUTwJF86M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAEDC32781
	for <patches@lists.linux.dev>; Mon, 24 Jun 2024 11:34:37 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Mon, 24 Jun 2024 12:34:34 +0100
Resent-Message-ID: <ZnlZyle7t5Ze_Bl0@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Mon, 24 Jun 2024 04:07:02 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=Gyrm=N2=everest-semi.com=zhangyi@kernel.org>)
	id 1sLa2l-006Y5A-Vl
	for broonie@sirena.co.uk; Mon, 24 Jun 2024 04:07:02 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id DED1160AD9
	for <broonie@sirena.co.uk>; Mon, 24 Jun 2024 03:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 988E0C32786; Mon, 24 Jun 2024 03:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DBAD5C4AF0A
	for <broonie@kernel.org>; Mon, 24 Jun 2024 03:06:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org DBAD5C4AF0A
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=everest-semi.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=everest-semi.com
Received: from unknown (HELO zy-virtual-machine.localdomain)([116.227.101.59])
	by sina.net (10.75.30.239) with ESMTP
	id 6678E2A10002B8DA; Mon, 24 Jun 2024 11:06:15 +0800 (CST)
X-Sender: zhangyi@everest-semi.com
X-Auth-ID: zhangyi@everest-semi.com
Authentication-Results: sina.net;
	 spf=none smtp.mailfrom=zhangyi@everest-semi.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=zhangyi@everest-semi.com
X-SMAIL-MID: 3E50B45B19E54113901157FF9F7EC4AC
X-SMAIL-UIID: 3E50B45B19E54113901157FF9F7EC4AC-20240624-110615
From: Zhang Yi <zhangyi@everest-semi.com>
To: alsa-devel@alsa-project.org,
	broonie@kernel.org
Cc: tiwai@suse.com,
	amadeuszx.slawinski@linux.intel.com,
	yangxiaohua@everest-semi.com,
	zhuning@everest-semi.com,
	zhangyi@everest-semi.com
Date: Mon, 24 Jun 2024 11:06:06 +0800
Message-Id: <20240624030607.4307-4-zhangyi@everest-semi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240624030607.4307-1-zhangyi@everest-semi.com>
References: <20240624030607.4307-1-zhangyi@everest-semi.com>
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=Gyrm=N2=everest-semi.com=zhangyi@kernel.org
Subject: [PATCH 3/4] ASoC: codecs: ES8326: Minimize the pop noise
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: FcWssr+7KmEf
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

Executing regcache_sync at initialization, we can hear a gentle pop
noise. So we created es8326_init for initialization instead of
executing es8326_resume

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
---
 sound/soc/codecs/es8326.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 95bf751d8bab..4f10ab5394ec 100755
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -950,14 +950,10 @@ static int es8326_calibrate(struct snd_soc_component *component)
 	return 0;
 }
 
-static int es8326_resume(struct snd_soc_component *component)
+static void es8326_init(struct snd_soc_component *component)
 {
 	struct es8326_priv *es8326 = snd_soc_component_get_drvdata(component);
 
-	regcache_cache_only(es8326->regmap, false);
-	regcache_sync(es8326->regmap);
-
-	/* reset internal clock state */
 	regmap_write(es8326->regmap, ES8326_RESET, 0x1f);
 	regmap_write(es8326->regmap, ES8326_VMIDSEL, 0x0E);
 	regmap_write(es8326->regmap, ES8326_ANA_LP, 0xf0);
@@ -1013,7 +1009,6 @@ static int es8326_resume(struct snd_soc_component *component)
 	regmap_update_bits(es8326->regmap, ES8326_ANA_MICBIAS, 0x0C, 0x0C);
 	usleep_range(50000, 70000);
 	regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x00);
-	regmap_write(es8326->regmap, ES8326_INT_SOURCE, ES8326_INT_SRC_PIN9);
 	regmap_write(es8326->regmap, ES8326_INTOUT_IO,
 		     es8326->interrupt_clk);
 	regmap_write(es8326->regmap, ES8326_SDINOUT1_IO,
@@ -1029,6 +1024,28 @@ static int es8326_resume(struct snd_soc_component *component)
 			   ES8326_MUTE);
 
 	regmap_write(es8326->regmap, ES8326_ADC_MUTE, 0x0f);
+	regmap_write(es8326->regmap, ES8326_CLK_DIV_LRCK, 0xff);
+
+	msleep(200);
+	regmap_write(es8326->regmap, ES8326_INT_SOURCE, ES8326_INT_SRC_PIN9);
+}
+
+static int es8326_resume(struct snd_soc_component *component)
+{
+	struct es8326_priv *es8326 = snd_soc_component_get_drvdata(component);
+	unsigned int reg;
+
+	regcache_cache_only(es8326->regmap, false);
+	regcache_cache_bypass(es8326->regmap, true);
+	regmap_read(es8326->regmap, ES8326_CLK_RESAMPLE, &reg);
+	regcache_cache_bypass(es8326->regmap, false);
+	/* reset internal clock state */
+	if (reg == 0x05)
+		regmap_write(es8326->regmap, ES8326_CLK_CTL, ES8326_CLK_ON);
+	else
+		es8326_init(component);
+
+	regcache_sync(es8326->regmap);
 
 	es8326_irq(es8326->irq, es8326);
 	return 0;
@@ -1088,7 +1105,7 @@ static int es8326_probe(struct snd_soc_component *component)
 	}
 	dev_dbg(component->dev, "interrupt-clk %x", es8326->interrupt_clk);
 
-	es8326_resume(component);
+	es8326_init(component);
 	return 0;
 }
 
-- 
2.17.1

