Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1239313BC0E
	for <patches@lists.linux.dev>; Mon, 24 Jun 2024 11:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719228875; cv=none; b=hGiyFQ6UDRcYYpcWsQkNnZiJKJ3pY/JjFK0klub5vIpT1EVOvV9yp1pssCyyeM3gqWIabulmZ00bLwsBNy/XEaIQMppSi+CJxbqceCa3x8yLFp6P9xHSPVHYkytj4WcgmLy+duRej2IcSZSL3Ztsc7ya7VVZgp9jmesmPNyImSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719228875; c=relaxed/simple;
	bh=HeYnn2+dl8cfrms6otkFFZfFhtM5NtP3TFk1r1EJl34=;
	h=From:To:Cc:Date:Message-Id:In-Reply-To:References:Subject; b=Pe3qS3C+LnOAOzUd4R72WIhT4sF8uBty+VKh+A79/s41Hss/7/baEPP+sHhGWpLWT+rTP/jx+JNcJNGL+qVHMrgWns0hVdEv4nLmTquUTOnC4F09KJQjosa8Pcz5JYToRJYM/bHQh8fZO8l4B1TVpvicW+kM8Na+b2iCVNskcv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BA6C2BBFC
	for <patches@lists.linux.dev>; Mon, 24 Jun 2024 11:34:33 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Mon, 24 Jun 2024 12:34:31 +0100
Resent-Message-ID: <ZnlZx4M7BUjKBSv8@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Mon, 24 Jun 2024 04:07:02 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=Gyrm=N2=everest-semi.com=zhangyi@kernel.org>)
	id 1sLa2l-006Y58-U3
	for broonie@sirena.co.uk; Mon, 24 Jun 2024 04:07:02 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id CFB30608C3
	for <broonie@sirena.co.uk>; Mon, 24 Jun 2024 03:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 96432C2BD10; Mon, 24 Jun 2024 03:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 818B9C4AF07
	for <broonie@kernel.org>; Mon, 24 Jun 2024 03:06:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 818B9C4AF07
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=everest-semi.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=everest-semi.com
Received: from unknown (HELO zy-virtual-machine.localdomain)([116.227.101.59])
	by sina.net (10.75.30.239) with ESMTP
	id 6678E2A10002B8DA; Mon, 24 Jun 2024 11:06:14 +0800 (CST)
X-Sender: zhangyi@everest-semi.com
X-Auth-ID: zhangyi@everest-semi.com
Authentication-Results: sina.net;
	 spf=none smtp.mailfrom=zhangyi@everest-semi.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=zhangyi@everest-semi.com
X-SMAIL-MID: 4133754A44F7435C98A7B3A18DE2F114
X-SMAIL-UIID: 4133754A44F7435C98A7B3A18DE2F114-20240624-110614
From: Zhang Yi <zhangyi@everest-semi.com>
To: alsa-devel@alsa-project.org,
	broonie@kernel.org
Cc: tiwai@suse.com,
	amadeuszx.slawinski@linux.intel.com,
	yangxiaohua@everest-semi.com,
	zhuning@everest-semi.com,
	zhangyi@everest-semi.com
Date: Mon, 24 Jun 2024 11:06:05 +0800
Message-Id: <20240624030607.4307-3-zhangyi@everest-semi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240624030607.4307-1-zhangyi@everest-semi.com>
References: <20240624030607.4307-1-zhangyi@everest-semi.com>
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=Gyrm=N2=everest-semi.com=zhangyi@kernel.org
Subject: [PATCH 2/4] ASoC: codecs: ES8326: codec can't enter suspend issue
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: UKkJ7WKsT5oZ
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

When widgets "MICBIAS1" and "MICBIAS2" are active, the codec cannot enter
suspend mode. So we removed these two widgets.We replaced enable_micbias and
disable_micbias with regmap_update_bits to make sure the codec can enter
suspend mode.

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
---
 sound/soc/codecs/es8326.c | 34 +++++-----------------------------
 1 file changed, 5 insertions(+), 29 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 8c9d79686185..95bf751d8bab 100755
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -286,8 +286,6 @@ static const struct snd_soc_dapm_widget es8326_dapm_widgets[] = {
 	/* Analog Power Supply*/
 	SND_SOC_DAPM_DAC("Right DAC", NULL, ES8326_ANA_PDN, 0, 1),
 	SND_SOC_DAPM_DAC("Left DAC", NULL, ES8326_ANA_PDN, 1, 1),
-	SND_SOC_DAPM_SUPPLY("MICBIAS1", ES8326_ANA_MICBIAS, 2, 0, NULL, 0),
-	SND_SOC_DAPM_SUPPLY("MICBIAS2", ES8326_ANA_MICBIAS, 3, 0, NULL, 0),
 
 	SND_SOC_DAPM_PGA("LHPMIX", ES8326_DAC2HPMIX, 7, 0, NULL, 0),
 	SND_SOC_DAPM_PGA("RHPMIX", ES8326_DAC2HPMIX, 3, 0, NULL, 0),
@@ -697,28 +695,6 @@ static struct snd_soc_dai_driver es8326_dai = {
 	.symmetric_rate = 1,
 };
 
-static void es8326_enable_micbias(struct snd_soc_component *component)
-{
-	struct snd_soc_dapm_context *dapm = snd_soc_component_get_dapm(component);
-
-	snd_soc_dapm_mutex_lock(dapm);
-	snd_soc_dapm_force_enable_pin_unlocked(dapm, "MICBIAS1");
-	snd_soc_dapm_force_enable_pin_unlocked(dapm, "MICBIAS2");
-	snd_soc_dapm_sync_unlocked(dapm);
-	snd_soc_dapm_mutex_unlock(dapm);
-}
-
-static void es8326_disable_micbias(struct snd_soc_component *component)
-{
-	struct snd_soc_dapm_context *dapm = snd_soc_component_get_dapm(component);
-
-	snd_soc_dapm_mutex_lock(dapm);
-	snd_soc_dapm_disable_pin_unlocked(dapm, "MICBIAS1");
-	snd_soc_dapm_disable_pin_unlocked(dapm, "MICBIAS2");
-	snd_soc_dapm_sync_unlocked(dapm);
-	snd_soc_dapm_mutex_unlock(dapm);
-}
-
 /*
  *	For button detection, set the following in soundcard
  *	snd_jack_set_key(jack->jack, SND_JACK_BTN_0, KEY_PLAYPAUSE);
@@ -822,7 +798,7 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 	if ((iface & ES8326_HPINSERT_FLAG) == 0) {
 		/* Jack unplugged or spurious IRQ */
 		dev_dbg(comp->dev, "No headset detected\n");
-		es8326_disable_micbias(es8326->component);
+		regmap_update_bits(es8326->regmap, ES8326_ANA_MICBIAS, 0x0C, 0x00);
 		if (es8326->jack->status & SND_JACK_HEADPHONE) {
 			dev_dbg(comp->dev, "Report hp remove event\n");
 			snd_soc_jack_report(es8326->jack, 0, SND_JACK_HEADSET);
@@ -860,7 +836,7 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 			regmap_write(es8326->regmap, ES8326_INT_SOURCE, 0x00);
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x01);
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x10, 0x00);
-			es8326_enable_micbias(es8326->component);
+			regmap_update_bits(es8326->regmap, ES8326_ANA_MICBIAS, 0x0C, 0x0C);
 			usleep_range(50000, 70000);
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x00);
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x10, 0x10);
@@ -1034,7 +1010,7 @@ static int es8326_resume(struct snd_soc_component *component)
 			(ES8326_HP_DET_SRC_PIN9 | es8326->jack_pol) :
 			(ES8326_HP_DET_SRC_PIN9 | es8326->jack_pol | 0x04)));
 	usleep_range(5000, 10000);
-	es8326_enable_micbias(es8326->component);
+	regmap_update_bits(es8326->regmap, ES8326_ANA_MICBIAS, 0x0C, 0x0C);
 	usleep_range(50000, 70000);
 	regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x00);
 	regmap_write(es8326->regmap, ES8326_INT_SOURCE, ES8326_INT_SRC_PIN9);
@@ -1063,7 +1039,7 @@ static int es8326_suspend(struct snd_soc_component *component)
 	struct es8326_priv *es8326 = snd_soc_component_get_drvdata(component);
 
 	cancel_delayed_work_sync(&es8326->jack_detect_work);
-	es8326_disable_micbias(component);
+	regmap_update_bits(es8326->regmap, ES8326_ANA_MICBIAS, 0x0C, 0x00);
 	es8326->calibrated = false;
 	regmap_write(es8326->regmap, ES8326_CLK_MUX, 0x2d);
 	regmap_write(es8326->regmap, ES8326_DAC2HPMIX, 0x00);
@@ -1142,7 +1118,7 @@ static void es8326_disable_jack_detect(struct snd_soc_component *component)
 
 	mutex_lock(&es8326->lock);
 	if (es8326->jack->status & SND_JACK_MICROPHONE) {
-		es8326_disable_micbias(component);
+		regmap_update_bits(es8326->regmap, ES8326_ANA_MICBIAS, 0x0C, 0x00);
 		snd_soc_jack_report(es8326->jack, 0, SND_JACK_HEADSET);
 	}
 	es8326->jack = NULL;
-- 
2.17.1

